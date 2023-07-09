#! /usr/bin/env nextflow
//define channels from input file
Channel 
    .fromPath(params.inputlist)
    .ifEmpty {exit 1, "Cannot find input file : ${params.inputlist}"}
    .splitCsv(skip:1)
    .map{tumour_sample_platekey,mtr_input,errorperc -> [tumour_sample_platekey, file(mtr_input), file(errorperc)]}
    .set{ ch_input }


//run the script to make MTR input on above file paths
process  CloudOS_MTR_input{
    maxForks 900
    errorStrategy 'ignore'
    maxRetries 3
    tag"$tumour_sample_platekey"
    publishDir "${params.outdir}/$tumour_sample_platekey", mode: 'copy'
    
    input:
    set val(tumour_sample_platekey), file(mtr_input), file(errorperc) from ch_input

    output:
    file "*_SNV_catalogues.pdf"
    file "*_catalogue.csv"
    //file "exposures.tsv"
    path "results/*"
    
    script:
    """
    fitms_nf.R '$tumour_sample_platekey' '$mtr_input' '$errorperc'
    """ 
}
