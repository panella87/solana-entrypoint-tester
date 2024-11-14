# Define the input file with entry points and output log file
ENTRYPOINTS_FILE="entrypoints.txt"
LOG_FILE="entrypoints.log"

# Check if entrypoints.txt exists
if [ ! -f "$ENTRYPOINTS_FILE" ]; then
  echo "Error: '$ENTRYPOINTS_FILE' not found."
  echo "Please check the repository README for setup instructions on creating or populating this file."
  exit 1
fi

# Clear the log file and add the header
> "$LOG_FILE"
echo "IP;SUCCESS;PING" >> "$LOG_FILE"

# Loop through each entrypoint in the file
while IFS= read -r entrypoint; do
  echo "Testing entrypoint: $entrypoint"

  # Run solana-gossip spy with a 3-second timeout
  OUTPUT=$(timeout 3 solana-gossip spy --entrypoint "$entrypoint" 2>&1)

  # Check for successful connection
  if echo "$OUTPUT" | grep -q "discovering..."; then
    # Run a single ping to the entrypoint and extract only the numerical ping time
    PING_OUTPUT=$(ping -c 1 "${entrypoint%:*}" | grep -oP 'time=\K\d+(\.\d+)?')
    echo "$entrypoint;true;$PING_OUTPUT" >> "$LOG_FILE"
  else
    echo "$entrypoint;false;" >> "$LOG_FILE"
  fi

done < "$ENTRYPOINTS_FILE"

echo "Testing completed. Results saved in $LOG_FILE."
