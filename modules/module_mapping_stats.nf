#!/usr/bin/env nextflow
nextflow.enable.dsl=2

outdir           = params.output_dir
workflow         = params.workflow

process stats_mapping {
    time '1d'

    label 'medium_task'
    tag { 'stats mapping' }

    publishDir "${outdir}/alignements/mapping_stats/${workflow}", mode: 'copy', overwrite: true

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
    time '1h'

    label 'multiqc'
    tag { 'multiqc: all' }

    publishDir "${outdir}/alignements/mapping_stats/${workflow}", mode: 'copy', overwrite: true

    input:
    path(dir)

    output:
    tuple path("multiqc_report.html"), path("multiqc_data")

    script:
    """
    multiqc . --force
    """
}
