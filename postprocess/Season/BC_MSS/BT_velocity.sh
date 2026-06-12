#!/bin/sh
rm hostfile_BC.txt
rm BT_detide_velocity.out
rm BT_detide_velocity.e* BT_detide_velocity.o*

sbatch BT_velocity_run.slurm

squeue -u smomw557


