import os
from dotenv import load_dotenv

load_dotenv()  # Load .env file

class Config:
    # Telegram Credentials
    API_ID = int(os.environ.get("API_ID"))
    API_HASH = os.environ.get("API_HASH")
    BOT_TOKEN = os.environ.get("BOT_TOKEN")
    
    # Optional Settings
    MAX_FILE_SIZE = 50 * 1024 * 1024  # 50MB
    ALLOWED_DOMAINS = ["utkarshapp.com", "classplusapp.com"]
