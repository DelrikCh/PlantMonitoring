set -e

brew install arduino-cli

arduino-cli version
arduino-cli config init --overwrite
arduino-cli core update-index
arduino-cli core install esp32:esp32
arduino-cli board listall | grep "ESP32 Dev Module.*esp32:esp32:esp32" \
    || { echo "ESP32 Dev Module not found! Make sure ESP32 core installed correctly."; exit 1; }


echo "Successfully set up macos environment"
