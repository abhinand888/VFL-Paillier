#!/bin/bash

# Check if all necessary arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <job_id> <container_name> <model>"
    exit 1
fi

# Define the job ID, container name, and model
job_id="$1"
container_name="$2"
model="$3"

# Define source folders
source_folder="/home/fate/logs/fate_paillier1"

# Check if source folders exist
if [ ! -d "$source_folder" ]; then
    echo "Source folder $source_folder does not exist."
    exit 1
fi

# Define source files for arbiter, guest, and host
source_arbi="$source_folder/${container_name}:${job_id}-arbiter-${model}.log"
source_guest="$source_folder/${container_name}:${job_id}-guest-${model}.log"
source_host="$source_folder/${container_name}:${job_id}-host-${model}.log"

# Function to check if file exists and has content
file_has_content() {
    if [ -s "$1" ]; then
        return 0 # File has content
    else
        return 1 # File is empty
    fi
}

# Function to grep and save if lines are present
grep_and_save() {
    if [ -e "$1" ]
    then
        count=$(grep -c "$3" "$1")
        if [ "$count" -gt 0 ]; then
          mkdir -p "$2"
          grep "$3" "$1" > "$2/$4"
        fi
    fi    
}

# Grep lines for arbiter
grep_and_save "$source_arbi" "/home/fate/logs/fate_paillier1/${job_id}-arbiter" "Enter raw_decrypt" "${container_name}:${job_id}-${model}-AND.LOG"
grep_and_save "$source_arbi" "/home/fate/logs/fate_paillier1/${job_id}-arbiter" "Exit raw_decrypt" "${container_name}:${job_id}-${model}-AXD.LOG"
grep_and_save "$source_arbi" "/home/fate/logs/fate_paillier1/${job_id}-arbiter" "Enter raw_encrypt" "${container_name}:${job_id}-${model}-ANE.LOG"
grep_and_save "$source_arbi" "/home/fate/logs/fate_paillier1/${job_id}-arbiter" "Exit raw_encrypt" "${container_name}:${job_id}-${model}-AXE.LOG"
grep_and_save "$source_arbi" "/home/fate/logs/fate_paillier1/${job_id}-arbiter" "Enter __mul__" "${container_name}:${job_id}-${model}-ANM.LOG"
grep_and_save "$source_arbi" "/home/fate/logs/fate_paillier1/${job_id}-arbiter" "Exit __mul__" "${container_name}:${job_id}-${model}-AXM.LOG"
grep_and_save "$source_arbi" "/home/fate/logs/fate_paillier1/${job_id}-arbiter" "Enter __raw_add" "${container_name}:${job_id}-${model}-ANA.LOG"
grep_and_save "$source_arbi" "/home/fate/logs/fate_paillier1/${job_id}-arbiter" "Exit __raw_add" "${container_name}:${job_id}-${model}-AXA.LOG"

# Grep lines for guest
grep_and_save "$source_guest" "/home/fate/logs/fate_paillier1/${job_id}-guest" "Enter raw_encrypt" "${container_name}:${job_id}-${model}-GNE.LOG"
grep_and_save "$source_guest" "/home/fate/logs/fate_paillier1/${job_id}-guest" "Exit raw_encrypt" "${container_name}:${job_id}-${model}-GXE.LOG"
grep_and_save "$source_guest" "/home/fate/logs/fate_paillier1/${job_id}-guest" "Enter __raw_add" "${container_name}:${job_id}-${model}-GNA.LOG"
grep_and_save "$source_guest" "/home/fate/logs/fate_paillier1/${job_id}-guest" "Exit __raw_add" "${container_name}:${job_id}-${model}-GXA.LOG"
grep_and_save "$source_guest" "/home/fate/logs/fate_paillier1/${job_id}-guest" "Enter __mul__" "${container_name}:${job_id}-${model}-GNM.LOG"
grep_and_save "$source_guest" "/home/fate/logs/fate_paillier1/${job_id}-guest" "Exit __mul__" "${container_name}:${job_id}-${model}-GXM.LOG"
grep_and_save "$source_guest" "/home/fate/logs/fate_paillier1/${job_id}-guest" "Enter raw_decrypt" "${container_name}:${job_id}-${model}-GND.LOG"
grep_and_save "$source_guest" "/home/fate/logs/fate_paillier1/${job_id}-guest" "Exit raw_decrypt" "${container_name}:${job_id}-${model}-GXD.LOG"

# Grep lines for host
grep_and_save "$source_host" "/home/fate/logs/fate_paillier1/${job_id}-host" "Enter raw_encrypt" "${container_name}:${job_id}-${model}-HNE.LOG"
grep_and_save "$source_host" "/home/fate/logs/fate_paillier1/${job_id}-host" "Exit raw_encrypt" "${container_name}:${job_id}-${model}-HXE.LOG"
grep_and_save "$source_host" "/home/fate/logs/fate_paillier1/${job_id}-host" "Enter __raw_add" "${container_name}:${job_id}-${model}-HNA.LOG"
grep_and_save "$source_host" "/home/fate/logs/fate_paillier1/${job_id}-host" "Exit __raw_add" "${container_name}:${job_id}-${model}-HXA.LOG"
grep_and_save "$source_host" "/home/fate/logs/fate_paillier1/${job_id}-host" "Enter __mul__" "${container_name}:${job_id}-${model}-HNM.LOG"
grep_and_save "$source_host" "/home/fate/logs/fate_paillier1/${job_id}-host" "Exit __mul__" "${container_name}:${job_id}-${model}-HXM.LOG"
grep_and_save "$source_host" "/home/fate/logs/fate_paillier1/${job_id}-host" "Enter raw_decrypt" "${container_name}:${job_id}-${model}-HND.LOG"
grep_and_save "$source_host" "/home/fate/logs/fate_paillier1/${job_id}-host" "Exit raw_decrypt" "${container_name}:${job_id}-${model}-HXD.LOG"

echo "Separating completed."

