#!/bin/bash

#SBATCH --job-name=test
#SBATCH --mail-user=ytyang@cse.cuhk.edu.hk
#SBATCH --mail-type=ALL
#SBATCH --output=/research/d1/rshr/ytyang/transformer-xl/SLURM_LOG/%x-%j.txt
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1          # crucial - only 1 task per dist per node!
#SBATCH --gres=gpu:4

echo "START TIME: $(date)"
# Number of nodes
export NUM_NODES=2
# Number of GPUs per node
export GPUS_PER_NODE=4

export MASTER_ADDR=$(scontrol show hostnames $SLURM_JOB_NODELIST | head -n 1)
export MASTER_PORT=6000

# srun error handling:
# --wait=60: wait 60 sec after the first task terminates before terminating all remaining tasks
# --kill-on-bad-exit=1: terminate a step if any task exits with a non-zero exit code
SRUN_ARGS=" \
    --wait=60 \
    --kill-on-bad-exit=1 \
    "
echo "Use nodes: $SLURM_NNODES"

# source /research/d1/rshr/ytyang/anaconda3/bin/activate torch1.11
srun $SRUN_ARGS --jobid $SLURM_JOBID  bash -c 'CUDA_LAUNCH_BLOCKING=1 python -m torch.distributed.run \
--nproc_per_node $GPUS_PER_NODE --nnodes $SLURM_NNODES --node_rank $SLURM_PROCID \
--master_addr $MASTER_ADDR --master_port $MASTER_PORT \
    resnet.py --deepspeed --deepspeed_config ds_config.json --log-interval 20'