import json
import time
import requests
from google.oauth2 import service_account
import google.auth.transport.requests

# === Cấu hình Firebase ===
SERVICE_ACCOUNT_FILE = "./checkin-a507c-firebase-adminsdk-fbsvc-85f5c57705.json"
SCOPES = ["https://www.googleapis.com/auth/firebase.messaging"]

# === Bộ nhớ cache access token để không phải refresh liên tục ===
_cached_token = None
_cached_token_expiry = 0


def get_access_token():
    """Lấy access token từ service account, có cache."""
    global _cached_token, _cached_token_expiry

    # Nếu token vẫn còn hạn thì dùng lại
    if _cached_token and time.time() < _cached_token_expiry:
        return _cached_token

    credentials = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES
    )
    request = google.auth.transport.requests.Request()
    credentials.refresh(request)

    _cached_token = credentials.token
    # Token thường có hạn 1 giờ => cache 55 phút
    _cached_token_expiry = time.time() + 55 * 60
    return _cached_token


def send_fcm(token: str, title: str, body: str, data: dict = None):
    """
    Gửi thông báo FCM đến thiết bị cụ thể.
    Args:
        token (str): FCM token của client
        title (str): Tiêu đề thông báo
        body (str): Nội dung thông báo
        data (dict): Dữ liệu bổ sung (tùy chọn)
    Returns:
        dict: Phản hồi từ FCM
    """
    try:
        access_token = get_access_token()

        credentials = service_account.Credentials.from_service_account_file(
            SERVICE_ACCOUNT_FILE, scopes=SCOPES
        )
        project_id = credentials.project_id

        url = f"https://fcm.googleapis.com/v1/projects/{project_id}/messages:send"

        message = {
            "message": {
                "token": token,
                "notification": {
                    "title": title,
                    "body": body,
                },
            }
        }

        # Nếu có data kèm theo thì thêm vào message
        if data:
            message["message"]["data"] = data

        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json; UTF-8",
        }

        response = requests.post(url, headers=headers, data=json.dumps(message))

        if response.status_code != 200:
            print(f"❌ FCM error: {response.text}")
        else:
            print(f"✅ FCM sent to {token[:15]}...")

        return {
            "status_code": response.status_code,
            "response": response.text
        }

    except Exception as e:
        print(f"🔥 Lỗi gửi FCM: {e}")
        return {"error": str(e)}
