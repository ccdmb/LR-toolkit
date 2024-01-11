#!/usr/bin/env nextflow
nextflow.enable.dsl=2

outdir           = params.output_dir


process filter_reads {
    time '1d'    

    label 'small_task'
    tag { "filtering reads: ${sample}" }

    publishDir "${outdir}/filtered_reads/", mode: 'copy', overwrite: true

    input:
    tuple val(sample), path(reads)
    val(phred)
    
    output:
    tuple val(sample), path("${sample}_filt${phred}.fastq.gz"), emit: stats
    
    script:
    """
    seqkit seq \
	-Q ${phred} \
	${reads} -o ${sample}_filt${phred}.fastq.gz  
    """
}
