#!/usr/bin/env nextflow

nextflow.enable.dsl=2

line="=".multiply(100)
ver="ont-tools:v0.0.1"

params.help                  = null
params.input_barcodes        = "test"
params.input_fastq           = "reads"
params.output                = "results"
params.workflow              = "concatenate"

//--------------------------------------------------------------------------------------------------------
// Validation

include { validateParameters; paramsHelp; paramsSummaryLog; fromSamplesheet } from 'plugin/nf-validation'

if (params.help) {
   log.info paramsHelp("nextflow run ./main.nf ...")
   exit 0
}

// Validate input parameters
validateParameters()

// Print summary of supplied parameters
log.info paramsSummaryLog(workflow)

workflow_input = params.workflow

switch (workflow_input) {
    case ["concatenate"]:
        include { concat_barcoded } from './modules/module_manage_files.nf'
	barcodes = params.input_barcodes
	barcodes = Channel.fromPath("${barcodes}", type:'dir', checkIfExists: true)
		.map {[ it.name, it ]}
	break;
    case ["reads-qc"]:
	include { run_fastqc; run_multiqc_reads } from './modules/module_reads_qc.nf'
	reads = params.input_fastq
	reads = Channel.fromPath("${reads}", checkIfExists: true)
		.map {[ it.simpleName, it ]}
	break;
    }

workflow CONCAT_BARCODES {
    take:
    barcodes
       
    main:
    concat_barcoded(barcodes)
}

workflow READS_QC {
    take:
    reads

    main:
    reads.view()
    run_fastqc(reads)
    run_fastqc.out.qc_html
        .map { it -> it[1] }
        .collect()
        .set { fastqc_out }
    run_multiqc_reads(fastqc_out)
}

workflow {

    READS_QC(reads)

}
