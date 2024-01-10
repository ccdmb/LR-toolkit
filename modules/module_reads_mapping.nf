#!/usr/bin/env nextflow
nextflow.enable.dsl=2

outdir           = params.output_dir


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

process minimap_mapping {
    '''
    Function creates index and maps reads
    '''
    label 'minimap'
    tag "minimap mapping: ${sample}"

    publishDir "${outdir}/alignements", mode: 'copy'

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
