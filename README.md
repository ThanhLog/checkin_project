<h2 align="center">
    <a href="https://dainam.edu.vn/vi/khoa-cong-nghe-thong-tin">
    🎓 Faculty of Information Technology (DaiNam University)
    </a>
</h2>
<h2 align="center">
   ỨNG DỤNG CHAT SỬ DỤNG GIAO THỨC TCP
</h2>
<div align="center">
    <p align="center">
        <img src="docs/images/aiotlab_logo.png" alt="AIoTLab Logo" width="170"/>
        <img src="docs/images/fitdnu_logo.png" alt="AIoTLab Logo" width="180"/>
        <img src="docs/images/dnu_logo.png" alt="DaiNam University Logo" width="200"/>
    </p>

[![AIoTLab](https://img.shields.io/badge/AIoTLab-green?style=for-the-badge)](https://www.facebook.com/DNUAIoTLab)
[![Faculty of Information Technology](https://img.shields.io/badge/Faculty%20of%20Information%20Technology-blue?style=for-the-badge)](https://dainam.edu.vn/vi/khoa-cong-nghe-thong-tin)
[![DaiNam University](https://img.shields.io/badge/DaiNam%20University-orange?style=for-the-badge)](https://dainam.edu.vn)

</div>


## 🧩 Tổng quan

**Checkin Project** là hệ thống nhận diện và quản lý **check-in/check-out dịch vụ** bằng AI nhận diện khuôn mặt.  
Người dùng có thể đăng ký, đăng nhập, check-in thông qua ứng dụng web hoặc mobile. Hệ thống backend dùng **FastAPI** đảm nhiệm xử lý nhận diện khuôn mặt và lưu trữ dữ liệu.

---

## 🏗 Kiến trúc hệ thống

```text
+-------------------+
|   React (FE)      |
|   Web Check-in UI |
+---------+---------+
          |
          | REST API / WebSocket
          v
+---------------------------+
|  Python FastAPI (AI/BE)   |
|  - Face Recognition       |
|  - Auth / Checkin Logic   |
|  - Database / API         |
+---------------------------+
          ^
          |
          | HTTP / JSON
+---------------------------+
|  Flutter Mobile App       |
|  - User Check-in History  |
|  - Notifications          |
+---------------------------+
```

---

## ✨ Tính năng chính

### 👨‍💼 Backend (AI/BE)
- Đăng ký & đăng nhập người dùng (face recognition hoặc email/password)
- Xử lý check-in / check-out bằng nhận diện khuôn mặt
- Lưu lịch sử dịch vụ của người dùng
- Gửi thông báo đến mobile khi có sự kiện check-in
- API REST phục vụ frontend & mobile

### 💻 Frontend (React)
- Giao diện web check-in / check-out dịch vụ
- Quản lý danh sách người dùng & lịch sử check-in
- Kết nối trực tiếp tới API backend
- Hỗ trợ responsive cho desktop & tablet

### 📱 Mobile (Flutter)
- Đăng nhập / theo dõi lịch sử check-in
- Nhận thông báo push khi người dùng check-in thành công
- Hiển thị chi tiết dịch vụ và trạng thái check-in

---

## 🧠 Công nghệ sử dụng

| Thành phần | Công nghệ |
|-------------|------------|
| **Backend (AI/BE)** | Python, FastAPI, Uvicorn, CMake, face_recognition, OpenCV |
| **Frontend (Web)** | ReactJS, Vite, TailwindCSS, Axios |
| **Mobile (App)** | Flutter, Dart |
| **Database** |MongoDB (tuỳ config) |
| **Giao tiếp** | REST API / JSON / WebSocket |

---

## 📁 Cấu trúc thư mục
``` text
checkin_project/
├── AI/ # Backend - xử lý AI & logic check-in
│ ├── main.py
│ ├── requirements.txt
│ ├── models/
│ ├── routes/
│ ├── services/
│ └── ...
│
├── FE/ # Frontend - React Web
│ ├── src/
│ ├── package.json
│ └── ...
│
├── Mobile/ # Ứng dụng Flutter
│ ├── lib/
│ ├── pubspec.yaml
│ └── ...
│
└── README.md
```

---

## ⚙️ Hướng dẫn cài đặt & chạy

### 1️⃣ Clone project
```bash
git clone https://github.com/ThanhLog/checkin_project.git
cd checkin_project
```

### 2️⃣ Cài đặt Backend (AI_BE)
``` bash
cd AI_BE
python -m venv venv
source venv/bin/activate   # hoặc .\venv\Scripts\activate trên Windows
pip install -r requirements.txt

# Chạy server FastAPI
uvicorn main:app --reload
```

### 3️⃣ Cài đặt Frontend (React)

```bash
cd FE
npm install
npm run dev
```

### 4️⃣ Cài đặt Mobile (Flutter)

```bash
cd Mobile
flutter pub get
flutter run
```

## 🔄 Luồng hoạt động

1. Người dùng đăng ký / đăng nhập (qua web hoặc app).

2. Khi check-in, camera gửi ảnh tới API FastAPI.

3. Backend dùng face_recognition nhận dạng và xác thực người dùng.

4. Nếu hợp lệ → lưu lịch sử check-in và gửi thông báo về ứng dụng Flutter.

5. Người dùng có thể xem lại lịch sử trên app mobile hoặc trang web.


## 📬 Liên hệ

Nhóm 18: Nguyễn Duy Đạt - Lê Thành Long \
Email: long66yy@gmail.com