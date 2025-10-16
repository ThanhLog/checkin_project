from fastapi import FastAPI, HTTPException, status, File, UploadFile, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from typing import List, Optional
from bson import ObjectId
from datetime import datetime
import shutil
import os
import re
import numpy as np
from send_fcm import send_fcm

from helpers import doc_helper
from models import (
    UserCreate, UserResponse, SystemInfo, 
    Address, PersonalInfo, Identification, 
    FaceData, Image, CheckinSettings,
    HotelBookingCreate, HotelBookingResponse, HotelBooking,
    # Medical models
    MedicalAppointmentCreate, MedicalAppointmentResponse, MedicalAppointment
    
)
from database import users_collection, hotel_bookings_collection, medical_appointments_collection
from face_recognition_service import FaceRecognitionService

# --- FastAPI app ---
app = FastAPI(
    title="Face Checkin API",
    description="API cho hệ thống checkin bằng khuôn mặt",
    version="2.0.0"
)

# --- CORS ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Image directory ---
IMAGE_DIR = "user_images"
FACE_IMAGE_DIR = os.path.join(IMAGE_DIR, "faces")
os.makedirs(FACE_IMAGE_DIR, exist_ok=True)

# --- Khởi tạo Face Recognition Service ---
face_service = FaceRecognitionService()

# --- Helper: MongoDB doc -> JSON ---
def user_helper(user: dict) -> dict:
    user["_id"] = str(user["_id"])
    return user

# --- Root ---
@app.get("/")
async def root():
    return {"message": "Face Checkin API v2.0 đang hoạt động!"}

# --- CREATE user + upload ảnh + tính embeddings ---
@app.post("/users/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(
    user_id: str = Form(...),
    cccd: str = Form(""),
    full_name: str = Form(...),
    fcm_token: str = Form(""),
    date_of_birth: str = Form(""),
    gender: str = Form(""),
    email: str = Form(""),
    tel: str = Form(""),  
    # Address fields
    street: str = Form(""),
    ward: str = Form(""),
    district: str = Form(""),
    city: str = Form(""),
    # Identification fields
    id_number: str = Form(""),
    issue_date: Optional[str] = Form(None),
    issue_place: str = Form(""),
    regis_tration_date: str = Form(""),
    # Face data fields
    face_image: UploadFile = File(...),
    embedding_version: str = Form("1.0"),
    # System info
    status_user: str = Form("active"),
    is_verified: bool = Form(False)
):
    """
    Tạo user mới với face recognition
    - Upload ảnh khuôn mặt (BẮT BUỘC)
    - Tự động extract embeddings bằng face_recognition
    - Lưu vào database
    """
    try:
        # Kiểm tra user đã tồn tại chưa
        existing_user = users_collection.find_one({"user_id": user_id})
        if existing_user:
            raise HTTPException(
                status_code=400, 
                detail=f"User với user_id '{user_id}' đã tồn tại"
            )

        # Kiểm tra ảnh khuôn mặt
        if not face_image or not face_image.filename:
            raise HTTPException(
                status_code=400,
                detail="Ảnh khuôn mặt là bắt buộc để tạo tài khoản"
            )

        # Đọc ảnh
        image_content = await face_image.read()
        
        # Lưu ảnh tạm để xử lý
        file_extension = os.path.splitext(face_image.filename)[1] or ".jpg"
        temp_filename = f"temp_{user_id}{file_extension}"
        temp_path = os.path.join(FACE_IMAGE_DIR, temp_filename)
        
        with open(temp_path, "wb") as buffer:
            buffer.write(image_content)
        
        try:
            # Extract embeddings từ ảnh
            embeddings = face_service.extract_embeddings(temp_path)
            
            if embeddings is None:
                # Xóa file tạm
                if os.path.exists(temp_path):
                    os.remove(temp_path)
                raise HTTPException(
                    status_code=400,
                    detail="Không phát hiện được khuôn mặt trong ảnh. Vui lòng upload ảnh rõ ràng hơn."
                )
            
            # Đổi tên file từ temp sang file chính thức
            face_filename = f"{user_id}{file_extension}"
            face_image_path = os.path.join(FACE_IMAGE_DIR, face_filename)
            
            # Xóa file cũ nếu tồn tại
            if os.path.exists(face_image_path):
                os.remove(face_image_path)
            
            # Đổi tên file
            os.rename(temp_path, face_image_path)
            
            face_image_url = f"/images/faces/{face_filename}"
            file_size = os.path.getsize(face_image_path)
            file_format = file_extension[1:]
            
        except HTTPException:
            raise
        except Exception as e:
            # Xóa file tạm nếu có lỗi
            if os.path.exists(temp_path):
                os.remove(temp_path)
            raise HTTPException(
                status_code=500,
                detail=f"Lỗi khi xử lý ảnh khuôn mặt: {str(e)}"
            )

        # Tạo đối tượng Address
        address = Address(
            street=street,
            ward=ward,
            district=district,
            city=city
        )

        # Tạo đối tượng PersonalInfo
        personal_info = PersonalInfo(
            full_name=full_name,
            date_of_birth=date_of_birth,
            tel = tel,
            email = email,
            gender=gender,
            address=address
        )

        # Tạo đối tượng Identification
        identification_data = {
            "id_number": id_number,
            "issue_place": issue_place
        }
        
        if issue_date:
            try:
                identification_data["issue_date"] = datetime.fromisoformat(issue_date)
            except:
                pass
                
        identification = Identification(**identification_data)

        # Tạo đối tượng FaceData với embeddings thực tế
        face_data = FaceData(
            embeddings=embeddings,  # Embeddings thực từ face_recognition
            face_image_url=face_image_url,
            embedding_version=embedding_version,
            created_at=datetime.utcnow()
        )

        # Tạo danh sách images
        images = []
        if face_image_url:
            image_obj = Image(
                image_url=face_image_url,
                image_type="face",
                uploaded_at=datetime.utcnow(),
                file_size=file_size,
                file_format=file_format
            )
            images.append(image_obj)

        # Tạo đối tượng SystemInfo
        system_info = SystemInfo(
            registration_date=datetime.utcnow(),
            last_updated=datetime.utcnow(),
            status=status_user,
            is_verified=is_verified
        )

        # Tạo đối tượng CheckinSettings mặc định
        checkin_settings = CheckinSettings()

        # Tạo user document
        user_data = UserCreate(
            user_id=user_id,
            personal_info=personal_info,
            fcm_token=fcm_token,
            identification=identification,
            face_data=face_data,
            images=images,
            system_info=system_info,
            checkin_settings=checkin_settings
        )

        # Chuyển đổi sang dict
        user_dict = user_data.model_dump(exclude_none=True, by_alias=True)

        # Thêm vào MongoDB
        result = users_collection.insert_one(user_dict)
        
        # Lấy user vừa tạo
        new_user = users_collection.find_one({"_id": result.inserted_id})
        
        return UserResponse(**user_helper(new_user))

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi khi tạo user: {str(e)}")

