from pydantic import BaseModel, Field
from typing import List, Optional, Any
from datetime import datetime
from bson import ObjectId
from pydantic.networks import EmailStr
from pydantic_core import core_schema
from pydantic import GetJsonSchemaHandler
from pydantic import BaseModel, EmailStr

# Custom ObjectId cho Pydantic v2
class PyObjectId(ObjectId):
    @classmethod
    def __get_pydantic_core_schema__(cls, _source_type: Any, _handler: Any) -> core_schema.CoreSchema:
        return core_schema.no_info_after_validator_function(
            cls.validate,
            core_schema.str_schema(),
        )

    @classmethod
    def __get_pydantic_json_schema__(
        cls, _core_schema: core_schema.CoreSchema, handler: GetJsonSchemaHandler
    ) -> dict[str, Any]:
        json_schema = handler(_core_schema)
        json_schema.update(type="string")
        return json_schema

    @classmethod
    def validate(cls, v: Any) -> ObjectId:
        if not ObjectId.is_valid(v):
            raise ValueError("Invalid ObjectId")
        return ObjectId(v)

# Sub-models
class Address(BaseModel):
    street: Optional[str] = ""
    ward: Optional[str] = ""
    district: Optional[str] = ""
    city: Optional[str] = ""

class PersonalInfo(BaseModel):
    full_name: str
    tel: str = ""
    email: str = ""
    date_of_birth: Optional[str] = ""
    gender: Optional[str] = ""
    address: Optional[Address] = Address()

class Identification(BaseModel):
    id_number: Optional[str] = ""
    issue_date: Optional[datetime] = None
    issue_place: Optional[str] = ""

class FaceData(BaseModel):
    embeddings: Optional[List[float]] = []
    face_image_url: Optional[str] = ""
    embedding_version: Optional[str] = ""
    created_at: Optional[datetime] = None

class Image(BaseModel):
    image_url: Optional[str] = ""
    image_type: Optional[str] = ""
    uploaded_at: Optional[datetime] = None
    file_size: Optional[int] = 0
    file_format: Optional[str] = ""

class SystemInfo(BaseModel):
    registration_date: Optional[datetime] = None
    last_updated: Optional[datetime] = None
    status: str = "active"
    is_verified: bool = False

class CheckinSettings(BaseModel):
    allowed_locations: Optional[List[str]] = []
    working_hours: Optional[dict] = None

# Model cho request tạo user
class UserCreate(BaseModel):
    user_id: str
    fcm_token: str
    personal_info: Optional[PersonalInfo] = PersonalInfo(full_name="")
    identification: Optional[Identification] = Identification()
    face_data: Optional[FaceData] = FaceData()
    images: Optional[List[Image]] = []
    system_info: Optional[SystemInfo] = SystemInfo()
    checkin_settings: Optional[CheckinSettings] = CheckinSettings()

# Model cho response
class UserResponse(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    user_id: str
    fcm_token: str
    personal_info: PersonalInfo
    identification: Identification
    face_data: FaceData
    images: List[Image] = []
    system_info: SystemInfo
    checkin_settings: Optional[CheckinSettings] = None

    class Config:
        populate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}



# ==================== HOTEL MODELS ====================

class RoomInfo(BaseModel):
    room_number: str = Field(..., description="Số phòng, ví dụ: 101, 202A")
    room_type: str = Field(..., description="Loại phòng: standard, deluxe, suite, presidential")
    floor: Optional[int] = Field(None, description="Tầng của phòng")
    bed_type: Optional[str] = Field(default="double", description="Loại giường: single, double, queen, king")
    max_guests: int = Field(default=2, description="Số lượng khách tối đa")
    price_per_night: float = Field(default=0.0, description="Giá mỗi đêm")
    available: bool = Field(default=True, description="Phòng còn trống hay không")


class Hotel(BaseModel):
    id: str = Field(..., description="Mã định danh khách sạn, ví dụ: APPT-2001")
    name: str = Field(..., description="Tên khách sạn")
    password: str = Field(..., description="Mật khẩu đăng nhập hệ thống")
    address: Optional[str] = Field(None, description="Địa chỉ khách sạn")
    phone: Optional[str] = Field(None, description="Số điện thoại liên hệ")
    email: Optional[str] = Field(None, description="Email liên hệ")
    star_rating: Optional[int] = Field(default=3, ge=1, le=5, description="Số sao của khách sạn (1-5)")
    rooms: List[RoomInfo] = Field(default_factory=list, description="Danh sách các phòng trong khách sạn")
    active: bool = Field(default=True, description="Trạng thái hoạt động của khách sạn")

