#!/bin/sh
#rm *.out
rm BT_velocity.o* BT_velocity.e*
rm hostfile_BT.txt
rm BT_velocity.out

sbatch BT_velocity_run.slurm

squeue -u smomw557