# --- CREATE user từ JSON (có embeddings sẵn) ---
@app.post("/users/json/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user_from_json(user_data: UserCreate):
    """
    Tạo user từ JSON (dành cho trường hợp đã có embeddings)
    """
    try:
        # Kiểm tra user đã tồn tại chưa
        existing_user = users_collection.find_one({"user_id": user_data.user_id})
        if existing_user:
            raise HTTPException(
                status_code=400, 
                detail=f"User với user_id '{user_data.user_id}' đã tồn tại"
            )
        
        # Cập nhật thời gian hệ thống
        current_time = datetime.utcnow()
        if user_data.system_info:
            user_data.system_info.registration_date = current_time
            user_data.system_info.last_updated = current_time
        else:
            user_data.system_info = SystemInfo(
                registration_date=current_time,
                last_updated=current_time
            )
        
        # Chuyển đổi sang dict
        user_dict = user_data.model_dump(exclude_none=True, by_alias=True)

        # Thêm vào MongoDB
        result = users_collection.insert_one(user_dict)
        
        # Lấy user vừa tạo
        new_user = users_collection.find_one({"_id": result.inserted_id})
        
        return UserResponse(**user_helper(new_user))

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi khi tạo user: {str(e)}")

# --- FACE RECOGNITION: Login bằng khuôn mặt ---
@app.post("/auth/face-login")
async def face_login(
    face_image: UploadFile = File(...),
    fcm_token: Optional[str] = Form(None)
):
    """
    Đăng nhập bằng khuôn mặt
    - Upload ảnh khuôn mặt
    - So sánh với database
    - Trả về thông tin user nếu khớp
    """
    try:
        # Đọc ảnh từ upload
        image_content = await face_image.read()
        
        # Lưu ảnh tạm
        temp_filename = f"temp_login_{datetime.utcnow().timestamp()}.jpg"
        temp_path = os.path.join(FACE_IMAGE_DIR, temp_filename)
        
        with open(temp_path, "wb") as buffer:
            buffer.write(image_content)
        
        try:
            # Extract embeddings từ ảnh upload
            uploaded_embeddings = face_service.extract_embeddings(temp_path)
            
            if uploaded_embeddings is None:
                raise HTTPException(
                    status_code=400,
                    detail="Không phát hiện được khuôn mặt trong ảnh"
                )
            
            # Lấy tất cả users có face_data
            all_users = list(users_collection.find({
                "face_data.embeddings": {"$exists": True, "$ne": []}
            }))
            
            if not all_users:
                raise HTTPException(
                    status_code=404, 
                    detail="Không tìm thấy user nào trong hệ thống"
                )
            
            # Tìm user khớp nhất
            best_match = None
            best_distance = float('inf')
            threshold = 0.6  # Ngưỡng khoảng cách (càng nhỏ càng giống)
            
            for user in all_users:
                stored_embeddings = user.get("face_data", {}).get("embeddings", [])
                if not stored_embeddings:
                    continue
                
                # Tính khoảng cách Euclidean
                distance = face_service.calculate_distance(uploaded_embeddings, stored_embeddings)
                
                if distance < best_distance:
                    best_distance = distance
                    best_match = user
            
            # Xóa file tạm
            if os.path.exists(temp_path):
                os.remove(temp_path)
            
            # Kiểm tra ngưỡng
            if best_match and best_distance <= threshold:
                # Cập nhật last login time + fcm token
                update_fields = {
                    "system_info.last_login": datetime.utcnow(),
                }
                if fcm_token:
                    update_fields["fcm_token"] = fcm_token

                users_collection.update_one(
                    {"_id": best_match["_id"]},
                    {"$set": update_fields}
                )
                
                # Tính confidence (0-100%)
                confidence = max(0, (1 - best_distance) * 100)
                
                return {
                    "success": True,
                    "message": "Đăng nhập thành công",
                    "user": user_helper(best_match),
                    "confidence": round(confidence, 2),
                    "distance": round(best_distance, 4)
                }
            else:
                raise HTTPException(
                    status_code=401, 
                    detail=f"Không tìm thấy khuôn mặt khớp trong hệ thống (distance: {best_distance:.4f})"
                )
        
        finally:
            # Đảm bảo xóa file tạm
            if os.path.exists(temp_path):
                os.remove(temp_path)
            
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Lỗi khi xử lý face login: {str(e)}"
        )

