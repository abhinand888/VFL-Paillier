#!/bin/bash

# Check if the arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <job_id> <container_name> <model>"
    exit 1
fi

# Define the job ID, container name, and algorithm
job_id="$1"
container_name="$2"
model="$3"

# Copy logs from Docker container to the local directory
docker cp "$container_name":/data/projects/fate/fateflow/logs/"$job_id" /home/fate/logs || {
    echo "Failed to copy logs from Docker container."
    exit 1
}

# Define the source folder
SOURCE_FOLDER="/home/fate/logs/$job_id"

# Check if the source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
    echo "Source folder not found: $SOURCE_FOLDER"
    exit 1
fi

# Create the fate_paillier1 folder if it doesn't exist
mkdir -p "/home/fate/logs/fate_paillier1"

# Function to extract and save lines to destination file if pattern exists
extract_and_save_logs() {
    echo "Extracting and saving $2 logs..."
    # Check if directory exists
    if [ -d "$1" ]; then
        # Count the occurrences of specified patterns in INFO.log
        pattern_count=$(grep -c -E 'Enter raw_encrypt|Exit raw_encrypt|Enter __mul__|Exit __mul__|Enter __raw_add|Exit __raw_add|Enter raw_decrypt|Exit raw_decrypt' "$1/INFO.log")
        if [ $pattern_count -gt 0 ]; then
            # Extract lines containing specified patterns from INFO.log
            grep -E 'Enter raw_encrypt|Exit raw_encrypt|Enter __mul__|Exit __mul__|Enter __raw_add|Exit __raw_add|Enter raw_decrypt|Exit raw_decrypt' "$1/INFO.log" > "$2"
            echo "$model logs saved to: $2"
        fi
    else
        echo "$3 directory not found: $1"
    fi
}

# Define the destination file paths
DESTINATION_FILE_ARBITER="/home/fate/logs/fate_paillier1/${container_name}:${job_id}-arbiter-${model}.log"
DESTINATION_FILE_GUEST="/home/fate/logs/fate_paillier1/${container_name}:${job_id}-guest-${model}.log"
DESTINATION_FILE_HOST="/home/fate/logs/fate_paillier1/${container_name}:${job_id}-host-${model}.log"

# Navigate to the specified directory and process INFO.log for arbiter
extract_and_save_logs "$SOURCE_FOLDER/arbiter/10000/$model" "$DESTINATION_FILE_ARBITER" "Arbiter"

# Navigate to the specified directory and process INFO.log for guest
extract_and_save_logs "$SOURCE_FOLDER/guest/9999/$model" "$DESTINATION_FILE_GUEST" "Guest" || extract_and_save_logs "$SOURCE_FOLDER/host/10000/$model" "$DESTINATION_FILE_HOST" "Host"

# Navigate to the specified directory and process INFO.log for host if it's not processed already
if [ ! -f "$DESTINATION_FILE_HOST" ]; then
    extract_and_save_logs "$SOURCE_FOLDER/host/10000/$model" "$DESTINATION_FILE_HOST" "Host"
fi

# Display completion message
echo "Extraction and saving completed."

