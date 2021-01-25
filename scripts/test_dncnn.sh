#!/bin/bash

# The SBATCH directives must appear before any executable line in this script.

#SBATCH --time=0-3:00:0  # Time: D-H:M:S
#SBATCH --account=def-keli # Account
#SBATCH --mem=150G           # Memory in total
#SBATCH --nodes=1          # Number of nodes requested.
#SBATCH --cpus-per-task=2  # Number of cores per task.
#SBATCH --gres=gpu:1 # 32G V100
##SBATCH --gres=gpu:p100l:4 # 16G P100


# Uncomment this to have Slurm cd to a directory before running the script.
# You can also just run the script from the directory you want to be in.
#SBATCH -D /project/6054857/nio/srim/TTUR/

# Uncomment to control the output files. By default stdout and stderr go to
# the same place, but if you use both commands below they'll be split up.
# %N is the hostname (if used, will create output(s) per node).
# %j is jobid.
#SBATCH --output=./logs/slurm.test_dncnn.out
##SBATCH -e slurm.%N.%j.err    # STDERR

#SBATCH --mail-user=niopeng@hotmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
# Print some info for context.
pwd
hostname
date

echo "Starting job..."

source ~/.bashrc
conda activate py37

# Python will buffer output of your script unless you set this.
# If you're not using python, figure out how to turn off output
# buffering when stdout is a file, or else when watching your output
# script you'll only get updated every several lines printed.
export PYTHONUNBUFFERED=1

# Do all the research.
#cp /scratch/nio/srim/HyperRIM/results/Test_HyperRIM_x16_25/n07745940_test_fid/*.png /scratch/nio/srim/HyperRIM/results/Test_HyperRIM_x16_25/n07745940_fid/
python fid.py /project/6054857/nio/srim/DnCNN/results/RAISE-1K_1_fid_dncnn_25/ /project/6054857/nio/srim/data/RAISE-1K/ --gpu 0 -i /project/6054857/nio/srim/TTUR/ --lowprofile

# Print completion time.
date