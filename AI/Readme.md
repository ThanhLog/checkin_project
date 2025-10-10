# Face Checkin API - Hệ thống Checkin bằng Khuôn mặt

API RESTful cho hệ thống checkin sử dụng công nghệ nhận diện khuôn mặt (Face Recognition).

## 🚀 Tính năng chính

- ✅ **Tạo tài khoản tự động tính embeddings**: Upload ảnh → Tự động extract face embeddings
- ✅ **Đăng nhập bằng khuôn mặt**: Upload ảnh → Tìm user khớp nhất trong database
- ✅ **Xác thực khuôn mặt**: Verify khuôn mặt với user_id cụ thể
- ✅ **Cập nhật embeddings**: Thay đổi ảnh khuôn mặt và embeddings mới
- ✅ **CRUD đầy đủ**: Create, Read, Update, Delete users
- ✅ **Search & Filter**: Tìm kiếm theo tên, ID number
- ✅ **Statistics**: Thống kê tổng quan hệ thống

## 📋 Yêu cầu hệ thống

- Python 3.8+
- MongoDB
- CMake (cho dlib)
- Visual Studio Build Tools (Windows) hoặc gcc (Linux/Mac)

## 🔧 Cài đặt

### 1. Clone hoặc