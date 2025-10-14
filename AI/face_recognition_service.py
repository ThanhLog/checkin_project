import face_recognition
import numpy as np
from typing import List, Optional
import cv2
from PIL import Image
import io

class FaceRecognitionService:
    """
    Service xử lý face recognition
    Sử dụng thư viện face_recognition (dựa trên dlib)
    """
    
    def __init__(self, model: str = "large"):
        """
        Khởi tạo service
        Args:
            model: 'small' (nhanh hơn) hoặc 'large' (chính xác hơn)
        """
        self.model = model
        print(f"✅ Face Recognition Service initialized with model: {model}")
    
    def extract_embeddings(self, image_path: str) -> Optional[List[float]]:
        """
        Extract face embeddings từ ảnh
        
        Args:
            image_path: Đường dẫn đến file ảnh
            
        Returns:
            List embeddings (128 dimensions) hoặc None nếu không tìm thấy khuôn mặt
        """
        try:
            # Load ảnh
            image = face_recognition.load_image_file(image_path)
            
            # Tìm vị trí khuôn mặt trong ảnh
            face_locations = face_recognition.face_locations(image, model="hog")
            
            if len(face_locations) == 0:
                print(f"⚠️ Không tìm thấy khuôn mặt trong ảnh: {image_path}")
                return None
            
            if len(face_locations) > 1:
                print(f"⚠️ Tìm thấy {len(face_locations)} khuôn mặt, chỉ sử dụng khuôn mặt đầu tiên")
            
            # Extract embeddings (chỉ lấy khuôn mặt đầu tiên)
            face_encodings = face_recognition.face_encodings(
                image, 
                known_face_locations=face_locations,
                model=self.model
            )
            
            if len(face_encodings) == 0:
                print(f"⚠️ Không thể extract embeddings từ: {image_path}")
                return None
            
            # Chuyển numpy array sang list
            embeddings = face_encodings[0].tolist()
            
            print(f"✅ Extracted embeddings successfully: {len(embeddings)} dimensions")
            return embeddings
            
        except Exception as e:
            print(f"❌ Lỗi khi extract embeddings: {str(e)}")
            return None
    
    def extract_embeddings_from_bytes(self, image_bytes: bytes) -> Optional[List[float]]:
        """
        Extract face embeddings từ bytes data
        
        Args:
            image_bytes: Bytes data của ảnh
            
        Returns:
            List embeddings hoặc None
        """
        try:
            # Convert bytes to numpy array
            nparr = np.frombuffer(image_bytes, np.uint8)
            image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
            
            # Convert BGR to RGB (face_recognition sử dụng RGB)
            image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
            
            # Tìm vị trí khuôn mặt
            face_locations = face_recognition.face_locations(image_rgb, model="hog")
            
            if len(face_locations) == 0:
                return None
            
            # Extract embeddings
            face_encodings = face_recognition.face_encodings(
                image_rgb,
                known_face_locations=face_locations,
                model=self.model
            )
            
            if len(face_encodings) == 0:
                return None
            
            return face_encodings[0].tolist()
            
        except Exception as e:
            print(f"❌ Lỗi khi extract embeddings từ bytes: {str(e)}")
            return None
    
    def calculate_distance(self, embedding1: List[float], embedding2: List[float]) -> float:
        """
        Tính khoảng cách Euclidean giữa 2 embeddings
        
        Args:
            embedding1: Embeddings thứ nhất
            embedding2: Embeddings thứ hai
            
        Returns:
            Khoảng cách (0 = giống nhau hoàn toàn, càng lớn càng khác biệt)
        """
        try:
            # Chuyển sang numpy array
            emb1 = np.array(embedding1)
            emb2 = np.array(embedding2)
            
            # Tính khoảng cách Euclidean
            distance = np.linalg.norm(emb1 - emb2)
            
            return float(distance)
            
        except Exception as e:
            print(f"❌ Lỗi khi tính khoảng cách: {str(e)}")
            return float('inf')
    
    def compare_faces(
        self, 
        known_embeddings: List[float], 
        face_to_check: List[float],
        tolerance: float = 0.6
    ) -> bool:
        """
        So sánh 2 khuôn mặt
        
        Args:
            known_embeddings: Embeddings đã biết
            face_to_check: Embeddings cần kiểm tra
            tolerance: Ngưỡng chấp nhận (mặc định 0.6)
            
        Returns:
            True nếu khớp, False nếu không khớp
        """
        distance = self.calculate_distance(known_embeddings, face_to_check)
        return distance <= tolerance
    
    def find_best_match(
        self,
        face_to_check: List[float],
        known_faces: List[dict],
        tolerance: float = 0.6
    ) -> Optional[dict]:
        """
        Tìm khuôn mặt khớp nhất trong danh sách
        
        Args:
            face_to_check: Embeddings cần kiểm tra
            known_faces: List các dict chứa embeddings và metadata
                        [{"embeddings": [...], "user_id": "...", ...}, ...]
            tolerance: Ngưỡng chấp nhận
            
        Returns:
            Dict của khuôn mặt khớp nhất hoặc None
        """
        if not known_faces:
            return None
        
        best_match = None
        best_distance = float('inf')
        
        for face_data in known_faces:
            embeddings = face_data.get("embeddings", [])
            if not embeddings:
                continue
            
            distance = self.calculate_distance(face_to_check, embeddings)
            
            if distance < best_distance:
                best_distance = distance
                best_match = face_data
        
        # Kiểm tra ngưỡng
        if best_match and best_distance <= tolerance:
            best_match["distance"] = best_distance
            best_match["confidence"] = max(0, (1 - best_distance) * 100)
            return best_match
        
        return None
    
    def detect_faces_count(self, image_path: str) -> int:
        """
        Đếm số khuôn mặt trong ảnh
        
        Args:
            image_path: Đường dẫn đến file ảnh
            
        Returns:
            Số lượng khuôn mặt phát hiện được
        """
        try:
            image = face_recognition.load_image_file(image_path)
            face_locations = face_recognition.face_locations(image, model="hog")
            return len(face_locations)
        except Exception as e:
            print(f"❌ Lỗi khi đếm khuôn mặt: {str(e)}")
            return 0
    
    def get_face_landmarks(self, image_path: str) -> Optional[List[dict]]:
        """
        Lấy các điểm đặc trưng trên khuôn mặt (eyes, nose, mouth, etc.)
        
        Args:
            image_path: Đường dẫn đến file ảnh
            
        Returns:
            List các landmarks hoặc None
        """
        try:
            image = face_recognition.load_image_file(image_path)
            face_landmarks_list = face_recognition.face_landmarks(image)
            return face_landmarks_list
        except Exception as e:
            print(f"❌ Lỗi khi lấy face landmarks: {str(e)}")
            return None
    
    def validate_image_quality(self, image_path: str) -> dict:
        """
        Kiểm tra chất lượng ảnh cho face recognition
        
        Args:
            image_path: Đường dẫn đến file ảnh
            
        Returns:
            Dict chứa thông tin về chất lượng ảnh
        """
        result = {
            "is_valid": False,
            "face_detected": False,
            "face_count": 0,
            "issues": []
        }
        
        try:
            # Load ảnh
            image = face_recognition.load_image_file(image_path)
            
            # Kiểm tra kích thước
            height, width = image.shape[:2]
            if width < 100 or height < 100:
                result["issues"].append("Ảnh quá nhỏ (tối thiểu 100x100px)")
            
            # Phát hiện khuôn mặt
            face_locations = face_recognition.face_locations(image, model="hog")
            result["face_count"] = len(face_locations)
            
            if len(face_locations) == 0:
                result["issues"].append("Không phát hiện được khuôn mặt")
                return result
            
            result["face_detected"] = True
            
            if len(face_locations) > 1:
                result["issues"].append(f"Phát hiện {len(face_locations)} khuôn mặt (nên chỉ có 1)")
            
            # Kiểm tra kích thước khuôn mặt
            top, right, bottom, left = face_locations[0]
            face_width = right - left
            face_height = bottom - top
            
            if face_width < 50 or face_height < 50:
                result["issues"].append("Khuôn mặt quá nhỏ trong ảnh")
            
            # Kiểm tra tỉ lệ khuôn mặt so với ảnh
            face_ratio = (face_width * face_height) / (width * height)
            if face_ratio < 0.05:
                result["issues"].append("Khuôn mặt chiếm tỷ lệ quá nhỏ trong ảnh")
            
            # Nếu không có vấn đề nghiêm trọng
            if not result["issues"] or (len(result["issues"]) == 1 and "nhiều khuôn mặt" in result["issues"][0]):
                result["is_valid"] = True
            
            return result
            
        except Exception as e:
            result["issues"].append(f"Lỗi xử lý ảnh: {str(e)}")
            return result
    
    def crop_face(self, image_path: str, output_path: str, padding: int = 50) -> bool:
        """
        Cắt và lưu khuôn mặt từ ảnh
        
        Args:
            image_path: Đường dẫn ảnh gốc
            output_path: Đường dẫn lưu ảnh đã cắt
            padding: Khoảng padding xung quanh khuôn mặt (px)
            
        Returns:
            True nếu thành công, False nếu thất bại
        """
        try:
            # Load ảnh
            image = face_recognition.load_image_file(image_path)
            face_locations = face_recognition.face_locations(image)
            
            if len(face_locations) == 0:
                return False
            
            # Lấy khuôn mặt đầu tiên
            top, right, bottom, left = face_locations[0]
            
            # Thêm padding
            top = max(0, top - padding)
            right = min(image.shape[1], right + padding)
            bottom = min(image.shape[0], bottom + padding)
            left = max(0, left - padding)
            
            # Cắt ảnh
            face_image = image[top:bottom, left:right]
            
            # Lưu ảnh
            pil_image = Image.fromarray(face_image)
            pil_image.save(output_path)
            
            return True
            
        except Exception as e:
            print(f"❌ Lỗi khi crop face: {str(e)}")
            return False


