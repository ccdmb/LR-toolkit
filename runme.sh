#!/usr/bin/bash

nextflow run ./main.nf \
	-profile local,singularity \
	-resume \
	--input_dir "results/barcodes_concat/barcode*" \
	--workflow "genome-mapping" \
	--output_dir "results" \
	--genome_nuc "/home/kgagalova/Hordeum_vulgare.MorexV3_pseudomolecules_assembly.dna.toplevel_nams.fa" \
	--genes "/home/kgagalova/Hv_Morex.pgsb.Jul2020.gtf" \
	-with-singularity "containers/singularity/ont-tools.sif"

#-r main ccdmb/ONT-tools \
