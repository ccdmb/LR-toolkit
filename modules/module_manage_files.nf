#!/usr/bin/env nextflow
nextflow.enable.dsl=2

barcodes_dir           = params.barcodes_dir
outdir                 = params.output_dir

process concat_barcoded {

    tag { "concat barcode: ${barcode}" }
    publishDir "${outdir}/concat_barcoded/", mode: 'copy', overwrite: true

    input:
    tuple val(barcode), path(barcodes_dir)

    output:
    tuple val(barcode), path("${barcode}.fastq.gz"), emit: barcode_concat

    """
    bash concat_barcodes.sh ${barcodes_dir} ./   
    """
}
