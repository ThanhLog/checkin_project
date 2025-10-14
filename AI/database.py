from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()

class MongoDB:
    def __init__(self):
        self.client = None
        self.db = None
        
    def connect(self):
        try:
            # Kết nối MongoDB - có thể thay đổi connection string
            mongo_uri = os.getenv("MONGO_URI", "mongodb://localhost:27017/")
            self.client = MongoClient(mongo_uri)
            self.db = self.client["CheckIn_App"]
            print("✅ Kết nối MongoDB thành công!")
            return self.db
        except Exception as e:
            print(f"❌ Lỗi kết nối MongoDB: {e}")
            return None
    
    def close(self):
        if self.client:
            self.client.close()

# Khởi tạo kết nối
mongodb = MongoDB()
db = mongodb.connect()
users_collection = db["User"]
hotel_bookings_collection = db["HotelBooking"]
medical_appointments_collection = db["MedicalAppointment"]

# Tạo indexes để tối ưu hóa
def create_indexes():
    """Tạo các indexes cho collections"""
    try:
        # User indexes
        users_collection.create_index("user_id", unique=True)
        users_collection.create_index("personal_info.full_name")
        
        # Hotel Booking indexes
        hotel_bookings_collection.create_index("booking_id", unique=True)
        hotel_bookings_collection.create_index("user_id")
        hotel_bookings_collection.create_index("status")
        hotel_bookings_collection.create_index("check_in_date")
        hotel_bookings_collection.create_index([("hotel_name", 1), ("check_in_date", 1)])
        
        # Medical Appointment indexes
        medical_appointments_collection.create_index("appointment_id", unique=True)
        medical_appointments_collection.create_index("user_id")
        medical_appointments_collection.create_index("status")
        medical_appointments_collection.create_index("appointment_date")
        medical_appointments_collection.create_index([("hospital_name", 1), ("appointment_date", 1)])
        medical_appointments_collection.create_index("is_emergency")
        
        print("✅ Đã tạo indexes thành công!")
    except Exception as e:
        print(f"⚠️ Lỗi khi tạo indexes: {e}")

# Tự động tạo indexes khi import
create_indexes()