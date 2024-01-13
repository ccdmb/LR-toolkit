#!/usr/bin/env nextflow
nextflow.enable.dsl=2

outdir           = params.output_dir
workflow         = params.workflow

process minimap_create_index {
    time '2h'

    label 'medium_task'
    tag "minimap: create index"
    
    input:
    tuple val(sample), path(genome)
    
    output:
    path("${sample}.mmi"), emit: minimap_index
    
    """
    minimap2 \
	-d ${sample}.mmi \
	${genome} 
    """
}

process minimap_mapping_chlo {
    '''
    Function creates index on the fly and maps reads
    '''
    time '12h'

    label 'big_task'
    tag "minimap mapping: ${sample}"

    publishDir "${outdir}/alignements/${workflow}", mode: 'copy'

    input:
    path(genome)
    tuple val(sample), path(reads)

    output:
    tuple val(sample), path("${sample}.bam"), emit: minimap_align_chlo

    """
    minimap2 \
        -ax splice \
	-t ${task.cpus} \
        ${genome} \
        ${reads} | samtools sort -o ${sample}.bam
    """
}

process minimap_mapping {
    '''
    Function creates index and maps reads
    '''
    time '1d'
    label 'big_task'
    tag "minimap mapping: ${sample}"

    publishDir "${outdir}/alignements/${workflow}", mode: 'copy'

    input:
    path(genome)
    tuple val(sample), path(reads)
	
    output:
    tuple val(sample), path("${sample}.bam"), emit: minimap_align

    """
    minimap2 \
	-ax splice \
	-secondary=no \
	-t ${task.cpus} \
	${genome} \
	${reads} | samtools sort -o ${sample}.bam
    """
}

process minimap_mapping_large {
    '''
    Function creates index and maps reads foir large genomes 4Gb
    '''
    time '1d'
    label 'big_task'
    tag "minimap mapping: ${sample}"

    publishDir "${outdir}/alignements/${workflow}", mode: 'copy'

    input:
    path(genome)
    tuple val(sample), path(reads)

    output:
    tuple val(sample), path("${sample}.bam"), emit: minimap_align

    """
    minimap2 \
        -ax splice \
        -secondary=no \
	--split-prefix /tmp/temp_ \
        -t ${task.cpus} \
        ${genome} \
        ${reads} | samtools sort -o ${sample}.bam
    """
}
