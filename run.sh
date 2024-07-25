#!/bin/zsh

DATA_DUMP_DIR="$1"
PROJECT_ROOT="$(pwd)"
DATA_DIR="$PROJECT_ROOT/data"

# Check if the DATA_DUMP_DIR is provided
if [ -z "$DATA_DUMP_DIR" ]; then
  echo "Usage: $0 <data_dump_directory>"
  exit 1
fi

# Ensure the data directory exists
if [ ! -d "$DATA_DIR" ]; then
  mkdir -p "$DATA_DIR"
fi

# Check if the activities.csv exists
if [ ! -f "$DATA_DUMP_DIR/activities.csv" ]; then
  echo "File $ACTIVITIES_FILE_NAME does not exist in $DATA_DUMP_DIR"
  exit 1
fi

# Copy the activities.csv
cp "$DATA_DUMP_DIR/activities.csv" "$DATA_DIR/"

# Check if the activities directory exists
if [ ! -d "$DATA_DUMP_DIR/activities/" ]; then
  echo "Directory $DATA_DUMP_DIR/activities does not exist in $DATA_DUMP_DIR"
  exit 1
fi

# Copy the activities directory
cp -r "$DATA_DUMP_DIR/activities" "$DATA_DIR/"

# Remove .fit.gz files from activities directory
for file in "$DATA_DIR/activities"/*.fit.gz; do
  if [ -f "$file" ]; then
    rm "$file"
    if [ $? -eq 0 ]; then
      echo "Removed $file"
    else
      echo "Failed to remove $file"
    fi
  fi
done

# Convert all .gpx files to .csv
for activity_file_gpx in "$DATA_DIR/activities"/*.gpx; do
  if [ -f "$activity_file_gpx" ]; then
    gpxcsv "$activity_file_gpx"
    rm "$activity_file_gpx"
    if [ $? -eq 0 ]; then
      echo "Converted $activity_file_gpx to csv"
    else
      echo "Failed to convert $activity_file_gpx"
    fi
  fi
done

# Process activity files
python3 src/process_data.py

# Remove temp files
rm -r "$DATA_DIR/activities"

