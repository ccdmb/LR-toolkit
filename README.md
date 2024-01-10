# ONT-tools - a toolkit for ONT RNAseq data analysis

The pipeline performs several analyses that are suitable for barcoded reads.     

```
  nextflow run ./main.nf ...

Other parameters
  --input_barcodes     [string]  Directory with barcodes subdirectories (mydir/barcodes*) [default: test]
  --workflow           [string]  Tupe of workflow to run (accepted: concatenate, reads-qc, chloroplast-contamination, genome-mapping) [default:
                                 concatenate]
  --output_dir         [string]  Output directory for run [default: results]
  --input_fastq        [string]  Input directory with fastq files to process [default: reads]
  --genome_chl         [string]  Input chloroplast genome for contamination screening
  --genome_nuc         [string]  Input nuclear genome for reads mapping
``` 

* concatenate: combined multiple ```fastq.gz``` files stored in directory. The name of the final gzip-ed file is the name of the top directory
* reads-qc: fastqc of each barcode
* chloroplast-contamination: perform chloroplast contamination screening. Final output includes stats
* genome-mapping: ONT splice mapping on nuclear genome, includes counts analysis

Please use ```test/*``` data to run some examples.    
Create barcode files:
```
nextflow run ./main.nf \
        -profile local,singularity \
        -resume \
        --input_barcodes "test/barcode*" \
        --workflow "concatenate" \
	--output_dir "results"
```

Perform QC on reads
```
nextflow run ./main.nf \
        -profile local,singularity \
        -resume \
        --input_fasta "results/concat_barcoded/barcode*" \
        --workflow "reads-qc" \
        --output_dir "results"
```

Check presence of chloroplast sequences      
```
nextflow run ./main.nf \
        -profile local,singularity \
        -resume \
        --input_fasta "results/concat_barcoded/barcode*" \
        --workflow "chloroplast-contamination" \
        --output_dir "results" \
	--genome_chl "/path/to/my/chl/genome.fasta"
```

Map reads to reference genome    
```
nextflow run ./main.nf \
        -profile local,singularity \
        -resume \
        --input_fasta "results/concat_barcoded/barcode*" \
        --workflow "genome-mapping" \
        --output_dir "results" \
        --genome_chl "/path/to/my/nucl/genome.fasta" \
	--genes "/path/to/my/genes/genes.gtf"

```
