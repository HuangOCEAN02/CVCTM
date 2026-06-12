#!/bin/bash
#SBATCH --job-name=BC_pressure        # Job name
#SBATCH --nodes=1                     # Number of nodes requested
#SBATCH --ntasks-per-node=1  # Number of tasks per node
#SBATCH --cpus-per-task=32        # Number of CPU cores per task
#SBATCH --output=BC_pressure.o%j      # orctm.o%j output and error file name (%j expands to jobID)
#SBATCH --error=BC_pressure.e%j       # Error file name
#SBATCH --mem=128000
#SBATCH --time=1-24:00:00
#SBATCH --partition=base

# run the executable
srun hostname>./hostfile_pressure.txt
echo $SLURM_NTASKS 

export OMP_NUM_THREADS=1

echo =========================================================   
echo SLURM job: submitted  date = `date`      
date_start=`date +%s`

echo Executable file:                              
echo MPI parallel job.                                  
echo -------------  
echo Job output begins                                           
echo -----------------                                           
echo

ret=$?

 matlab -nodispla < BC_tide_pressure.m >> BC_pressure.out

 jobinfo
echo   
echo ---------------                                           
echo Job output ends                                           
date_end=`date +%s`
seconds=$((date_end-date_start))
minutes=$((seconds/60))
seconds=$((seconds-60*minutes))
hours=$((minutes/60))
minutes=$((minutes-60*hours))
echo =========================================================   
echo SLURM job: finished   date = `date`   
echo Total run time : $hours Hours $minutes Minutes $seconds Seconds
echo =========================================================   
exit $ret
