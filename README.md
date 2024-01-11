# ONT-tools - a toolkit for ONT RNAseq data analysis

The pipeline performs several analyses that are suitable for barcoded reads.     

```
Generic options
  --workflow           [string]  Type of analysis to be run (accepted: concatenate, reads-qc, reads-filter, chloroplast-contamination, genome-mapping,
                                 isoform-analysis)

Input/output
  --input_dir          [string]  Input directory containing samples to process
  --output_dir         [string]  Output directory where the results will be written

Reference genomes
  --genome_chl         [string]  Chloroplast genome (small file)
  --genome_nuc         [string]  Nuclear genome
  --genes              [string]  Genes in gtf format

Filtering parameters
  --phred_score        [integer] Phres score used to exclude reads [default: 7]
``` 

* concatenate: combined multiple ```fastq.gz``` files stored in directory. The name of the final gzip-ed file is the name of the top directory
* reads-qc: fastqc of each barcode
* reads-filter: filter reads by phred score
* chloroplast-contamination: perform chloroplast contamination screening. Final output includes stats
* genome-mapping: ONT splice mapping on nuclear genome, includes counts analysis
* isoform-analysis:     

Please use ```test/*``` data to run some examples.    
Create barcode files:
```
nextflow run ccdm/ONT-toolkit -r main \
        -profile local,singularity \
        -resume \
        --input_dir "test/barcode*" \
        --workflow "concatenate" \
	--output_dir "results"
```

Perform QC on reads
```
nextflow run ccdm/ONT-toolkit -r main \
        -profile local,singularity \
        -resume \
        --input_dir "results/concat_barcoded/barcode*" \
        --workflow "reads-qc" \
        --output_dir "results"
```

Check presence of chloroplast sequences      
```
nextflow run ccdm/ONT-toolkit -r main \
        -profile local,singularity \
        -resume \
        --input_dir "results/concat_barcoded/barcode*" \
        --workflow "chloroplast-contamination" \
        --output_dir "results" \
	--genome_chl "/path/to/my/chl/genome.fasta"
```

Map reads to reference genome    
```
nextflow run ccdm/ONT-toolkit -r main \
        -profile local,singularity \
        -resume \
        --input_dir "results/concat_barcoded/barcode*" \
        --workflow "genome-mapping" \
        --output_dir "results" \
        --genome_chl "/path/to/my/nucl/genome.fasta" \
	--genes "/path/to/my/genes/genes.gtf"

```

Filter reads by phred score
```
nextflow run ccdm/ONT-toolkit -r main \
        -profile local,singularity \
        -resume \
        --input_dir "results/concat_barcoded/barcode*" \
        --workflow "reads-filter" \
        --output_dir "results" \
	--phred_score 10
```
