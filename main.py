import os
import logging
from telegram import Update
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters

# Logging Setup (Errors Track करने के लिए)
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# Environment Variables से Token लें
TOKEN = os.environ.get("BOT_TOKEN")

def start(update: Update, context):
    update.message.reply_text('नमस्ते! मुझे एक .txt फ़ाइल भेजें 📁')

def handle_document(update: Update, context):
    try:
        file = update.message.document.get_file()
        file.download('user_file.txt')
        
        # .txt फ़ाइल से लिंक्स निकालें
        with open('user_file.txt', 'r') as f:
            links = [line.strip() for line in f if 'http' in line]
        
        # प्रत्येक लिंक को प्रोसेस करें
        for link in links:
            if '.pdf' in link:
                # PDF डाउनलोड करें और भेजें
                update.message.reply_document(document=link)
            elif '.mp4' in link or '.m3u8' in link:
                # Video डाउनलोड करें और भेजें (DRM-free होना चाहिए)
                update.message.reply_video(video=link)
                
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        update.message.reply_text('⚠️ कुछ गलत हुआ! डेवलपर को बताएं।')

def main():
    updater = Updater(TOKEN)
    dp = updater.dispatcher
    dp.add_handler(CommandHandler('start', start))
    dp.add_handler(MessageHandler(Filters.document, handle_document))
    updater.start_polling()
    updater.idle()

if __name__ == '__main__':
    main()
