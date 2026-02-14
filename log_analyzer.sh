#!/bin/bash

# ==============================
# Log Analyzer & Report Generator
# ==============================

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
else
    echo "$CRITICAL_EVENTS"
fi
echo ""

# ---------- Task 4: Top 5 Error Messages ----------
echo "--- Top 5 Error Messages ---"

TOP_ERRORS=$(grep "ERROR" "$LOG_FILE" \
    | sed -E 's/^.*ERROR[[:space:]]*\]? ?//; s/[[:space:]]*-[[:space:]]*[0-9]+$//' \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -5)

if [ -z "$TOP_ERRORS" ]; then
    echo "No ERROR messages found."
else
    echo "$TOP_ERRORS"
fi

# ---------- Task 5: Generate Report ----------
{
    echo "===== Log Analysis Report ====="
    echo "Date of Analysis: $DATE"
    echo "Log File: $LOG_FILE"
    echo "Total Lines Processed: $TOTAL_LINES"
    echo "Total ERROR/Failed Count: $ERROR_COUNT"
    echo ""
    echo "----- Top 5 Error Messages -----"
    echo "$TOP_ERRORS"
    echo ""
    echo "----- Critical Events -----"
    echo "$CRITICAL_EVENTS"
} > "$REPORT_FILE"

echo ""
echo "Report generated: $REPORT_FILE"

# ---------- Task 6: Archive Log ----------
ARCHIVE_DIR="archive"

if [ ! -d "$ARCHIVE_DIR" ]; then
    mkdir "$ARCHIVE_DIR"
fi

mv "$LOG_FILE" "$ARCHIVE_DIR/"
echo "Log file moved to archive/"

echo "Log analysis completed successfully!"

