#!/bin/bash
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
ORANGE='\033[38;5;214m'
NC='\033[0m' # No Color

echo -e "${GREEN}Join our Telegram channel: https://t.me/+8UQlD7MGlWc2YTNl${NC}"
echo -e "${ORANGE}-----------------------------------------------------${NC}"
sleep 3

# Log file for debugging
LOG_FILE="setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to display usage instructions
usage() {
    echo -e "${GREEN}Usage: $0 [--verbose] [--dry-run]${NC}"
    echo -e "${GREEN}  --verbose: Enable verbose logging for debugging.${NC}"
    echo -e "${GREEN}  --dry-run: Simulate script execution without making changes.${NC}"
    exit 0
}

# Parse command-line arguments
VERBOSE=false
DRY_RUN=false
for arg in "$@"; do
    case "$arg" in
        --verbose)
            VERBOSE=true
            ;;
        --dry-run)
            DRY_RUN=true
            ;;
        --help)
            usage
            ;;
        *)
            echo -e "${RED}Unknown argument: $arg${NC}"
            usage
            ;;
    esac
done

# Enable verbose mode if requested
if $VERBOSE; then
    set -x
fi

# Dry-run mode message
if $DRY_RUN; then
    echo -e "${BLUE}Dry-run mode enabled. No changes will be made.${NC}"
	sleep 1
fi

# Function to ask for user input
ask_for_input() {
    local prompt="$1"
    local input

    read -p "$prompt: " input
    echo "$input"
}