class HotelBooking(BaseModel):
    """Model cho đăng ký khách sạn"""
    booking_id: str = Field(default_factory=lambda: f"BK{datetime.utcnow().timestamp()}")
    user_id: str  # Link với User
    
    # Thông tin khách sạn
    hotel_id: str
    hotel_name: str
    hotel_address: Optional[str] = ""
    hotel_phone: Optional[str] = ""
    
    # Thông tin đặt phòng
    room_info: RoomInfo
    check_in_date: datetime
    check_out_date: datetime
    number_of_guests: int = 1
    
    # Thông tin check-in/out thực tế
    actual_check_in: Optional[datetime] = None
    actual_check_out: Optional[datetime] = None
    check_in_method: Optional[str] = None  # "face_recognition", "manual", "qr_code"
    check_out_method: Optional[str] = None
    
    # Thông tin thanh toán
    total_amount: float = 0.0
    deposit_amount: float = 0.0
    payment_status: str = "pending"  # "pending", "partial", "paid", "refunded"
    payment_method: Optional[str] = ""
    
    # Dịch vụ bổ sung
    additional_services: Optional[List[dict]] = []  # breakfast, spa, etc.
    special_requests: Optional[str] = ""
    
    # Trạng thái
    status: str = "pending"  # "pending", "confirmed", "checked_in", "checked_out", "cancelled"
    
    # Face recognition data cho check-in/out
    check_in_face_verified: bool = False
    check_out_face_verified: bool = False
    face_verification_logs: Optional[List[dict]] = []
    
    # System info
    created_at: Optional[datetime] = Field(default_factory=datetime.utcnow)
    updated_at: Optional[datetime] = Field(default_factory=datetime.utcnow)
    created_by: Optional[str] = "system"
    notes: Optional[str] = ""

class HotelBookingCreate(BaseModel):
    """Request model để tạo booking mới"""
    user_id: str
    hotel_id: str
    hotel_name: str
    hotel_address: Optional[str] = ""
    hotel_phone: Optional[str] = ""
    room_info: RoomInfo
    check_in_date: datetime
    check_out_date: datetime
    number_of_guests: int = 1
    total_amount: float = 0.0
    deposit_amount: float = 0.0
    payment_method: Optional[str] = ""
    additional_services: Optional[List[dict]] = []
    special_requests: Optional[str] = ""

class HotelBookingResponse(BaseModel):
    """Response model cho hotel booking"""
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    booking_id: str
    user_id: str
    hotel_id: str
    hotel_name: str
    room_info: RoomInfo
    check_in_date: datetime
    check_out_date: datetime
    actual_check_in: Optional[datetime] = None
    check_in_method: Optional[str] = None
    actual_check_out: Optional[datetime] = None
    status: str
    payment_status: str
    total_amount: float
    check_in_face_verified: bool
    check_out_face_verified: bool
    created_at: datetime
    
    class Config:
        populate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}


# ==================== MEDICAL MODELS ====================

class DepartmentInfo(BaseModel):
    """Thông tin khoa / phòng ban"""
    department_id: str
    department_name: str
    description: Optional[str] = ""
    phone: Optional[str] = ""
    head_doctor: Optional[str] = ""  # ID hoặc tên bác sĩ trưởng khoa

class Hospital(BaseModel):
    """Model đại diện cho 1 bệnh viện hoặc cơ sở y tế"""
    id: str = Field(..., description="Mã bệnh viện, ví dụ: APPT-1001")
    name: str = Field(..., description="Tên bệnh viện")
    password: Optional[str] = Field(None, description="Mật khẩu đăng nhập hệ thống")
    
    # Thông tin cơ bản
    address: Optional[str] = ""
    phone: Optional[str] = ""
    email: Optional[EmailStr] = None
    website: Optional[str] = None
    established_year: Optional[int] = None
    
    # Cấu trúc tổ chức
    departments: List[DepartmentInfo] = Field(default_factory=list, description="Danh sách các khoa / phòng")
    doctors: List["DoctorInfo"] = Field(default_factory=list, description="Danh sách bác sĩ làm việc trong bệnh viện")
    
    # Cơ sở vật chất
    total_beds: Optional[int] = 0
    available_beds: Optional[int] = 0
    rating: Optional[float] = Field(default=0.0, ge=0, le=5, description="Đánh giá trung bình của bệnh viện")
    
    # Trạng thái hoạt động
    active: bool = True
    last_inspection: Optional[datetime] = None
    accreditation_status: Optional[str] = "Đạt"
    
    # Metadata
    created_at: Optional[datetime] = Field(default_factory=datetime.utcnow)
    updated_at: Optional[datetime] = Field(default_factory=datetime.utcnow)
    created_by: Optional[str] = "system"
    notes: Optional[str] = ""


