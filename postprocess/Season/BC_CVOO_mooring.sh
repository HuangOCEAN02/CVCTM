#!/bin/sh
#rm *.out
# run BC_CVOO_mooring.m
rm BC_CVOO_mooring.o* BC_CVOO_mooring.e*
rm hostfile.txt
rm BC_CVOO_mooring.out

sbatch BC_CVOO_mooring.slurm

squeue -u smomw557


