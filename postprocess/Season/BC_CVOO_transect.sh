#!/bin/sh
#rm *.out
# run BC_CVOO_transect.m
rm BC_CVOO_transect.o* BC_CVOO_transect.e*
rm hostfile.txt
rm BC_CVOO_transect.out

sbatch BC_CVOO_transect.slurm

squeue -u smomw557


