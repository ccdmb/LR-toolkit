#!/usr/bin/env nextflow
nextflow.enable.dsl=2

genome             = params.genome
genes              = params.genes
outdir             = params.output_dir
worflow            = params.workflow

process run_feature_counts {
    time '1d'    

    label 'medium_task'
    tag { "featureCounts: ${sample_id}" }
    publishDir "${outdir}/alignements/${workflow}/counts/featureCounts/${sample_id}", mode: 'copy', overwrite: true

    input:
    tuple val(sample_id), path(bam)
    path(genome)
    path(genes)

    output:
    tuple val(sample_id), path("${sample_id}_counts"), emit: counts
    tuple val(sample_id), path("${sample_id}_counts.summary"), emit: summary
    tuple val(sample_id), path("${sample_id}_counts.jcounts"), emit: jcounts

    script:
    """
    featureCounts \
        -G ${genome} \
        -a ${genes} \
        -T ${task.cpus} \
        -o ${sample_id}_counts \
        $bam
    """
}