class DoctorInfo(BaseModel):
    doctor_id: str
    doctor_name: str
    specialization: str  # "Nội khoa", "Ngoại khoa", "Nhi khoa", etc.
    department: Optional[str] = ""
    phone: Optional[str] = ""

class MedicalHistory(BaseModel):
    """Lịch sử bệnh của người dùng"""
    condition: str
    diagnosed_date: Optional[datetime] = None
    treatment: Optional[str] = ""
    medications: Optional[List[str]] = []

class MedicalAppointment(BaseModel):
    """Model cho đăng ký khám bệnh"""
    appointment_id: str = Field(default_factory=lambda: f"APT{datetime.utcnow().timestamp()}")
    user_id: str  # Link với User
    
    # Thông tin bệnh viện/phòng khám
    hospital_id: str
    hospital_name: str
    hospital_address: Optional[str] = ""
    hospital_phone: Optional[str] = ""
    department: str  # "Khoa Nội", "Khoa Ngoại", "Khoa Nhi", etc.
    
    # Thông tin bác sĩ
    doctor_info: Optional[DoctorInfo] = None
    
    # Thông tin đặt lịch
    appointment_date: datetime
    appointment_time: str  # "08:00", "14:30"
    appointment_type: str = "general"  # "general", "specialist", "emergency", "follow_up"
    
    # Lý do khám
    reason: str  # Lý do khám bệnh
    symptoms: Optional[List[str]] = []
    medical_history: Optional[List[MedicalHistory]] = []
    current_medications: Optional[List[str]] = []
    allergies: Optional[List[str]] = []
    
    # Check-in thực tế
    actual_check_in: Optional[datetime] = None
    check_in_method: Optional[str] = None  # "face_recognition", "manual", "qr_code"
    
    # Kết quả khám
    diagnosis: Optional[str] = ""
    prescription: Optional[List[dict]] = []  # Danh sách thuốc
    treatment_plan: Optional[str] = ""
    next_appointment: Optional[datetime] = None
    doctor_notes: Optional[str] = ""
    
    # Thanh toán
    examination_fee: float = 0.0
    additional_costs: float = 0.0
    total_cost: float = 0.0
    payment_status: str = "pending"  # "pending", "paid", "insurance_claimed"
    insurance_info: Optional[dict] = None
    
    # Trạng thái
    status: str = "scheduled"  # "scheduled", "confirmed", "checked_in", "completed", "cancelled", "no_show"
    
    # Face recognition
    check_in_face_verified: bool = False
    face_verification_logs: Optional[List[dict]] = []
    
    # Priority & Emergency
    is_emergency: bool = False
    priority_level: int = 0  # 0: normal, 1: medium, 2: high, 3: critical
    
    # System info
    created_at: Optional[datetime] = Field(default_factory=datetime.utcnow)
    updated_at: Optional[datetime] = Field(default_factory=datetime.utcnow)
    created_by: Optional[str] = "system"
    notes: Optional[str] = ""

class MedicalAppointmentCreate(BaseModel):
    """Request model để tạo appointment mới"""
    user_id: str
    hospital_id: str
    hospital_name: str
    hospital_address: Optional[str] = ""
    hospital_phone: Optional[str] = ""
    department: str
    doctor_info: Optional[DoctorInfo] = None
    appointment_date: datetime
    appointment_time: str
    appointment_type: str = "general"
    reason: str
    symptoms: Optional[List[str]] = []
    medical_history: Optional[List[MedicalHistory]] = []
    current_medications: Optional[List[str]] = []
    allergies: Optional[List[str]] = []
    examination_fee: float = 0.0
    insurance_info: Optional[dict] = None
    is_emergency: bool = False

class MedicalAppointmentResponse(BaseModel):
    """Response model cho medical appointment"""
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    appointment_id: str
    user_id: str
    hospital_name: str
    department: str
    doctor_info: Optional[DoctorInfo] = None
    appointment_date: datetime
    appointment_time: str
    appointment_type: str
    reason: str
    status: str
    actual_check_in: Optional[datetime] = None
    check_in_face_verified: bool
    payment_status: str
    total_cost: float
    is_emergency: bool
    created_at: datetime
    
    class Config:
        populate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}
        
        
        