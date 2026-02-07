#!/bin/zsh
set -euo pipefail

FQBN="esp32:esp32:esp32"
SKETCH_DIR="$(cd "$(dirname "$0")/../Sensor" && pwd)"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <ESP32_IP> [RASPBERRY_PI_IP]"
  exit 1
fi

ESP32_IP="$1"
RASPBERRY_PI="${2:-10.0.0.236}"  # default if not provided

echo "Sketch directory: $SKETCH_DIR"
echo "Target ESP32 IP: $ESP32_IP"
echo "Board: $FQBN"
echo "Raspberry Pi: $RASPBERRY_PI"
echo

# Compile
echo "Compiling sketch..."
BUILD_DIR="/tmp/arduino-cli_build_output"
arduino-cli compile --fqbn "$FQBN" --build-path $BUILD_DIR "$SKETCH_DIR"

# Find the .bin file
BIN_FILE="$BUILD_DIR/Sensor.ino.bin"
if [[ -z "$BIN_FILE" ]]; then
  echo "Error: compiled .bin file not found"
  exit 1
fi
echo "Compiled binary: $BIN_FILE"
echo

# Copy binary to RPi
REMOTE_PATH="/home/choporov/esp32_bin"
ssh choporov@$RASPBERRY_PI "mkdir -p $REMOTE_PATH"
echo "Copying binary to Raspberry Pi..."
scp "$BUILD_DIR"/Sensor.ino*.bin choporov@$RASPBERRY_PI:"$REMOTE_PATH"/


# OTA from RPi
echo "Uploading firmware over OTA from RPi..."
ssh choporov@$RASPBERRY_PI "arduino-cli upload --fqbn '$FQBN' -p '$ESP32_IP' -i '$REMOTE_PATH/$(basename $BIN_FILE)' --verify --upload-field password="

echo
echo "✅ OTA update completed successfully"
