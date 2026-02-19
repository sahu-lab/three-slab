#!/bin/bash

TEMPLATE_DIR="dir_ref"

for i in {001..040}; do
    DIR="dir_${i}"
    echo "Creating $DIR..."
    mkdir -p "$DIR"
    cp -r "$TEMPLATE_DIR"/* "$DIR"
    (cd "$DIR" && JOB_ID=$(sbatch prod_sim-1.sh | awk '{print $4}') && echo "$DIR $JOB_ID" >> ../submitted_job_ids_prod_sim-1.txt)
 
done

