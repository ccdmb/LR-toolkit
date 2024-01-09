#!/usr/bin/bash

nextflow run ./main.nf \
	-profile local,singularity \
	-resume \
	--input_barcodes "test/barcode*" \
	--workflow "reads-qc" \
	--output_dir "results" \
	--input_fastq "results/concat_barcoded/*.fastq.gz" \
        -with-singularity "containers/singularity/ont-tools.sif"

#-r main ccdmb/ONT-tools \
