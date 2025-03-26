#!/bin/bash

# Check if all required arguments are provided
if [ $# -ne 4 ]; then
    echo "Usage: $0 <filename> <n cores> <time> <cmd>"
    exit 1
fi

# Extract command-line arguments
filename=$1
integer=$2
time=$3
cmd=$4

# Extract the first 8 characters of the filename
bn=$(basename "$filename")
first_8_chars=$(echo "$bn" | cut -c 1-8)

# Create the file with the given filename and write the content to it
cat > "$filename" <<EOF
#!/bin/bash
#SBATCH --ntasks-per-node $integer
#SBATCH -N 1
#SBATCH -t $time
#SBATCH -A csens2024-3-2
#SBATCH -J $first_8_chars
#SBATCH -o $first_8_chars.%j.out
#SBATCH -e $first_8_chars.%j.err

$cmd

exit 0
EOF

echo "File '$filename' created with the specified content."

exit 0
