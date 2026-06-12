#!/bin/sh
#rm *.out
rm BC_velocity.o* BC_velocity.e*
rm hostfile_BC.txt
rm BC_velocity.out

sbatch BC_velocity_run.slurm

squeue -u smomw557


