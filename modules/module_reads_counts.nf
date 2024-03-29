#!/usr/bin/env nextflow
nextflow.enable.dsl=2

genome             = params.genome
genes              = params.genes
outdir             = params.output_dir
workflow           = params.workflow

process run_feature_counts {
    time '1d'    

    label 'medium_task'
    tag { "featureCounts: ${sample_id}" }
    publishDir "${outdir}/alignements/${workflow}/counts/featureCounts/${sample_id}", mode: 'copy'

    input:
    tuple val(sample_id), path(bam)
    tuple val(genome_id), path(genome)
    path(genes)

    output:
    tuple val(sample_id), path("${sample_id}_counts"), emit: counts
    tuple val(sample_id), path("${sample_id}_counts.summary"), emit: summary

    script:
    """
    featureCounts \
	-L \
        -G ${genome} \
        -a ${genes} \
        -T ${task.cpus} \
        -o ${sample_id}_counts \
        ${bam}
    """
}
