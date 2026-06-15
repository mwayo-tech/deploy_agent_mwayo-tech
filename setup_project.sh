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
cp attendance_checker.py "$MAIN_DIR/"
cp assets.csv "$MAIN_DIR/Helpers/"
cp config.json "$MAIN_DIR/Helpers/"
cp reports.log "$MAIN_DIR/reports/"

read -p "Would you like to update attendence thresholds? (y/n): " answer
if [ "$answer" = "y" ]; then
read -p "Enter warning threshold (default 75): " warning
read -p "enter failure threshold (default 50): " failure

[ -z "$warning" ] && warning=75 
[ -z "$failure" ] && failure=50

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


