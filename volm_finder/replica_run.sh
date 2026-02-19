#!/bin/bash

TEMPLATE_DIR="template_dir"

for i in {001..080}; do
    DIR="dir_${i}"
    echo "Creating $DIR..."
    mkdir -p "$DIR"
    cp -r "$TEMPLATE_DIR"/* "$DIR"
    (cd "$DIR" && JOB_ID=$(sbatch equilb_gromacs.sh | awk '{print $4}') && echo "$DIR $JOB_ID" >> ../submitted_job_ids_eqlb-1.txt)
 
done

