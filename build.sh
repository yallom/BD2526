#!/bin/bash

OUTPUT="main.sql"

# Clear/create output file
> "$OUTPUT"

echo "-- ====================================" >> "$OUTPUT"
echo "-- MODEL" >> "$OUTPUT"
echo "-- ====================================" >> "$OUTPUT"
cat model.sql >> "$OUTPUT"
echo -e "\n\n" >> "$OUTPUT"

echo "-- ====================================" >> "$OUTPUT"
echo "-- TRIGGERS" >> "$OUTPUT"
echo "-- ====================================" >> "$OUTPUT"

# Concatenate all trigger files
find triggers -type f -name "*.sql" | sort | while read file
do
    echo -e "\n-- FILE: $file\n" >> "$OUTPUT"
    cat "$file" >> "$OUTPUT"
    echo -e "\n" >> "$OUTPUT"
done

echo "-- ====================================" >> "$OUTPUT"
echo "-- SEEDER" >> "$OUTPUT"
echo "-- ====================================" >> "$OUTPUT"
cat seeder.sql >> "$OUTPUT"
echo -e "\n\n" >> "$OUTPUT"

echo "-- ====================================" >> "$OUTPUT"
echo "-- PROCEDURES" >> "$OUTPUT"
echo "-- ====================================" >> "$OUTPUT"

# Concatenate all procedure files
find procedures -type f -name "*.sql" | sort | while read file
do
    echo -e "\n-- FILE: $file\n" >> "$OUTPUT"
    cat "$file" >> "$OUTPUT"
    echo -e "\n" >> "$OUTPUT"
done

echo "Generated $OUTPUT successfully."