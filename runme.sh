#!/usr/bin/bash

nextflow run ./main.nf \
	-profile local \
	-resume \
	--input_barcodes "test/barcode*" \
	--workflow "concatenate" \
	--output_dir "results" \
        -with-singularity "containers/singularity/ont-tools.sif"

#-r main ccdmb/ONT-tools \
