#!/bin/bash
read -p "Enter project suffix: " suffix 
MAIN_DIR="attendance_tracker_${suffix}"

archive_project() {
echo ""
echo "SIGINT detected. Archiving project..."

if [ -d "$MAIN_DIR" ]; then
    tar -czf "${MAIN_DIR}_archive.tar.gz" "$MAIN_DIR"
    rm -rf "$MAIN_DIR"
    echo "Archive created: ${MAIN_DIR}_archive.tar.gz"
    echo "Incomplete project removed."
fi

exit 1

}

trap archive_project SIGINT

echo "Creating project structure..."

mkdir -p "$MAIN_DIR/Helpers"
mkdir -p "$MAIN_DIR/reports"

touch attendance_checker.py "$MAIN_DIR/"
touch assets.csv "$MAIN_DIR/Helpers/"
touch config.json "$MAIN_DIR/Helpers/"
touch reports.log "$MAIN_DIR/reports/"

cat > "$MAIN_DIR/attendance_checker.py" << 'EOF'
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
# 1. Load Config
with open('Helpers/config.json', 'r') as f:
config = json.load(f)

```
# 2. Archive old reports.log if it exists
if os.path.exists('reports/reports.log'):
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

# 3. Process Data
with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
    reader = csv.DictReader(f)
    total_sessions = config['total_sessions']

    log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")

    for row in reader:
        name = row['Names']
        email = row['Email']
        attended = int(row['Attendance Count'])

        attendance_pct = (attended / total_sessions) * 100

        message = ""
        if attendance_pct < config['thresholds']['failure']:
            message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
        elif attendance_pct < config['thresholds']['warning']:
            message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."

        if message:
            if config['run_mode'] == "live":
                log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                print(f"Logged alert for {name}")
            else:
                print(f"[DRY RUN] Email to {email}: {message}")
```

if **name** == "**main**":
run_attendance_check()
EOF


cat > "$MAIN_DIR/Helpers/assets.csv" << EOF
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
EOF

cat > "$MAIN_DIR/Helpers/config.json" << EOF
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
EOF

echo "--- Attendance Report Initialized ---" > "$MAIN_DIR/reports/reports.log"



read -p "Would you like to update attendence thresholds? (y/n): " answer

if [ "$answer" = "y" ]; then
read -p "Enter warning threshold (default 75): " warning
read -p "enter failure threshold (default 50): " failure
[ -z "$warning" ] && warning=75
[ -z "$failure" ] && failure=50

if ! [[ "$warning" =~ ^[0-9]+$ ]]; then
    echo "Error: Warning threshold must be a number."
    exit 1
fi

if ! [[ "$failure" =~ ^[0-9]+$ ]]; then
    echo "Error: Failure threshold must be a number."
    exit 1
fi

if [ "$warning" -lt 0 ] || [ "$warning" -gt 100 ]; then
    echo "Error: Warning threshold must be between 0 and 100."
    exit 1
fi

if [ "$failure" -lt 0 ] || [ "$failure" -gt 100 ]; then
    echo "Error: Failure threshold must be between 0 and 100."
    exit 1
fi 

sed -i "s/\"warning\": 75/\"warning\": $warning/" "$MAIN_DIR/Helpers/config.json"
sed -i "s/\"failure\": 50/\"failure\": $failure/" "$MAIN_DIR/Helpers/config.json"
echo "Thresholds updated."

fi

echo "Running health check..."

if python3 --version >/dev/null 2>&1; then
echo "SUCCESS: Python3 installed."
else 
	echo "WARNING: Python3 not installed."
fi

	if [ -f "$MAIN_DIR/attendance_checker.py" ] &&
[ -f "$MAIN_DIR/Helpers/assets.csv" ] &&
[ -f "$MAIN_DIR/Helpers/config.json" ] &&
[ -f "$MAIN_DIR/reports/reports.log" ]; then
echo "SUCCESS: Directory structure verified."
else
echo "WARNING: Directory structure validation failed."
fi

echo "Project setup completed successfully."


