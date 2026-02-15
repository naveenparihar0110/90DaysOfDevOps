# ---------- Task 1: Input Validation ----------

if [ $# -eq 0 ]; then
    echo "Error: No log file provided."
    echo "Usage: ./log_analyzer.sh <log_file_path>"
    exit 1
fi

LOG_FILE=$1

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' does not exist."
    exit 1
fi

echo "Processing log file: $LOG_FILE"
echo ""

# ---------- Basic Info ----------
DATE=$(date +%Y-%m-%d)
REPORT_FILE="log_report_${DATE}.txt"
TOTAL_LINES=$(wc -l < "$LOG_FILE")

# ---------- Task 2: Error Count ----------
ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)

echo "Total ERROR/Failed count: $ERROR_COUNT"
echo ""

# ---------- Task 3: Critical Events ----------
echo "--- Critical Events ---"
CRITICAL_EVENTS=$(grep -n "CRITICAL" "$LOG_FILE"| sed 's/^/LINE /')

if [ -z "$CRITICAL_EVENTS" ]; then
    echo "No critical events found."
                                                                                                                                                                        7,1           Top
