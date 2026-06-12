#!/bin/sh
#rm *.out
rm BC_pressure.o* BC_pressure.e*
rm hostfile_pressure.txt
rm BC_pressure.out

sbatch BC_pressure_run.slurm

squeue -u smomw557


