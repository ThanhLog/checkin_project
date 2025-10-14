from bson import ObjectId
from datetime import datetime
from typing import Any, Dict

def doc_helper(doc: Dict[str, Any]) -> Dict[str, Any]:
    """
    Chuyển document MongoDB sang dict chuẩn để trả về Pydantic model
    """
    if not doc:
        return {}

    def convert_value(value):
        if isinstance(value, ObjectId):
            return str(value)
        elif isinstance(value, datetime):
            return value.isoformat()
        elif isinstance(value, dict):
            return {k: convert_value(v) for k, v in value.items()}
        elif isinstance(value, list):
            return [convert_value(v) for v in value]
        else:
            return value

    return {k: convert_value(v) for k, v in doc.items()}
