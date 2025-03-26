#!/bin/bash
#SBATCH --ntasks-per-node 5
#SBATCH -N 1
#SBATCH -t 08:00:00
#SBATCH -A csens2024-3-2
#SBATCH -J SingS1.6
#SBATCH -o SingS1.6.%j.out
#SBATCH -e SingS1.6.%j.err

ml SingSingCell/1.6

exit 0