# ============================================
# ALTERNATIVE: Sử dụng DeepFace (nếu muốn)
# ============================================

class DeepFaceService:
    """
    Alternative service sử dụng DeepFace
    Hỗ trợ nhiều models: VGG-Face, Facenet, OpenFace, DeepFace, DeepID, ArcFace, Dlib
    """
    
    def __init__(self, model_name: str = "Facenet"):
        """
        Args:
            model_name: Tên model ('VGG-Face', 'Facenet', 'ArcFace', 'Dlib', etc.)
        """
        try:
            from deepface import DeepFace
            self.DeepFace = DeepFace
            self.model_name = model_name
            print(f"✅ DeepFace Service initialized with model: {model_name}")
        except ImportError:
            raise ImportError("DeepFace chưa được cài đặt. Chạy: pip install deepface")
    
    def extract_embeddings(self, image_path: str) -> Optional[List[float]]:
        """
        Extract embeddings sử dụng DeepFace
        """
        try:
            embedding_objs = self.DeepFace.represent(
                img_path=image_path,
                model_name=self.model_name,
                enforce_detection=True,
                detector_backend="opencv"
            )
            
            if not embedding_objs:
                return None
            
            # Lấy embedding đầu tiên
            embeddings = embedding_objs[0]["embedding"]
            return embeddings
            
        except Exception as e:
            print(f"❌ Lỗi DeepFace: {str(e)}")
            return None
    
    def verify_faces(self, img1_path: str, img2_path: str) -> dict:
        """
        Verify 2 khuôn mặt có phải cùng 1 người không
        """
        try:
            result = self.DeepFace.verify(
                img1_path=img1_path,
                img2_path=img2_path,
                model_name=self.model_name,
                enforce_detection=True
            )
            return result
        except Exception as e:
            print(f"❌ Lỗi verify: {str(e)}")
            return {"verified": False, "error": str(e)}


# ============================================
# Test functions
# ============================================

def test_face_recognition_service():
    """Test face recognition service"""
    service = FaceRecognitionService()
    
    # Test với ảnh mẫu
    test_image = "test_face.jpg"
    
    print("\n--- Testing Face Recognition Service ---")
    
    # 1. Validate image quality
    print("\n1. Validating image quality...")
    quality = service.validate_image_quality(test_image)
    print(f"Quality check: {quality}")
    
    # 2. Detect faces count
    print("\n2. Detecting faces...")
    face_count = service.detect_faces_count(test_image)
    print(f"Faces detected: {face_count}")
    
    # 3. Extract embeddings
    print("\n3. Extracting embeddings...")
    embeddings = service.extract_embeddings(test_image)
    if embeddings:
        print(f"Embeddings extracted: {len(embeddings)} dimensions")
        print(f"First 5 values: {embeddings[:5]}")
    else:
        print("Failed to extract embeddings")


if __name__ == "__main__":
    # Uncomment để test
    # test_face_recognition_service()
    pass