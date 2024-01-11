#!/usr/bin/env nextflow
nextflow.enable.dsl=2

outdir           = params.output_dir
workflow         = params.workflow

process minimap_create_index {

    label 'minimap'
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
    label 'minimap'
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
    label 'minimap'
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
	-d ${genome} \
	-t ${task.cpus} \
	-2 ${reads} -secondary=no | samtools sort -o ${sample}.bam
    """
}
