# Three-slab model for the dielectric permittivity of a lipid bilayer
In this repository, we provide all GROMACS molecular dynamics parameters (.mdp)
files for a simulation of dipalmitoylphosphatidylcholine (DPPC) lipid bilayer,
along with the necessary scripts to run them.



To reproduce the simulation, do the following:
## Find a simulation box with suitable volume
- Move into the `volm_finder` directory and execute the script `replica_run.sh`. This script generates 80 independent replicas of the same initial system using the folder `template_dir`, and will run energy minimization and equilibration scripts for all replicas. 
- After equilibration, compute the average of the instantaneous box volumes across the 80 replicas. Select the replica whose box volume is closest to the ensemble mean. This replica serves as the reference configuration.
- Finally, identify the directory corresponding to the selected reference replica for subsequent stages by renaming it as `dir_ref`.


## Zero field simulation
- Move into the `zero_field` folder and copy `dir_ref` from `volm_finder`.
- Copy the contents of the folder `transfer_scripts` to `dir_ref`.
- Execute the script `replica_run.sh`. This script creates 40 independent replicas of the same configuration from the folder `dir_ref`, and runs the equilibration and production scripts for each replica.


## Simulation with an electric field
- Create a new folder and copy the contents of the folder `zero_field/dir_ref` into it.
- To apply a uniform external DC electric field, modify the equilibration scripts (`step6.21_equilibration.mdp` through `step6.40_equilibration.mdp`) and the production script by adding one of the following lines, depending on the desired field direction:
```
electric-field-x = 0.03 0 0 0
electric-field-y = 0.03 0 0 0
electric-field-z = 0.03 0 0 0
```
Here, 0.03 (in V/nm) is shown as an example field strength along the chosen direction. Users may adjust this value according to the desired electric field magnitude.
- Copy `replica_run.sh` from the `zero_field` directory and adjust the loop range (for i in {001..040}) according to the required number of replicas.


# Equilibrated files
The `equilibrated-tpr-cpt-files` folder contains equilibrated GROMACS run input (`.tpr`) and checkpoint (`.cpt`) files for zero-field DPPC and DOPC lipid bilayer simulations. For both bilayer systems, 40 distinct replicas are provided, with each replica equilibrated for 20 ns.
