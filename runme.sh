#!/usr/bin/bash

nextflow run ./main.nf \
	-profile local,singularity \
	-resume \
	--input_dir "results/barcodes_concat/barcode*" \
	--workflow "reads-filter" \
	--output_dir "results" \
	-with-singularity "containers/singularity/ont-tools.sif"

#-r main ccdmb/ONT-tools \
