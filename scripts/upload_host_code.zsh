RASPBERRY_PI="${1:-10.0.0.236}"  # default if not provided
CODE_DIR="$(cd "$(dirname "$0")/../PlantMonitoringHost" && pwd)"

scp -r $CODE_DIR choporov@$RASPBERRY_PI:.
ssh choporov@$RASPBERRY_PI "sudo systemctl daemon-reload; sudo systemctl stop plant_monitoring; sudo systemctl disable plant_monitoring; sudo rm -rf /opt/PlantMonitoringHost; sudo mv ~/PlantMonitoringHost /opt/PlantMonitoringHost; sudo mv /opt/PlantMonitoringHost/plant_monitoring.service /etc/systemd/system/.; sudo systemctl enable plant_monitoring; sudo systemctl start plant_monitoring; sudo systemctl daemon-reload"
