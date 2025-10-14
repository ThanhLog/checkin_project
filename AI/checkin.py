
import cv2
import face_recognition
import numpy as np

# Load known image và encode
known_image = face_recognition.load_image_file("1.jpg")
known_encoding = face_recognition.face_encodings(known_image)[0]
known_names = ["Toi ten dat"]

# Danh sách đã biết
known_face_encodings = [known_encoding]

# Webcam
video_capture = cv2.VideoCapture(0)

while True:
    ret, frame = video_capture.read()
    if not ret:
        break

    # Resize nhỏ để tăng tốc
    small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)
    rgb_small_frame = cv2.cvtColor(small_frame, cv2.COLOR_BGR2RGB)

    # Detect khuôn mặt + encode
    face_locations = face_recognition.face_locations(rgb_small_frame)
    face_encodings = face_recognition.face_encodings(rgb_small_frame, face_locations)

    face_names = []
    for (top, right, bottom, left), face_encoding in zip(face_locations, face_encodings):
        # So sánh với known
        matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
        name = "Unknown"

        face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
        if len(face_distances) > 0:
            best_match_index = np.argmin(face_distances)
            if matches[best_match_index]:
                name = known_names[best_match_index]

        face_names.append(name)

        # Scale tọa độ lại (vì resize 1/4)
        top *= 4
        right *= 4
        bottom *= 4
        left *= 4

        # Vẽ khung
        cv2.rectangle(frame, (left, top), (right, bottom), (0, 255, 0), 2)
        cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 255, 0), cv2.FILLED)
        cv2.putText(frame, name, (left + 6, bottom - 6),
                    cv2.FONT_HERSHEY_DUPLEX, 1.0, (255, 255, 255), 1)

        # Crop khuôn mặt & mở tab riêng
        face_crop = frame[top:bottom, left:right]
        if face_crop.size > 0:
            cv2.imshow(f"Face: {name}", face_crop)

    # Hiển thị frame chính
    cv2.imshow('Video', frame)

    # Nhấn Q để thoát
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

video_capture.release()
cv2.destroyAllWindows()
