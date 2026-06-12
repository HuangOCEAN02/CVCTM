#!/bin/sh
#rm *.out
rm BC_ave.o* BC_ave.e*
rm hostfile.txt
rm BC_average.out

sbatch BC_average_run.slurm

squeue -u smomw557


