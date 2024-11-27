#!/bin/bash

# Base URL and output directory
BASE_URL="https://data.finlex.fi/eli/sd"
EXTENSION=".jsonld"
OUTPUT_DIR="finlex_data"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Fetch the JSON data
echo "Fetching data from ${BASE_URL}${EXTENSION}..."
RESPONSE=$(curl -s "${BASE_URL}${EXTENSION}")

# Extract years
YEARS=$(echo "$RESPONSE" | jq -r '.[] | .year' | sort -r)

# Check if any years were found
if [ -z "$YEARS" ]; then
  echo "No years found. Exiting."
  exit 1
fi

# Iterate over each year and download the corresponding file
echo "Processing data..."
for YEAR in $YEARS; do
  # Construct the link for the year
  LINK="${BASE_URL}/${YEAR}${EXTENSION}"
  
  # Create a directory for the year
  YEAR_DIR="${OUTPUT_DIR}/${YEAR}"
  mkdir -p "$YEAR_DIR"

  # Download the data
  OUTPUT_FILE="${YEAR_DIR}/${YEAR}${EXTENSION}"
  echo "Downloading data for year $YEAR from $LINK..."
  curl -s -o "$OUTPUT_FILE" "$LINK"

  if [ $? -eq 0 ]; then
    echo "Saved: $OUTPUT_FILE"
  else
    echo "Failed to download data for year $YEAR"
  fi
done

echo "All downloads completed."

