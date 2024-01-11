#!/usr/bin/bash

nextflow run ./main.nf \
	-profile local,singularity \
	-resume \
	--input_dir "results/barcodes_concat/barcode*" \
	--workflow "chloroplast-contamination" \
	--genome_chl "/home/kgagalova/NC_056985_chl.fasta" \
	--output_dir "results" \
	-with-singularity "containers/singularity/ont-tools.sif"

#-r main ccdmb/ONT-tools \