# Function to validate gas value
validate_gas_value() {
    local gas_value="$1"
    
    # Check if the input is an integer
    if [[ ! "$gas_value" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}$MSG_GAS_VALUE${NC}"
        return 1
    fi

    # Check if the gas value is within the allowed range
    if (( gas_value < 100 || gas_value > 20000 )); then
        echo -e "${RED}$MSG_INVALID_GAS${NC}"
        return 1
    fi

    return 0
}

# Language selection
while true; do
    # Define MSG_INVALID_LANG for all cases
    MSG_INVALID_LANG="Invalid language code. Please try again."

    echo -e "${GREEN}Select your language / Dil seçin / Выберите язык / Wählen Sie Ihre Sprache / Pilih bahasa Anda / Choisissez votre langue:${NC}"
    echo -e "${ORANGE}English (en)${NC}"
    echo -e "${ORANGE}Azerbaijani (az)${NC}"
    echo -e "${ORANGE}Russian (ru)${NC}"
    echo -e "${ORANGE}German (de)${NC}"
    echo -e "${ORANGE}Indonesian (id)${NC}"
    echo -e "${ORANGE}French (fr)${NC}"
    read -p "Enter language code (e.g., en, az, ru, de, id, fr): " LANG_CODE

    # Language-specific strings
    case "$LANG_CODE" in
        en)
            MSG_INVALID_LANG="Invalid language code. Please try again."
            MSG_CLEANUP="Cleaning up previous installations..."
            MSG_DOWNLOAD="Downloading the latest release..."
            MSG_EXTRACT="Extracting the archive..."
            MSG_INVALID_INPUT="Invalid input. Please enter 'api' or 'rpc'."
            MSG_PRIVATE_KEY="Enter your wallet private key"
            MSG_GAS_VALUE="Enter the gas value (must be an integer between 100 and 20000)"
            MSG_INVALID_GAS="Error: Gas value must be between 100 and 20000."
            MSG_NODE_TYPE="Do you want to run an API node or RPC node? (api/rpc)"
            MSG_RPC_ENDPOINTS="Do you want to add custom public RPC endpoints? (y/n)"
            MSG_THANKS="If this script helped you, don't forget to give a ⭐ on GitHub 😉..."
            MSG_L1RN_RPC="Available L1RN RPC endpoints:"
            MSG_SELECT_L1RN="Enter the numbers of the L1RN RPC endpoints to enable (comma-separated, e.g., 1,2):"
            MSG_INVALID_SELECTION="Invalid selection: %s. Skipping."
            MSG_OUT_OF_RANGE="Index %s is out of range. Skipping."
            MSG_NO_SELECTION="No valid selections. Please select at least one endpoint."
            MSG_ALCHEMY_API_KEY="Enter your Alchemy API key:"
            MSG_CREATE_DIR="Creating and navigating to t3rn directory..."
            MSG_DOWNLOAD_COMPLETE="Download complete."
            MSG_NAVIGATE_BINARY="Navigating to the executor binary location..."
            MSG_COLLECTED_INPUTS="Collected inputs and settings:"
            MSG_NODE_TYPE_LABEL="Node Type:"
            MSG_ALCHEMY_API_KEY_LABEL="Alchemy API Key:"
            MSG_GAS_VALUE_LABEL="Gas Value:"
            MSG_RPC_ENDPOINTS_LABEL="RPC Endpoints:"
            MSG_WALLET_PRIVATE_KEY_LABEL="Wallet Private Key:"
            MSG_FAILED_CREATE_DIR="Failed to create or navigate to t3rn directory. Exiting."
            MSG_FAILED_FETCH_TAG="Failed to fetch the latest release tag. Please check your internet connection and try again."
            MSG_FAILED_DOWNLOAD="Failed to download the latest release. Please check the URL and try again."
            MSG_FAILED_EXTRACT="Failed to extract the archive. Please check the file and try again."
            MSG_FAILED_NAVIGATE="Failed to navigate to executor binary location. Exiting."
            MSG_DELETE_T3RN_DIR="Deleting existing t3rn directory..."
            MSG_DELETE_EXECUTOR_DIR="Deleting existing executor directory..."
            MSG_DELETE_TAR_GZ="Deleting previously downloaded tar.gz files..."
            MSG_EXTRACTION_COMPLETE="Extraction complete."
            MSG_RUNNING_NODE="Running the node..."
            MSG_DRY_RUN_DELETE="[Dry-run] Would delete existing t3rn and executor directories."
            MSG_DRY_RUN_CREATE_DIR="[Dry-run] Would create and navigate to t3rn directory."
            MSG_DRY_RUN_NAVIGATE="[Dry-run] Would navigate to executor binary location."
            MSG_DRY_RUN_RUN_NODE="[Dry-run] Would run the node."
            MSG_ENTER_CUSTOM_RPC="Enter custom RPC endpoints:"
            MSG_ARBT_RPC="Arbitrum Sepolia RPC endpoints (default: $DEFAULT_RPC_ENDPOINTS_ARBT)"
            MSG_BSSP_RPC="Base Sepolia RPC endpoints (default: $DEFAULT_RPC_ENDPOINTS_BSSP)"
            MSG_BLSS_RPC="Blast Sepolia RPC endpoints (default: $DEFAULT_RPC_ENDPOINTS_BLSS)"
            MSG_OPSP_RPC="Optimism Sepolia RPC endpoints (default: $DEFAULT_RPC_ENDPOINTS_OPSP)"
            break
            ;;
        az)
            MSG_INVALID_LANG="Yanlış dil kodu. Yenidən cəhd edin."
            MSG_CLEANUP="Əvvəlki quraşdırmaları təmizləyirəm..."
            MSG_DOWNLOAD="Son buraxılışı yükləyirəm..."
            MSG_EXTRACT="Arxiv açılır..."
            MSG_INVALID_INPUT="Yanlış giriş. 'api' və ya 'rpc' daxil edin."
            MSG_PRIVATE_KEY="Cüzdanınızın gizli açarını daxil edin"
            MSG_GAS_VALUE="Qaz dəyərini daxil edin (100 ilə 20000 arasında tam ədəd olmalıdır)"
            MSG_INVALID_GAS="Xəta: Qaz dəyəri 100 ilə 20000 arasında olmalıdır."
            MSG_NODE_TYPE="API node və ya RPC node işlətmək istəyirsiniz? (api/rpc)"
            MSG_RPC_ENDPOINTS="Xüsusi RPC endpointləri əlavə etmək istəyirsiniz? (y/n)"
            MSG_THANKS="Bu skript sizə kömək etdisə, GitHub-da ⭐ verməyi unutmayın 😉..."
            MSG_L1RN_RPC="Mövcud L1RN RPC endpointləri:"
            MSG_SELECT_L1RN="Aktivləşdirmək istədiyiniz L1RN RPC endpointlərinin nömrələrini daxil edin (vergüllə ayrılmış, məsələn, 1,2):"
            MSG_INVALID_SELECTION="Yanlış seçim: %s. Keçilir."
            MSG_OUT_OF_RANGE="İndeks %s aralıqdan kənardır. Keçilir."
            MSG_NO_SELECTION="Heç bir etibarlı seçim yoxdur. Ən azı bir endpoint seçin."
            MSG_ALCHEMY_API_KEY="Alchemy API açarınızı daxil edin:"
            MSG_CREATE_DIR="t3rn qovluğu yaradılır və ora keçid edilir..."
            MSG_DOWNLOAD_COMPLETE="Yükləmə tamamlandı."
            MSG_NAVIGATE_BINARY="Executor binar faylı yerləşən qovluğa keçid edilir..."
            MSG_COLLECTED_INPUTS="Toplanmış məlumatlar və parametrlər:"
            MSG_NODE_TYPE_LABEL="Node Növü:"
            MSG_ALCHEMY_API_KEY_LABEL="Alchemy API Açarı:"
            MSG_GAS_VALUE_LABEL="Qaz Dəyəri:"
            MSG_RPC_ENDPOINTS_LABEL="RPC Endpointləri:"
            MSG_WALLET_PRIVATE_KEY_LABEL="Cüzdanın Gizli Açarı:"
            MSG_FAILED_CREATE_DIR="t3rn qovluğu yaradıla bilmədi və ya ora keçid edilə bilmədi. Çıxılır."
            MSG_FAILED_FETCH_TAG="Son buraxılış etiketi alına bilmədi. İnternet bağlantınızı yoxlayın və yenidən cəhd edin."
            MSG_FAILED_DOWNLOAD="Son buraxılış yüklənə bilmədi. URL-i yoxlayın və yenidən cəhd edin."
            MSG_FAILED_EXTRACT="Arxiv açıla bilmədi. Faylı yoxlayın və yenidən cəhd edin."
            MSG_FAILED_NAVIGATE="Executor binar faylı yerləşən qovluğa keçid edilə bilmədi. Çıxılır."
            MSG_DELETE_T3RN_DIR="Mövcud t3rn qovluğu silinir..."
            MSG_DELETE_EXECUTOR_DIR="Mövcud executor qovluğu silinir..."
            MSG_DELETE_TAR_GZ="Əvvəlcədən yüklənmiş tar.gz faylları silinir..."
            MSG_EXTRACTION_COMPLETE="Arxiv açıldı."
            MSG_RUNNING_NODE="Node işə salınır..."
            MSG_DRY_RUN_DELETE="[Dry-run] Mövcud t3rn və executor qovluqları silinəcək."
            MSG_DRY_RUN_CREATE_DIR="[Dry-run] t3rn qovluğu yaradılacaq və ora keçid ediləcək."
            MSG_DRY_RUN_NAVIGATE="[Dry-run] Executor binar faylı yerləşən qovluğa keçid ediləcək."
            MSG_DRY_RUN_RUN_NODE="[Dry-run] Node işə salınacaq."
            MSG_ENTER_CUSTOM_RPC="Xüsusi RPC endpointlərini daxil edin:"
            MSG_ARBT_RPC="Arbitrum Sepolia RPC endpointləri (default: $DEFAULT_RPC_ENDPOINTS_ARBT)"
            MSG_BSSP_RPC="Base Sepolia RPC endpointləri (default: $DEFAULT_RPC_ENDPOINTS_BSSP)"
            MSG_BLSS_RPC="Blast Sepolia RPC endpointləri (default: $DEFAULT_RPC_ENDPOINTS_BLSS)"
            MSG_OPSP_RPC="Optimism Sepolia RPC endpointləri (default: $DEFAULT_RPC_ENDPOINTS_OPSP)"
            break
            ;;
        ru)
            MSG_INVALID_LANG="Неверный код языка. Пожалуйста, попробуйте снова."
            MSG_CLEANUP="Очистка предыдущих установок..."
            MSG_DOWNLOAD="Загрузка последнего релиза..."
            MSG_EXTRACT="Распаковка архива..."
            MSG_INVALID_INPUT="Неверный ввод. Пожалуйста, введите 'api' или 'rpc'."
            MSG_PRIVATE_KEY="Введите ваш приватный ключ кошелька"
            MSG_GAS_VALUE="Введите значение газа (должно быть целым числом от 100 до 20000)"
            MSG_INVALID_GAS="Ошибка: Значение газа должно быть от 100 до 20000."
            MSG_NODE_TYPE="Вы хотите запустить API-узел или RPC-узел? (api/rpc)"
            MSG_RPC_ENDPOINTS="Хотите добавить пользовательские RPC-точки? (y/n)"
            MSG_THANKS="Если этот скрипт помог вам, не забудьте поставить ⭐ на GitHub 😉..."
            MSG_L1RN_RPC="Доступные L1RN RPC endpoints:"
            MSG_SELECT_L1RN="Введите номера L1RN RPC endpoints для включения (через запятую, например, 1,2):"
            MSG_INVALID_SELECTION="Неверный выбор: %s. Пропускаем."
            MSG_OUT_OF_RANGE="Индекс %s вне диапазона. Пропускаем."
            MSG_NO_SELECTION="Нет допустимых выборов. Пожалуйста, выберите хотя бы один endpoint."
            MSG_ALCHEMY_API_KEY="Введите ваш Alchemy API ключ:"
            MSG_CREATE_DIR="Создание и переход в директорию t3rn..."
            MSG_DOWNLOAD_COMPLETE="Загрузка завершена."
            MSG_NAVIGATE_BINARY="Переход к расположению бинарного файла executor..."
            MSG_COLLECTED_INPUTS="Собранные данные и настройки:"
            MSG_NODE_TYPE_LABEL="Тип узла:"
            MSG_ALCHEMY_API_KEY_LABEL="Ключ Alchemy API:"
            MSG_GAS_VALUE_LABEL="Значение газа:"
            MSG_RPC_ENDPOINTS_LABEL="RPC-точки:"
            MSG_WALLET_PRIVATE_KEY_LABEL="Приватный ключ кошелька:"
            MSG_FAILED_CREATE_DIR="Не удалось создать или перейти в директорию t3rn. Выход."
            MSG_FAILED_FETCH_TAG="Не удалось получить последний тег релиза. Проверьте подключение к интернету и попробуйте снова."
            MSG_FAILED_DOWNLOAD="Не удалось загрузить последний релиз. Проверьте URL и попробуйте снова."
            MSG_FAILED_EXTRACT="Не удалось извлечь архив. Проверьте файл и попробуйте снова."
            MSG_FAILED_NAVIGATE="Не удалось перейти к расположению бинарного файла executor. Выход."
            MSG_DELETE_T3RN_DIR="Удаление существующей директории t3rn..."
            MSG_DELETE_EXECUTOR_DIR="Удаление существующей директории executor..."
            MSG_DELETE_TAR_GZ="Удаление ранее загруженных tar.gz файлов..."
            MSG_EXTRACTION_COMPLETE="Архив успешно извлечен."
            MSG_RUNNING_NODE="Запуск узла..."
            MSG_DRY_RUN_DELETE="[Dry-run] Существующие директории t3rn и executor будут удалены."
            MSG_DRY_RUN_CREATE_DIR="[Dry-run] Будет создана и открыта директория t3rn."
            MSG_DRY_RUN_NAVIGATE="[Dry-run] Будет выполнен переход к расположению бинарного файла executor."
            MSG_DRY_RUN_RUN_NODE="[Dry-run] Узел будет запущен."
            MSG_ENTER_CUSTOM_RPC="Введите пользовательские RPC-точки:"
            MSG_ARBT_RPC="Arbitrum Sepolia RPC-точки (по умолчанию: $DEFAULT_RPC_ENDPOINTS_ARBT)"
            MSG_BSSP_RPC="Base Sepolia RPC-точки (по умолчанию: $DEFAULT_RPC_ENDPOINTS_BSSP)"
            MSG_BLSS_RPC="Blast Sepolia RPC-точки (по умолчанию: $DEFAULT_RPC_ENDPOINTS_BLSS)"
            MSG_OPSP_RPC="Optimism Sepolia RPC-точки (по умолчанию: $DEFAULT_RPC_ENDPOINTS_OPSP)"
            break
            ;;
        de)
            MSG_INVALID_LANG="Ungültiger Sprachcode. Bitte versuchen Sie es erneut."
            MSG_CLEANUP="Vorherige Installationen werden bereinigt..."
            MSG_DOWNLOAD="Die neueste Version wird heruntergeladen..."
            MSG_EXTRACT="Das Archiv wird entpackt..."
            MSG_INVALID_INPUT="Ungültige Eingabe. Bitte geben Sie 'api' oder 'rpc' ein."
            MSG_PRIVATE_KEY="Geben Sie Ihren privaten Wallet-Schlüssel ein"
            MSG_GAS_VALUE="Geben Sie den Gas-Wert ein (muss eine ganze Zahl zwischen 100 und 20000 sein)"
            MSG_INVALID_GAS="Fehler: Der Gas-Wert muss zwischen 100 und 20000 liegen."
            MSG_NODE_TYPE="Möchten Sie einen API-Knoten oder RPC-Knoten ausführen? (api/rpc)"
            MSG_RPC_ENDPOINTS="Möchten Sie benutzerdefinierte RPC-Endpoints hinzufügen? (y/n)"
            MSG_THANKS="Wenn Ihnen dieses Skript geholfen hat, vergessen Sie nicht, auf GitHub einen ⭐ zu hinterlassen 😉..."
            MSG_L1RN_RPC="Verfügbare L1RN RPC-Endpunkte:"
            MSG_SELECT_L1RN="Geben Sie die Nummern der zu aktivierenden L1RN RPC-Endpunkte ein (durch Kommas getrennt, z.B. 1,2):"
            MSG_INVALID_SELECTION="Ungültige Auswahl: %s. Übersprungen."
            MSG_OUT_OF_RANGE="Index %s liegt außerhalb des gültigen Bereichs. Übersprungen."
            MSG_NO_SELECTION="Keine gültigen Auswahlen. Bitte wählen Sie mindestens einen Endpunkt aus."
            MSG_ALCHEMY_API_KEY="Geben Sie Ihren Alchemy API-Schlüssel ein:"
            MSG_CREATE_DIR="Erstellen und Navigieren zum t3rn-Verzeichnis..."
            MSG_DOWNLOAD_COMPLETE="Download abgeschlossen."
            MSG_NAVIGATE_BINARY="Navigieren zum Speicherort der Executor-Binärdatei..."
            MSG_COLLECTED_INPUTS="Gesammelte Eingaben und Einstellungen:"
            MSG_NODE_TYPE_LABEL="Knotentyp:"
            MSG_ALCHEMY_API_KEY_LABEL="Alchemy API-Schlüssel:"
            MSG_GAS_VALUE_LABEL="Gaswert:"
            MSG_RPC_ENDPOINTS_LABEL="RPC-Endpunkte:"
            MSG_WALLET_PRIVATE_KEY_LABEL="Wallet-Privatschlüssel:"
            MSG_FAILED_CREATE_DIR="Fehler beim Erstellen oder Navigieren zum t3rn-Verzeichnis. Beenden."
            MSG_FAILED_FETCH_TAG="Fehler beim Abrufen des neuesten Release-Tags. Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut."
            MSG_FAILED_DOWNLOAD="Fehler beim Herunterladen des neuesten Releases. Bitte überprüfen Sie die URL und versuchen Sie es erneut."
            MSG_FAILED_EXTRACT="Fehler beim Entpacken des Archivs. Bitte überprüfen Sie die Datei und versuchen Sie es erneut."
            MSG_FAILED_NAVIGATE="Fehler beim Navigieren zum Speicherort der Executor-Binärdatei. Beenden."
            MSG_DELETE_T3RN_DIR="Löschen des vorhandenen t3rn-Verzeichnisses..."
            MSG_DELETE_EXECUTOR_DIR="Löschen des vorhandenen executor-Verzeichnisses..."
            MSG_DELETE_TAR_GZ="Löschen der zuvor heruntergeladenen tar.gz-Dateien..."
            MSG_EXTRACTION_COMPLETE="Entpacken abgeschlossen."
            MSG_RUNNING_NODE="Node wird gestartet..."
            MSG_DRY_RUN_DELETE="[Dry-run] Vorhandene t3rn- und executor-Verzeichnisse würden gelöscht."
            MSG_DRY_RUN_CREATE_DIR="[Dry-run] t3rn-Verzeichnis würde erstellt und dorthin navigiert."
            MSG_DRY_RUN_NAVIGATE="[Dry-run] Würde zum Speicherort der Executor-Binärdatei navigieren."
            MSG_DRY_RUN_RUN_NODE="[Dry-run] Node würde gestartet."
            MSG_ENTER_CUSTOM_RPC="Geben Sie benutzerdefinierte RPC-Endpunkte ein:"
            MSG_ARBT_RPC="Arbitrum Sepolia RPC-Endpunkte (Standard: $DEFAULT_RPC_ENDPOINTS_ARBT)"
            MSG_BSSP_RPC="Base Sepolia RPC-Endpunkte (Standard: $DEFAULT_RPC_ENDPOINTS_BSSP)"
            MSG_BLSS_RPC="Blast Sepolia RPC-Endpunkte (Standard: $DEFAULT_RPC_ENDPOINTS_BLSS)"
            MSG_OPSP_RPC="Optimism Sepolia RPC-Endpunkte (Standard: $DEFAULT_RPC_ENDPOINTS_OPSP)"
            break
            ;;
        id)
            MSG_INVALID_LANG="Kode bahasa tidak valid. Silakan coba lagi."
            MSG_CLEANUP="Membersihkan instalasi sebelumnya..."
            MSG_DOWNLOAD="Mengunduh rilis terbaru..."
            MSG_EXTRACT="Mengekstrak arsip..."
            MSG_INVALID_INPUT="Input tidak valid. Masukkan 'api' atau 'rpc'."
            MSG_PRIVATE_KEY="Masukkan kunci pribadi dompet Anda"
            MSG_GAS_VALUE="Masukkan nilai gas (harus bilangan bulat antara 100 dan 20000)"
            MSG_INVALID_GAS="Kesalahan: Nilai gas harus antara 100 dan 20000."
            MSG_NODE_TYPE="Apakah Anda ingin menjalankan node API atau node RPC? (api/rpc)"
            MSG_RPC_ENDPOINTS="Apakah Anda ingin menambahkan endpoint RPC kustom? (y/n)"
            MSG_THANKS="Jika skrip ini membantu Anda, jangan lupa beri ⭐ di GitHub 😉..."
            MSG_L1RN_RPC="Endpoint L1RN RPC yang tersedia:"
            MSG_SELECT_L1RN="Masukkan nomor endpoint L1RN RPC yang ingin diaktifkan (dipisahkan koma, misalnya, 1,2):"
            MSG_INVALID_SELECTION="Pilihan tidak valid: %s. Dilewati."
            MSG_OUT_OF_RANGE="Indeks %s di luar rentang. Dilewati."
            MSG_NO_SELECTION="Tidak ada pilihan yang valid. Silakan pilih setidaknya satu endpoint."
            MSG_ALCHEMY_API_KEY="Masukkan kunci API Alchemy Anda:"
            MSG_CREATE_DIR="Membuat dan menavigasi ke direktori t3rn..."
            MSG_DOWNLOAD_COMPLETE="Unduhan selesai."
            MSG_NAVIGATE_BINARY="Menavigasi ke lokasi biner executor..."
            MSG_COLLECTED_INPUTS="Input dan pengaturan yang dikumpulkan:"
            MSG_NODE_TYPE_LABEL="Tipe Node:"
            MSG_ALCHEMY_API_KEY_LABEL="Kunci API Alchemy:"
            MSG_GAS_VALUE_LABEL="Nilai Gas:"
            MSG_RPC_ENDPOINTS_LABEL="Endpoint RPC:"
            MSG_WALLET_PRIVATE_KEY_LABEL="Kunci Pribadi Dompet:"
            MSG_FAILED_CREATE_DIR="Gagal membuat atau berpindah ke direktori t3rn. Keluar."
            MSG_FAILED_FETCH_TAG="Gagal mengambil tag rilis terbaru. Silakan periksa koneksi internet Anda dan coba lagi."
            MSG_FAILED_DOWNLOAD="Gagal mengunduh rilis terbaru. Silakan periksa URL dan coba lagi."
            MSG_FAILED_EXTRACT="Gagal mengekstrak arsip. Silakan periksa file dan coba lagi."
            MSG_FAILED_NAVIGATE="Gagal berpindah ke lokasi biner executor. Keluar."
            MSG_DELETE_T3RN_DIR="Menghapus direktori t3rn yang ada..."
            MSG_DELETE_EXECUTOR_DIR="Menghapus direktori executor yang ada..."
            MSG_DELETE_TAR_GZ="Menghapus file tar.gz yang sebelumnya diunduh..."
            MSG_EXTRACTION_COMPLETE="Ekstraksi selesai."
            MSG_RUNNING_NODE="Menjalankan node..."
            MSG_DRY_RUN_DELETE="[Dry-run] Direktori t3rn dan executor yang ada akan dihapus."
            MSG_DRY_RUN
