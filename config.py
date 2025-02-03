import os
from dotenv import load_dotenv

load_dotenv()  # Load .env file

class Config:
    # Telegram Credentials
    API_ID = int(os.environ.get("25645046"))
    API_HASH = os.environ.get("568c366b5573c5c349f0f0f25c3a4ccd")
    BOT_TOKEN = os.environ.get("8177990799:AAGFyMi4DQ3Sc41GVqKt8-3XY-E2iinWuH8")
    
    # Optional Settings
    MAX_FILE_SIZE = 50 * 1024 * 1024  # 50MB
    ALLOWED_DOMAINS = ["utkarshapp.com", "classplusapp.com"]
