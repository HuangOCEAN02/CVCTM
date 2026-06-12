#!/bin/bash
#SBATCH --job-name=MSS_2014       # Job name
#SBATCH --nodes=1                     # Number of nodes requested
#SBATCH --ntasks-per-node=1  # Number of tasks per node
#SBATCH --cpus-per-task=1        # Number of CPU cores per task
#SBATCH --output=Cal_M2.o%j      # orctm.o%j output and error file name (%j expands to jobID)
#SBATCH --error=Cal_M2.e%j       # Error file name
#SBATCH --mem=128000
#SBATCH --time=1-24:00:00
#SBATCH --partition=base

# run the executable
srun hostname>./hostfile_BC.txt
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

# matlab -nodispla < Mode_M2_decomposition_MSS_new.m >> M2_decompo.out
# matlab -nodispla < Mode_M2_Sgin_MSS.m >> M2_Sign.out
 matlab -nodispla < Mode_M2_variables_MSS_new.m >> Cal_M2_variables.out
# matlab -nodispla < Cal_TGC.m >>  Cal_TGC_Tmn.out
# matlab -nodispla < Cal_InterMode.m >> Cal_IM_Cmn.out
# matlab -nodispla < Cal_Effective_terms.m >> Cal_E_terms.out
# matlab -nodispla < Cal_Effective_BT_terms.m >> Cal_E_BT_terms.out
# matlab -nodispla < Cal_Equations_term.m >> Cal_Equation.out
# matlab -nodispla < Cal_Equations_BT_term.m >> Cal_Equation_BT_terms.out
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
