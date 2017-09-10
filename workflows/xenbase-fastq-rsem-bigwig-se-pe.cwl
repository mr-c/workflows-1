cwlVersion: v1.0
class: Workflow


requirements:
  - class: SubworkflowFeatureRequirement


inputs:
  upstream_fastq:
    type: File
  downstream_fastq:
    type: File?
  rsem_indices_folder:
    type: Directory
  chr_length_file:
    type: File
  threads:
    type: int?


outputs:

  rsem_isoforms:
    type: File
    outputSource: rsem_calculate_expression/isoform_results
  rsem_genes:
    type: File
    outputSource: rsem_calculate_expression/gene_results
  bam_file:
    type: File
    outputSource: rsem_calculate_expression/genome_sorted_bam_bai_pair
  bamtools_stats_log:
    type: File
    outputSource: bamtools_stats/stats_log
  bed:
    type: File
    outputSource: bam_to_bigwig/bed_file
  bigwig:
    type: File
    outputSource: bam_to_bigwig/outfile


steps:

  rsem_calculate_expression:
    run: ../tools/rsem-calculate-expression.cwl
    in:
      upstream_read_file: upstream_fastq
      downstream_read_file: downstream_fastq
      reference_name_dir: rsem_indices_folder
      bowtie2:
        default: true
      sort_bam_by_coordinate:
        default: true
      output_genome_bam:
        default: true
      threads: threads
    out:
      - isoform_results
      - gene_results
      - genome_sorted_bam_bai_pair

  bamtools_stats:
    run: ../tools/bamtools-stats.cwl
    in:
      input_files: rsem_calculate_expression/genome_sorted_bam_bai_pair
    out:
     - mappedreads
     - stats_log

  bam_to_bigwig:
    run: bam-genomecov-bigwig.cwl
    in:
      input: rsem_calculate_expression/genome_sorted_bam_bai_pair
      genomeFile: chr_length_file
      mappedreads: bamtools_stats/mappedreads
    out:
      - outfile
      - bed_file