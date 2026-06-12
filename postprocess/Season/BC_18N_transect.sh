#!/bin/sh
#rm *.out
# run BC_18N_transect.m
rm BC_18N_transect.o* BC_18N_transect.e*
rm hostfile.txt
rm BC_18N_transect.out

sbatch BC_18N_transect.slurm

squeue -u smomw557


