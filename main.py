import logging
import os
from telegram import Update
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters
from config import Config

logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

TOKEN = Config.BOT_TOKEN

def start(update: Update, context):
    update.message.reply_text('✅ बॉट सक्रिय! .txt फ़ाइल भेजें')

def handle_document(update: Update, context):
    try:
        file = update.message.document.get_file()
        file.download('user_file.txt')
        
        with open('user_file.txt', 'r') as f:
            links = [line.strip() for line in f if 'http' in line]
        
        for link in links:
            if link:
                if '.pdf' in link:
                    update.message.reply_document(document=link)
                elif '.mp4' in link:
                    update.message.reply_video(video=link)
                
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        update.message.reply_text('❌ त्रुटि! लिंक अमान्य या सर्वर समस्या')

def main():
    updater = Updater(TOKEN)
    dp = updater.dispatcher
    dp.add_handler(CommandHandler('start', start))
    dp.add_handler(MessageHandler(Filters.document, handle_document))
    updater.start_polling()
    updater.idle()

if __name__ == '__main__':
    main()
