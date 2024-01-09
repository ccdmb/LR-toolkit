#!/bin/bash

# author: Kristina Gagalova
# description: concatenate gzip-ed files in specified directory, output is a gziped file with the directory name

# Check if correct number of arguments provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_directory output_directory"
    exit 1
fi

input_dir=$1
output_dir=$2

mkdir -p $output_dir

# Check if the directory exists
if [ ! -d "$input_dir" ]; then
    echo "Input directory does not exist"
    exit 1
fi

# Check if there are any .gz files in the directory
if ! ls "$input_dir"/*.gz &>/dev/null; then
    echo "No .gz files found in input directory"
    exit 1
fi

# Concatenate all gzipped files into a single file
dir_name="$(basename $input_dir)"
zcat "$input_dir"/*.gz | gzip > "$output_dir/${dir_name}.fastq.gz"

echo "Concatenation complete. Output file: $output_dir/${dir_name}.gz"
