#!/usr/bin/bash

nextflow run ./main.nf \
	-profile local,singularity \
	-resume \
	--input_barcodes "test/barcode*" \
	--workflow "chloroplast-contamination" \
	--output_dir "results" \
	--input_fastq "results/concat_barcoded/*.fastq.gz" \
	--genome_chl "/home/kgagalova/NC_056985_chl.fasta" \
        -with-singularity "containers/singularity/ont-tools.sif"

#-r main ccdmb/ONT-tools \