# --- FACE RECOGNITION: Verify face với user_id cụ thể ---
@app.post("/auth/face-verify/{user_id}")
async def face_verify(user_id: str, face_image: UploadFile = File(...)):
    """
    Xác thực khuôn mặt với user_id cụ thể
    """
    try:
        # Tìm user
        user = users_collection.find_one({"user_id": user_id})
        if not user:
            raise HTTPException(status_code=404, detail="User không tồn tại")
        
        # Kiểm tra user có face data không
        stored_embeddings = user.get("face_data", {}).get("embeddings", [])
        if not stored_embeddings:
            raise HTTPException(
                status_code=400, 
                detail="User chưa có dữ liệu khuôn mặt"
            )
        
        # Đọc ảnh từ upload
        image_content = await face_image.read()
        
        # Lưu ảnh tạm
        temp_filename = f"temp_verify_{user_id}_{datetime.utcnow().timestamp()}.jpg"
        temp_path = os.path.join(FACE_IMAGE_DIR, temp_filename)
        
        with open(temp_path, "wb") as buffer:
            buffer.write(image_content)
        
        try:
            # Extract embeddings
            uploaded_embeddings = face_service.extract_embeddings(temp_path)
            
            if uploaded_embeddings is None:
                raise HTTPException(
                    status_code=400,
                    detail="Không phát hiện được khuôn mặt trong ảnh"
                )
            
            # Tính khoảng cách
            distance = face_service.calculate_distance(uploaded_embeddings, stored_embeddings)
            threshold = 0.6
            
            is_match = distance <= threshold
            confidence = max(0, (1 - distance) * 100)
            
            # Xóa file tạm
            if os.path.exists(temp_path):
                os.remove(temp_path)
            
            if is_match:
                # Cập nhật last verification time
                users_collection.update_one(
                    {"_id": user["_id"]},
                    {"$set": {"system_info.last_verification": datetime.utcnow()}}
                )
            
            return {
                "success": is_match,
                "message": "Xác thực thành công" if is_match else "Khuôn mặt không khớp",
                "user_id": user_id,
                "confidence": round(confidence, 2),
                "distance": round(distance, 4),
                "threshold": threshold
            }
        
        finally:
            # Đảm bảo xóa file tạm
            if os.path.exists(temp_path):
                os.remove(temp_path)
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Lỗi khi xác thực khuôn mặt: {str(e)}"
        )

# --- FACE RECOGNITION: Update face embeddings ---
@app.put("/users/{user_id}/face-embeddings")
async def update_face_embeddings(
    user_id: str, 
    face_image: UploadFile = File(...),
    embedding_version: str = Form("1.0")
):
    """
    Cập nhật face embeddings cho user
    """
    try:
        # Tìm user
        user = users_collection.find_one({"user_id": user_id})
        if not user:
            raise HTTPException(status_code=404, detail="User không tồn tại")
        
        # Đọc ảnh
        image_content = await face_image.read()
        
        # Lưu ảnh tạm
        file_extension = os.path.splitext(face_image.filename)[1] or ".jpg"
        temp_filename = f"temp_update_{user_id}{file_extension}"
        temp_path = os.path.join(FACE_IMAGE_DIR, temp_filename)
        
        with open(temp_path, "wb") as buffer:
            buffer.write(image_content)
        
        try:
            # Extract embeddings
            new_embeddings = face_service.extract_embeddings(temp_path)
            
            if new_embeddings is None:
                raise HTTPException(
                    status_code=400,
                    detail="Không phát hiện được khuôn mặt trong ảnh"
                )
            
            # Đổi tên file
            face_filename = f"{user_id}{file_extension}"
            face_image_path = os.path.join(FACE_IMAGE_DIR, face_filename)
            
            # Xóa file cũ nếu tồn tại
            if os.path.exists(face_image_path):
                os.remove(face_image_path)
            
            os.rename(temp_path, face_image_path)
            face_image_url = f"/images/faces/{face_filename}"
            
            # Cập nhật database
            result = users_collection.update_one(
                {"user_id": user_id},
                {
                    "$set": {
                        "face_data.embeddings": new_embeddings,
                        "face_data.face_image_url": face_image_url,
                        "face_data.embedding_version": embedding_version,
                        "face_data.created_at": datetime.utcnow(),
                        "system_info.last_updated": datetime.utcnow()
                    }
                }
            )
            
            if result.matched_count == 0:
                raise HTTPException(status_code=400, detail="Cập nhật thất bại")
            
            updated_user = users_collection.find_one({"user_id": user_id})
            
            return {
                "success": True,
                "message": "Cập nhật face embeddings thành công",
                "user": user_helper(updated_user)
            }
        
        finally:
            # Đảm bảo xóa file tạm
            if os.path.exists(temp_path):
                os.remove(temp_path)
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Lỗi khi cập nhật embeddings: {str(e)}"
        )

# --- Serve ảnh ---
@app.get("/images/{folder}/{image_filename}")
async def get_user_image(folder: str, image_filename: str):
    file_path = os.path.join(IMAGE_DIR, folder, image_filename)
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="Image không tồn tại")
    return FileResponse(file_path)

# --- READ all users ---
@app.get("/users/", response_model=List[UserResponse])
async def get_all_users(skip: int = 0, limit: int = 100):
    users = list(users_collection.find().skip(skip).limit(limit))
    return [user_helper(user) for user in users]

# --- READ user by user_id ---
@app.get("/users/{user_id}", response_model=UserResponse)
async def get_user_by_id(user_id: str):
    user = users_collection.find_one({"user_id": user_id})
    if not user:
        raise HTTPException(status_code=404, detail="User không tồn tại")
    return user_helper(user)

# --- READ user by MongoDB _id ---
@app.get("/users/id/{user_mongo_id}", response_model=UserResponse)
async def get_user_by_mongo_id(user_mongo_id: str):
    if not ObjectId.is_valid(user_mongo_id):
        raise HTTPException(status_code=400, detail="ID không hợp lệ")
    user = users_collection.find_one({"_id": ObjectId(user_mongo_id)})
    if not user:
        raise HTTPException(status_code=404, detail="User không tồn tại")
    return user_helper(user)

