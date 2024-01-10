#!/usr/bin/env nextflow
nextflow.enable.dsl=2

outdir           = params.output_dir

process stats_mapping {

    label 'stats_mapping'
    tag { 'stats mapping' }

    publishDir "${outdir}/stats/", mode: 'copy', overwrite: true

    input:
    tuple val(sample), path(aligned_bam) 
    
    output:
    tuple val(sample), path("${sample}.stats.txt"), emit: stats
    
    script:
    """
    samtools stats \
	-@ ${task.cpus} \
	${aligned_bam} > "${sample}.stats.txt"
    """

}

process run_multiqc_stats {

    label 'multiqc'
    tag { 'multiqc: all' }

    publishDir "${outdir}/stats/", mode: 'copy', overwrite: true

    input:
    path(dir)

    output:
    tuple path("multiqc_report.html"), path("multiqc_data")

    script:
    """
    multiqc . --force
    """
}

