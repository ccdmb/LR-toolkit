#!/usr/bin/env nextflow
nextflow.enable.dsl=2

outdir           = params.output_dir

process run_fastqc {
    time '1h'

    label 'small_task'
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
    time '1h'

    label 'small_task'
    tag { 'multiqc: all' }

    publishDir "${outdir}/reads-qc/", mode: 'copy', overwrite: true

    input:
    path(dir)
    
    output:
    tuple path("multiqc_data"), path("multiqc_report.html"), emit: multiQC
    
    script:
    """
    multiqc . --force
    """
}

process get_stats_reads {

   label 'small_task'
   tag { "stats: all" }
   
   publishDir "${outdir}/reads-qc/", mode: 'copy', overwrite: true
   
   input:
   path(reads)

   output:
   path("reads.stats.tsv"), emit: statsfac

   """
   abyss-fac -s 0 ${reads.join(' ')} > reads.stats.tsv
   """      
}