# --- UPDATE user ---
@app.put("/users/{user_id}", response_model=UserResponse)
async def update_user(user_id: str, user_update: UserCreate):
    existing_user = users_collection.find_one({"user_id": user_id})
    if not existing_user:
        raise HTTPException(status_code=404, detail="User không tồn tại")

    update_data = user_update.model_dump(exclude_none=True, by_alias=True)
    
    # Cập nhật last_updated
    if "system_info" in update_data:
        update_data["system_info"]["last_updated"] = datetime.utcnow()
    else:
        update_data["system_info"] = {"last_updated": datetime.utcnow()}

    result = users_collection.update_one(
        {"user_id": user_id}, 
        {"$set": update_data}
    )
    
    if result.matched_count == 0:
        raise HTTPException(status_code=400, detail="Cập nhật thất bại")

    updated_user = users_collection.find_one({"user_id": user_id})
    return user_helper(updated_user)

# --- DELETE user ---
@app.delete("/users/{user_id}")
async def delete_user(user_id: str):
    # Tìm user để lấy thông tin ảnh
    user = users_collection.find_one({"user_id": user_id})
    if not user:
        raise HTTPException(status_code=404, detail="User không tồn tại")
    
    # Xóa ảnh nếu có
    if user.get("face_data", {}).get("face_image_url"):
        image_path = user["face_data"]["face_image_url"].replace("/images/", "")
        full_path = os.path.join(IMAGE_DIR, image_path)
        if os.path.exists(full_path):
            os.remove(full_path)
    
    # Xóa các ảnh khác
    for img in user.get("images", []):
        if img.get("image_url"):
            image_path = img["image_url"].replace("/images/", "")
            full_path = os.path.join(IMAGE_DIR, image_path)
            if os.path.exists(full_path):
                os.remove(full_path)
    
    # Xóa user khỏi database
    result = users_collection.delete_one({"user_id": user_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="User không tồn tại")
    
    return {"message": f"User {user_id} đã được xóa thành công"}

# --- SEARCH user by name ---
@app.get("/users/search/name/{name}", response_model=List[UserResponse])
async def search_users_by_name(name: str):
    users = list(users_collection.find({
        "personal_info.full_name": {"$regex": name, "$options": "i"}
    }))
    return [user_helper(user) for user in users]

# --- Get user statistics ---
@app.get("/users/stats/summary")
async def get_user_statistics():
    total_users = users_collection.count_documents({})
    active_users = users_collection.count_documents({"system_info.status": "active"})
    verified_users = users_collection.count_documents({"system_info.is_verified": True})
    
    return {
        "total_users": total_users,
        "active_users": active_users,
        "verified_users": verified_users,
        "inactive_users": total_users - active_users
    }

# --- Health check ---
@app.get("/health")
async def health_check():
    try:
        # Kiểm tra kết nối database
        users_collection.find_one()
        return {
            "status": "healthy",
            "database": "connected",
            "face_recognition": "active",
            "timestamp": datetime.utcnow()
        }
    except Exception as e:
        raise HTTPException(
            status_code=503, 
            detail=f"Service unhealthy: {str(e)}"
        )

@app.get("/health")
async def health_check():
    try:
        users_collection.find_one()
        hotel_bookings_collection.find_one()
        medical_appointments_collection.find_one()
        return {
            "status": "healthy",
            "database": "connected",
            "collections": {
                "users": "OK",
                "hotel_bookings": "OK",
                "medical_appointments": "OK"
            },
            "face_recognition": "active",
            "timestamp": datetime.utcnow()
        }
    except Exception as e:
        raise HTTPException(status_code=503, detail=f"Service unhealthy: {str(e)}")


# ==================== HOTEL BOOKING APIs ====================

@app.post("/hotel/bookings/", response_model=HotelBookingResponse, status_code=status.HTTP_201_CREATED)
async def create_hotel_booking(booking_data: HotelBookingCreate):
    """
    Tạo booking khách sạn mới
    """
    try:
        # Kiểm tra user tồn tại
        user = users_collection.find_one({"user_id": booking_data.user_id})
        if not user:
            raise HTTPException(status_code=404, detail="User không tồn tại")
        
        # Kiểm tra user có face data không
        if not user.get("face_data", {}).get("embeddings"):
            raise HTTPException(
                status_code=400,
                detail="User chưa có dữ liệu khuôn mặt. Vui lòng upload ảnh khuôn mặt trước."
            )
        
        # Tạo booking object
        booking = HotelBooking(
            user_id=booking_data.user_id,
            hotel_name=booking_data.hotel_name,
            hotel_address=booking_data.hotel_address,
            hotel_phone=booking_data.hotel_phone,
            room_info=booking_data.room_info,
            check_in_date=booking_data.check_in_date,
            check_out_date=booking_data.check_out_date,
            number_of_guests=booking_data.number_of_guests,
            total_amount=booking_data.total_amount,
            deposit_amount=booking_data.deposit_amount,
            payment_method=booking_data.payment_method,
            additional_services=booking_data.additional_services,
            special_requests=booking_data.special_requests
        )
        
        # Chuyển sang dict và lưu
        booking_dict = booking.model_dump(exclude_none=True)
        result = hotel_bookings_collection.insert_one(booking_dict)
        
        # Lấy booking vừa tạo
        new_booking = hotel_bookings_collection.find_one({"_id": result.inserted_id})
        
        return HotelBookingResponse(**doc_helper(new_booking))
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi tạo booking: {str(e)}")


@app.post("/hotel/check-in/{booking_id}")
async def hotel_face_check_in(booking_id: str, face_image: UploadFile = File(...)):
    """
    Check-in khách sạn bằng khuôn mặt + gửi thông báo FCM
    """
    try:
        # --- 1️⃣ Tìm booking ---
        booking = hotel_bookings_collection.find_one({"booking_id": booking_id})
        if not booking:
            raise HTTPException(status_code=404, detail="Booking không tồn tại")
        
        if booking["status"] not in ["pending", "confirmed"]:
            raise HTTPException(
                status_code=400, 
                detail=f"Không thể check-in. Trạng thái hiện tại: {booking['status']}"
            )
        
        # --- 2️⃣ Lấy thông tin user ---
        user = users_collection.find_one({"user_id": booking["user_id"]})
        if not user:
            raise HTTPException(status_code=404, detail="User không tồn tại")
        
        stored_embeddings = user.get("face_data", {}).get("embeddings", [])
        if not stored_embeddings:
            raise HTTPException(status_code=400, detail="User chưa có dữ liệu khuôn mặt")
        
        # --- 3️⃣ Xử lý ảnh ---
        image_content = await face_image.read()
        temp_filename = f"temp_hotel_checkin_{booking_id}_{datetime.utcnow().timestamp()}.jpg"
        temp_path = os.path.join(FACE_IMAGE_DIR, temp_filename)
        
        with open(temp_path, "wb") as buffer:
            buffer.write(image_content)
        
        try:
            # --- 4️⃣ Extract embeddings và so sánh ---
            uploaded_embeddings = face_service.extract_embeddings(temp_path)
            if uploaded_embeddings is None:
                raise HTTPException(status_code=400, detail="Không phát hiện được khuôn mặt trong ảnh")
            
            distance = face_service.calculate_distance(uploaded_embeddings, stored_embeddings)
            threshold = 0.6
            is_match = distance <= threshold
            confidence = max(0, (1 - distance) * 100)
            
            verification_log = {
                "timestamp": datetime.utcnow(),
                "action": "check_in",
                "verified": is_match,
                "confidence": confidence,
                "distance": distance
            }
            
            # --- 5️⃣ Nếu khớp khuôn mặt ---
            if is_match:
                check_in_time = datetime.utcnow()

                # ✅ Cập nhật booking
                hotel_bookings_collection.update_one(
                    {"booking_id": booking_id},
                    {
                        "$set": {
                            "status": "checked_in",
                            "actual_check_in": check_in_time,
                            "check_in_method": "face_recognition",
                            "check_in_face_verified": True,
                            "updated_at": check_in_time
                        },
                        "$push": {
                            "face_verification_logs": verification_log
                        }
                    }
                )

                # --- 6️⃣ Gửi thông báo FCM ---
                fcm_token = user.get("fcm_token")
                if fcm_token:
                    hotel_name = booking.get("hotel_name", "Khách sạn của bạn")
                    room_number = booking.get("room_info", {}).get("room_number", "N/A")

                    # Format thời gian dễ đọc
                    formatted_time = check_in_time.strftime("%H:%M %d/%m/%Y")

                    # ✉️ Nội dung thông báo
                    title = f"🏨 {hotel_name}"
                    body = (
                        f"Phòng: {room_number}\n"
                        f"Thời gian check-in: {formatted_time}\n"
                        "Cảm ơn bạn đã tin tưởng lựa chọn khách sạn của chúng tôi!"
                    )

                    send_fcm(
                        token=fcm_token,
                        title=title,
                        body=body,
                        data={
                            "booking_id": booking_id,
                            "hotel_name": hotel_name,
                            "room_number": room_number,
                            "check_in_time": formatted_time,
                            "screen": "booking_detail"
                        }
                    )

                return {
                    "success": True,
                    "message": "Check-in thành công",
                    "booking_id": booking_id,
                    "user_id": booking["user_id"],
                    "hotel_name": booking.get("hotel_name"),
                    "room_number": booking.get("room_info", {}).get("room_number"),
                    "check_in_time": check_in_time,
                    "confidence": round(confidence, 2)
                }

            # --- 7️⃣ Nếu không khớp ---
            else:
                hotel_bookings_collection.update_one(
                    {"booking_id": booking_id},
                    {"$push": {"face_verification_logs": verification_log}}
                )
                raise HTTPException(
                    status_code=401,
                    detail=f"Xác thực khuôn mặt thất bại (confidence: {confidence:.2f}%)"
                )

        finally:
            if os.path.exists(temp_path):
                os.remove(temp_path)
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi check-in: {str(e)}")

@app.post("/hotel/check-out/{booking_id}")
async def hotel_face_check_out(booking_id: str, face_image: UploadFile = File(...)):
    """
    Check-out khách sạn bằng khuôn mặt và gửi thông báo cảm ơn
    """
    try:
        # 1️⃣ Tìm booking
        booking = hotel_bookings_collection.find_one({"booking_id": booking_id})
        if not booking:
            raise HTTPException(status_code=404, detail="Booking không tồn tại")
        
        if booking["status"] != "checked_in":
            raise HTTPException(
                status_code=400,
                detail=f"Không thể check-out. Trạng thái hiện tại: {booking['status']}"
            )

        # 2️⃣ Lấy thông tin user
        user = users_collection.find_one({"user_id": booking["user_id"]})
        if not user:
            raise HTTPException(status_code=404, detail="User không tồn tại")
        
        stored_embeddings = user.get("face_data", {}).get("embeddings", [])
        if not stored_embeddings:
            raise HTTPException(status_code=400, detail="User chưa có dữ liệu khuôn mặt")

        # 3️⃣ Xử lý ảnh khuôn mặt
        image_content = await face_image.read()
        temp_filename = f"temp_hotel_checkout_{booking_id}_{datetime.utcnow().timestamp()}.jpg"
        temp_path = os.path.join(FACE_IMAGE_DIR, temp_filename)
        with open(temp_path, "wb") as buffer:
            buffer.write(image_content)

        try:
            # 4️⃣ Xác thực khuôn mặt
            uploaded_embeddings = face_service.extract_embeddings(temp_path)
            if uploaded_embeddings is None:
                raise HTTPException(status_code=400, detail="Không phát hiện được khuôn mặt")

            distance = face_service.calculate_distance(uploaded_embeddings, stored_embeddings)
            is_match = distance <= 0.6
            confidence = max(0, (1 - distance) * 100)

            verification_log = {
                "timestamp": datetime.utcnow(),
                "action": "check_out",
                "verified": is_match,
                "confidence": confidence,
                "distance": distance
            }

            if is_match:
                check_out_time = datetime.utcnow()

                # 5️⃣ Cập nhật trạng thái booking
                hotel_bookings_collection.update_one(
                    {"booking_id": booking_id},
                    {
                        "$set": {
                            "status": "checked_out",
                            "actual_check_out": check_out_time,
                            "check_out_method": "face_recognition",
                            "check_out_face_verified": True,
                            "updated_at": check_out_time
                        },
                        "$push": {"face_verification_logs": verification_log}
                    }
                )

                # 6️⃣ Gửi thông báo cảm ơn qua FCM
                fcm_token = user.get("fcm_token")
                if fcm_token:
                    hotel_name = booking.get("hotel_name", "Khách sạn của bạn")
                    room_number = booking.get("room_info", {}).get("room_number", "N/A")
                    
                    formatted_time = check_out_time.strftime("%H:%M %d/%m/%Y")
                    
                    title = f"🏨 {hotel_name}"
                    body = (
                        f"Phòng: {room_number}\n"
                        f"Thời gian check-out: {formatted_time}\n"
                        "Cảm ơn bạn đã tin tưởng lựa chọn khách sạn của chúng tôi!"
                    )
                    
                    # Gửi FCM
                    send_fcm(
                        token=fcm_token,
                        title=title,
                        body=body,
                        data={
                            "booking_id": booking_id,
                            "hotel_name": hotel_name,
                            "room_number": room_number,
                            "check_out_time": formatted_time,
                            "screen": "booking_detail"
                        }
                    )
                # 7️⃣ Phản hồi thành công
                return {
                    "success": True,
                    "message": "Check-out thành công",
                    "booking_id": booking_id,
                    "check_out_time": check_out_time,
                    "confidence": round(confidence, 2)
                }

            else:
                raise HTTPException(status_code=401, detail="Xác thực khuôn mặt thất bại")

        finally:
            if os.path.exists(temp_path):
                os.remove(temp_path)

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi check-out: {str(e)}")

@app.get("/hotel/bookings/", response_model=List[HotelBookingResponse])
async def get_all_hotel_bookings(skip: int = 0, limit: int = 100):
    """Lấy tất cả bookings"""
    bookings = list(hotel_bookings_collection.find().skip(skip).limit(limit))
    return [HotelBookingResponse(**doc_helper(b)) for b in bookings]


@app.get("/hotel/bookings/user/{user_id}", response_model=List[HotelBookingResponse])
async def get_user_hotel_bookings(user_id: str):
    """Lấy bookings của 1 user"""
    bookings = list(hotel_bookings_collection.find({"user_id": user_id}))
    return [HotelBookingResponse(**doc_helper(b)) for b in bookings]


@app.get("/hotel/bookings/{booking_id}", response_model=HotelBookingResponse)
async def get_hotel_booking(booking_id: str):
    """Lấy thông tin booking"""
    booking = hotel_bookings_collection.find_one({"booking_id": booking_id})
    if not booking:
        raise HTTPException(status_code=404, detail="Booking không tồn tại")
    return HotelBookingResponse(**doc_helper(booking))


@app.delete("/hotel/bookings/{booking_id}")
async def cancel_hotel_booking(booking_id: str):
    """Hủy booking"""
    result = hotel_bookings_collection.update_one(
        {"booking_id": booking_id},
        {"$set": {"status": "cancelled", "updated_at": datetime.utcnow()}}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Booking không tồn tại")
    return {"message": "Đã hủy booking thành công"}


# ==================== MEDICAL APPOINTMENT APIs ====================

@app.post("/medical/appointments/", response_model=MedicalAppointmentResponse, status_code=status.HTTP_201_CREATED)
async def create_medical_appointment(appointment_data: MedicalAppointmentCreate):
    """
    Tạo lịch khám bệnh mới
    """
    try:
        # Kiểm tra user tồn tại
        user = users_collection.find_one({"user_id": appointment_data.user_id})
        if not user:
            raise HTTPException(status_code=404, detail="User không tồn tại")
        
        # Kiểm tra user có face data không
        if not user.get("face_data", {}).get("embeddings"):
            raise HTTPException(
                status_code=400,
                detail="User chưa có dữ liệu khuôn mặt. Vui lòng upload ảnh khuôn mặt trước."
            )
        
        # Tạo appointment object
        appointment = MedicalAppointment(
            user_id=appointment_data.user_id,
            hospital_name=appointment_data.hospital_name,
            hospital_address=appointment_data.hospital_address,
            hospital_phone=appointment_data.hospital_phone,
            department=appointment_data.department,
            doctor_info=appointment_data.doctor_info,
            appointment_date=appointment_data.appointment_date,
            appointment_time=appointment_data.appointment_time,
            appointment_type=appointment_data.appointment_type,
            reason=appointment_data.reason,
            symptoms=appointment_data.symptoms,
            medical_history=appointment_data.medical_history,
            current_medications=appointment_data.current_medications,
            allergies=appointment_data.allergies,
            examination_fee=appointment_data.examination_fee,
            insurance_info=appointment_data.insurance_info,
            is_emergency=appointment_data.is_emergency,
            priority_level=3 if appointment_data.is_emergency else 0
        )
        
        # Tự động set status based on emergency
        if appointment_data.is_emergency:
            appointment.status = "confirmed"
        
        # Chuyển sang dict và lưu
        appointment_dict = appointment.model_dump(exclude_none=True)
        result = medical_appointments_collection.insert_one(appointment_dict)
        
        # Lấy appointment vừa tạo
        new_appointment = medical_appointments_collection.find_one({"_id": result.inserted_id})
        
        return MedicalAppointmentResponse(**doc_helper(new_appointment))
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi tạo lịch khám: {str(e)}")


@app.post("/medical/check-in/{appointment_id}")
async def medical_face_check_in(appointment_id: str, face_image: UploadFile = File(...)):
    """
    Check-in khám bệnh bằng khuôn mặt
    """
    try:
        # --- 1️⃣ Tìm appointment ---
        appointment = medical_appointments_collection.find_one({"appointment_id": appointment_id})
        if not appointment:
            raise HTTPException(status_code=404, detail="Lịch khám không tồn tại")
        
        if appointment["status"] not in ["scheduled", "confirmed"]:
            raise HTTPException(
                status_code=400,
                detail=f"Không thể check-in. Trạng thái hiện tại: {appointment['status']}"
            )
        
        # --- 2️⃣ Lấy thông tin user ---
        user = users_collection.find_one({"user_id": appointment["user_id"]})
        if not user:
            raise HTTPException(status_code=404, detail="User không tồn tại")
        
        stored_embeddings = user.get("face_data", {}).get("embeddings", [])
        if not stored_embeddings:
            raise HTTPException(status_code=400, detail="User chưa có dữ liệu khuôn mặt")
        
        # --- 3️⃣ Xử lý ảnh upload ---
        image_content = await face_image.read()
        temp_filename = f"temp_medical_checkin_{appointment_id}_{datetime.utcnow().timestamp()}.jpg"
        temp_path = os.path.join(FACE_IMAGE_DIR, temp_filename)
        
        with open(temp_path, "wb") as buffer:
            buffer.write(image_content)
        
        try:
            # --- 4️⃣ Extract embeddings và verify ---
            uploaded_embeddings = face_service.extract_embeddings(temp_path)
            if uploaded_embeddings is None:
                raise HTTPException(
                    status_code=400,
                    detail="Không phát hiện được khuôn mặt trong ảnh"
                )
            
            distance = face_service.calculate_distance(uploaded_embeddings, stored_embeddings)
            threshold = 0.6
            is_match = distance <= threshold
            confidence = max(0, (1 - distance) * 100)
            
            verification_log = {
                "timestamp": datetime.utcnow(),
                "action": "medical_check_in",
                "verified": is_match,
                "confidence": confidence,
                "distance": distance
            }
            
            if is_match:
                check_in_time = datetime.utcnow()

                # --- 5️⃣ Cập nhật appointment ---
                medical_appointments_collection.update_one(
                    {"appointment_id": appointment_id},
                    {
                        "$set": {
                            "status": "checked_in",
                            "actual_check_in": check_in_time,
                            "check_in_method": "face_recognition",
                            "check_in_face_verified": True,
                            "updated_at": check_in_time
                        },
                        "$push": {"face_verification_logs": verification_log}
                    }
                )

                # --- 6️⃣ Gửi thông báo FCM ---
                fcm_token = user.get("fcm_token")
                if fcm_token:
                    hospital_name = appointment.get("hospital_name", "Cơ sở y tế")
                    department = appointment.get("department", "Khoa khám bệnh")
                    doctor = appointment.get("doctor_info", {}).get("doctor_name", "Bác sĩ phụ trách")
                    patient_name = user.get("personal_info", {}).get("full_name", "Quý bệnh nhân")
                    formatted_time = check_in_time.strftime("%H:%M %d/%m/%Y")

                    # ✉️ Nội dung thông báo
                    title = f"🏥 {hospital_name}"
                    body = (
                        f"Bệnh nhân: {patient_name}\n"
                        f"Khoa: {department}\n"
                        f"Bác sĩ: {doctor}\n"
                        f"Check-in lúc: {formatted_time}\n"
                        "Cảm ơn bạn đã đến khám, chúc bạn mau khỏe!"
                    )

                    send_fcm(
                        token=fcm_token,
                        title=title,
                        body=body,
                        data={
                            "appointment_id": appointment_id,
                            "hospital_name": hospital_name,
                            "department": department,
                            "doctor": doctor,
                            "check_in_time": formatted_time,
                            "screen": "appointment_detail"
                        }
                    )

                # --- 7️⃣ Phản hồi ---
                return {
                    "success": True,
                    "message": "Check-in khám bệnh thành công",
                    "appointment_id": appointment_id,
                    "user_id": appointment["user_id"],
                    "patient_name": user["personal_info"]["full_name"],
                    "hospital_name": appointment["hospital_name"],
                    "department": appointment["department"],
                    "doctor": appointment.get("doctor_info", {}).get("doctor_name", "Chưa xác định"),
                    "check_in_time": check_in_time,
                    "appointment_time": appointment["appointment_time"],
                    "is_emergency": appointment.get("is_emergency", False),
                    "confidence": round(confidence, 2)
                }

            else:
                # --- 8️⃣ Trường hợp khuôn mặt không khớp ---
                medical_appointments_collection.update_one(
                    {"appointment_id": appointment_id},
                    {"$push": {"face_verification_logs": verification_log}}
                )
                raise HTTPException(
                    status_code=401,
                    detail=f"Xác thực khuôn mặt thất bại (confidence: {confidence:.2f}%)"
                )
        
        finally:
            if os.path.exists(temp_path):
                os.remove(temp_path)
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi check-in: {str(e)}")

@app.put("/medical/appointments/{appointment_id}/complete")
async def complete_medical_appointment(
    appointment_id: str,
    diagnosis: str = Form(...),
    treatment_plan: Optional[str] = Form(""),
    prescription: Optional[str] = Form("[]"),  # JSON string
    doctor_notes: Optional[str] = Form(""),
    next_appointment: Optional[str] = Form(None),
    additional_costs: float = Form(0.0)
):
    """
    Hoàn thành khám bệnh và cập nhật kết quả
    """
    try:
        appointment = medical_appointments_collection.find_one({"appointment_id": appointment_id})
        if not appointment:
            raise HTTPException(status_code=404, detail="Lịch khám không tồn tại")
        
        if appointment["status"] != "checked_in":
            raise HTTPException(
                status_code=400,
                detail="Chỉ có thể hoàn thành appointment đã check-in"
            )
        
        # Parse prescription JSON
        import json
        try:
            prescription_list = json.loads(prescription)
        except:
            prescription_list = []
        
        # Parse next appointment date
        next_apt_date = None
        if next_appointment:
            try:
                next_apt_date = datetime.fromisoformat(next_appointment)
            except:
                pass
        
        # Tính tổng chi phí
        total_cost = appointment.get("examination_fee", 0) + additional_costs
        
        # Cập nhật appointment
        update_data = {
            "status": "completed",
            "diagnosis": diagnosis,
            "treatment_plan": treatment_plan,
            "prescription": prescription_list,
            "doctor_notes": doctor_notes,
            "additional_costs": additional_costs,
            "total_cost": total_cost,
            "updated_at": datetime.utcnow()
        }
        
        if next_apt_date:
            update_data["next_appointment"] = next_apt_date
        
        medical_appointments_collection.update_one(
            {"appointment_id": appointment_id},
            {"$set": update_data}
        )
        
        return {
            "success": True,
            "message": "Đã hoàn thành khám bệnh",
            "appointment_id": appointment_id,
            "diagnosis": diagnosis,
            "total_cost": total_cost,
            "next_appointment": next_apt_date
        }
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi hoàn thành khám bệnh: {str(e)}")


@app.get("/medical/appointments/", response_model=List[MedicalAppointmentResponse])
async def get_all_medical_appointments(
    skip: int = 0, 
    limit: int = 100,
    status: Optional[str] = None,
    is_emergency: Optional[bool] = None
):
    """Lấy tất cả appointments với filter"""
    query = {}
    if status:
        query["status"] = status
    if is_emergency is not None:
        query["is_emergency"] = is_emergency
    
    appointments = list(medical_appointments_collection.find(query).skip(skip).limit(limit))
    return [MedicalAppointmentResponse(**doc_helper(a)) for a in appointments]


@app.get("/medical/appointments/user/{user_id}", response_model=List[MedicalAppointmentResponse])
async def get_user_medical_appointments(user_id: str):
    """Lấy lịch khám của 1 user"""
    appointments = list(medical_appointments_collection.find({"user_id": user_id}))
    return [MedicalAppointmentResponse(**doc_helper(a)) for a in appointments]


@app.get("/medical/appointments/{appointment_id}", response_model=MedicalAppointmentResponse)
async def get_medical_appointment(appointment_id: str):
    """Lấy thông tin appointment"""
    appointment = medical_appointments_collection.find_one({"appointment_id": appointment_id})
    if not appointment:
        raise HTTPException(status_code=404, detail="Lịch khám không tồn tại")
    return MedicalAppointmentResponse(**doc_helper(appointment))


@app.delete("/medical/appointments/{appointment_id}")
async def cancel_medical_appointment(appointment_id: str, reason: Optional[str] = ""):
    """Hủy lịch khám"""
    result = medical_appointments_collection.update_one(
        {"appointment_id": appointment_id},
        {
            "$set": {
                "status": "cancelled",
                "notes": f"Cancelled: {reason}",
                "updated_at": datetime.utcnow()
            }
        }
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Lịch khám không tồn tại")
    return {"message": "Đã hủy lịch khám thành công"}


@app.get("/medical/appointments/today/emergency")
async def get_today_emergency_appointments():
    """Lấy các ca cấp cứu hôm nay"""
    today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
    today_end = today_start + timedelta(days=1)
    
    appointments = list(medical_appointments_collection.find({
        "is_emergency": True,
        "appointment_date": {"$gte": today_start, "$lt": today_end},
        "status": {"$nin": ["completed", "cancelled"]}
    }).sort("priority_level", -1))
    
    return {
        "count": len(appointments),
        "appointments": [doc_helper(a) for a in appointments]
    }


# ==================== STATISTICS APIs ====================

@app.get("/stats/dashboard")
async def get_dashboard_stats():
    """Thống kê tổng quan"""
    try:
        # User stats
        total_users = users_collection.count_documents({})
        active_users = users_collection.count_documents({"system_info.status": "active"})
        
        # Hotel stats
        total_hotel_bookings = hotel_bookings_collection.count_documents({})
        active_bookings = hotel_bookings_collection.count_documents({"status": "checked_in"})
        pending_bookings = hotel_bookings_collection.count_documents({"status": {"$in": ["pending", "confirmed"]}})
        
        # Medical stats
        total_appointments = medical_appointments_collection.count_documents({})
        today_appointments = medical_appointments_collection.count_documents({
            "appointment_date": {
                "$gte": datetime.utcnow().replace(hour=0, minute=0, second=0),
                "$lt": datetime.utcnow().replace(hour=23, minute=59, second=59)
            }
        })
        emergency_cases = medical_appointments_collection.count_documents({
            "is_emergency": True,
            "status": {"$nin": ["completed", "cancelled"]}
        })
        
        return {
            "timestamp": datetime.utcnow(),
            "users": {
                "total": total_users,
                "active": active_users
            },
            "hotel": {
                "total_bookings": total_hotel_bookings,
                "active_check_ins": active_bookings,
                "pending_bookings": pending_bookings
            },
            "medical": {
                "total_appointments": total_appointments,
                "today_appointments": today_appointments,
                "emergency_cases": emergency_cases
            }
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi thống kê: {str(e)}")


# ==================== MAIN ====================

# --- Main ---
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)