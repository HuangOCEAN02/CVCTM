#!/bin/sh
rm *.out
rm Cal_M2.o* Cal_M2.e*
#rm hostfile_BC.txt
#rm M2_decompo.out
#rm Cal_M2_variables.out

sbatch Mode_M2_Calcuate_run.slurm

squeue -u smomw557


