#!/usr/bin/env nextflow

nextflow.enable.dsl=2

line="=".multiply(100)
ver="ont-tools:v0.0.1"

params.help                  = null

params.input_barcodes        = "test"
params.input_fastq           = "reads"
params.input_bam             = "bams"

params.genome_chl            = null
params.genome_nuc            = null

params.genes                 = null

params.phred_score           = 7

params.output_dir            = "results"
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
println(workflow_input)

switch (workflow_input) {
    case ["concatenate"]:
        include { concat_barcoded } from './modules/module_manage_files.nf'
	barcodes = params.input_barcodes
	barcodes = Channel.fromPath("${barcodes}", type:'dir', checkIfExists: true)
		.map {[ it.name, it ]}
	break;
    case ["reads-qc", "reads-filter"]:
	include { run_fastqc; run_multiqc_reads; get_stats_reads } from './modules/module_reads_qc.nf'
	include { filter_reads  } from './modules/module_reads_filtering.nf'
	reads = params.input_fastq
	phred = params.phred_score
	reads = Channel.fromPath("${reads}", checkIfExists: true)
		.map {[ it.simpleName, it ]}
	break;
    case ["chloroplast-contamination"]:
	include { minimap_mapping_chlo } from './modules/module_reads_mapping.nf'
	include { stats_mapping ; run_multiqc_stats } from './modules/module_mapping_stats.nf'
	reads = params.input_fastq
	genome_chl = file(params.genome_chl)
	reads = Channel.fromPath("${reads}", checkIfExists: true)
                .map {[ it.simpleName, it ]}
	break;
    case ["genome-mapping"]:
	include { minimap_mapping;  minimap_create_index } from './modules/module_reads_mapping.nf'
	include { stats_mapping ; run_multiqc_stats } from './modules/module_mapping_stats.nf'
	include { run_feature_counts } from './modules/module_reads_counts.nf'
	genome = file(params.genome_nuc)
	genome_counts = params.genome_nuc
	genes = file(params.genes)
	reads = params.input_fastq
	genome = Channel.fromPath("${genome}", checkIfExists: true)
                .map {[ it.simpleName, it ]}
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
    run_fastqc(reads)
    run_fastqc.out.qc_html
        .map { it -> it[1] }
        .collect()
        .set { fastqc_out }
    run_multiqc_reads(fastqc_out)

    reads.map { it -> it[1] }
	.collect()
	.set { allreads }    
    get_stats_reads(allreads)
}

workflow READS_FILTER {
    take:
    reads
    phred

    main:
    filter_reads(reads, phred)    
}

workflow CHLO_CONTAMINATION {
    take:
    genome_chl
    reads

    main:
    mapped_out = minimap_mapping_chlo(genome_chl, reads)
    stats_out = stats_mapping(mapped_out.minimap_align_chlo)
    stats_out.stats
        .map { it -> it[1] }
        .collect()
        .set { stats }
    run_multiqc_stats(stats)
}

workflow GENOME_MAPPING {
    take:
    genome
    genome_counts
    genes
    reads

    main:
    // create index and save on disk
    index = minimap_create_index(genome)

    // map ONT reads
    mapped_out = minimap_mapping(index.
				minimap_index
				.collect(),
				reads)

    // Get counts for genes
    run_feature_counts(mapped_out.alignements, genome_counts, genes)

    //QC and stats
    stats_out = stats_mapping(mapped_out.minimap_align)
    stats_out.stats
        .map { it -> it[1] }
        .collect()
        .set { stats }
    run_multiqc_stats(stats)
}

workflow {

	switchVariable = 0
	
	if (workflow_input == "concatenate") {
		switchVariable = 1;
	} else if (workflow_input == "reads-qc") {
		switchVariable = 2;
	} else if (workflow_input == "reads-filter") {
		switchVariable = 3;
	} else if (workflow_input == "chloroplast-contamination") {
		switchVariable = 4;
	} else if (workflow_input == "genome-mapping") {
                switchVariable = 5;
        }
        println(genome_chl)
	switch (switchVariable) {
	case 1:
		CONCAT_BARCODES(barcodes);
		break;
	case 2:
		READS_QC(reads);
		break;
	case 3:
		READS_FILTER(reads, phred);
		break;
	case 4:
		CHLO_CONTAMINATION(genome_chl, reads);
                break;
	case 5:
		GENOME_MAPPING(genome, genome_counts, genes, reads);
		break;
	default:
		println("Please provide the correct input options")
		break;
	}
}
