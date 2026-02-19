#!/bin/bash
#SBATCH -J equilb-1             # job name
#SBATCH -e myjob.%j.err             # error file name 
#SBATCH -o myjob.%j.out             # output file name 
#SBATCH -N 1                        # request 1 node
#SBATCH -n 128                      # request 128 MPI tasks 
#SBATCH -p normal                   # designate queue 
#SBATCH -t 09:00:00                 # designate max run time 
#SBATCH -A --------                 # charge job to myproject
#SBATCH --mail-type=BEGIN,END       # send email on job begin and end
#SBATCH --mail-user=sheraj.physics@utexas.edu  # specify your email address

module load gcc/11.2.0
module load impi/19.0.9
module load gromacs/2024
export OMP_NUM_THREADS=1            # 1 OMP thread per MPI task

# File prefixes
init="step5_input"
rest_prefix="step5_input"
mini_prefix="step6.0_minimization"
equi_prefix="step6"
prod_prefix="step7_production"
prod_step="step7"

# Energy minimization
gmx grompp -f "${mini_prefix}.mdp" -o "${mini_prefix}.tpr" -c "${init}.gro" -r "${rest_prefix}.gro" -p topol.top -n index.ndx
gmx mdrun -v -deffnm "${mini_prefix}"

# Equilibration
cnt=1
cntmax=20

while [ ${cnt} -le ${cntmax} ]; do
    pcnt=$((cnt - 1))
    istep=$(printf "${equi_prefix}.%d_equilibration" ${cnt})
    pstep=$(printf "${equi_prefix}.%d_equilibration" ${pcnt})
    if [ ${cnt} -eq 1 ]; then
        pstep=${mini_prefix}
    fi

    gmx grompp -f "${istep}.mdp" -o "${istep}.tpr" -c "${pstep}.gro" -r "${rest_prefix}.gro" -p topol.top -n index.ndx
    gmx mdrun -v -deffnm "${istep}"
    cnt=$((cnt + 1))
done
