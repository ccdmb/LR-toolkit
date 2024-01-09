#!/usr/bin/env nextflow
nextflow.enable.dsl=2

outdir           = params.output_dir

process run_fastqc {

    label 'fastqc'
    tag { "fastqc: ${sample}" }
    
    input:
    tuple val(sample), path(reads)
    
    output:
    tuple val(sample), path("${sample}*.{html,zip}"), emit: qc_html
    
    """
    fastqc ${reads.findAll().join(' ')} \
        --threads ${task.cpus} \
        --noextract
    """
}

process run_multiqc_reads {

    label 'multiqc'
    tag { 'multiqc: all' }

    publishDir "${outdir}/reads-qc/", mode: 'copy', overwrite: true

    input:
    path(dir)
    
    output:
    tuple path("multiqc_report.html"), path("multiqc_data"), emit: multiQC
    
    script:
    """
    multiqc . --force
    """
}
