RASPBERRY_PI="${1:-10.0.0.236}"  # default if not provided
CODE_DIR="$(cd "$(dirname "$0")/../PlantMonitoringHost" && pwd)"

scp -r $CODE_DIR choporov@$RASPBERRY_PI:.
