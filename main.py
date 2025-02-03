import logging
from telegram import Update
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters
from config import Config

# Logging Setup
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# Load Credentials from Config
TOKEN = Config.BOT_TOKEN

def start(update: Update, context):
    update.message.reply_text('🌟 नमस्ते! मुझे एक .txt फ़ाइल भेजें जिसमें PDF/Video लिंक हों।')

def handle_document(update: Update, context):
    try:
        # Download the .txt file
        file = update.message.document.get_file()
        file.download('user_file.txt')
        
        # Extract Links
        with open('user_file.txt', 'r') as f:
            links = [line.strip() for line in f if 'http' in line]
        
        # Process Each Link
        for link in links:
            if '.pdf' in link:
                update.message.reply_document(document=link)
            elif '.mp4' in link or '.m3u8' in link:
                update.message.reply_video(video=link)
                
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        update.message.reply_text('❌ कुछ गलत हुआ! कृपया डेवलपर को सूचित करें।')

def main():
    updater = Updater(TOKEN)
    dp = updater.dispatcher
    dp.add_handler(CommandHandler('start', start))
    dp.add_handler(MessageHandler(Filters.document, handle_document))
    updater.start_polling()
    updater.idle()

if __name__ == '__main__':
    main()
