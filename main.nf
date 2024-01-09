#!/usr/bin/env nextflow

nextflow.enable.dsl=2

line="=".multiply(100)
ver="ont-tools v0.0.1"

params.help                  = null
params.input_barcodes        = "test"
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
	barcodes = Channel.fromPath("${barcodes}", type:'dir')
		.map {[ it.name, it ]}
	break;
    }

workflow CONCAT_BARCODES {
    take:
    barcodes
       
    main:
    concat_barcoded(barcodes)
}

workflow {

    CONCAT_BARCODES(barcodes)

}
