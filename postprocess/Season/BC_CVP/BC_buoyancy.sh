#!/bin/sh
#rm *.out
rm BC_buoyancy.o* BC_buoyancy.e*
rm hostfile_buoyancy.txt
rm BC_buoyancy.out

sbatch BC_buoyancy_run.slurm

squeue -u smomw557


