Analysing and Interpreting Genomic Datasets
===========================================

Project summary
---------------
This repository contains a small, reproducible analysis pipeline for processing viral sequencing data using the nf-core/viralrecon Nextflow workflow. It demonstrates how to:

- Convert raw sequencing FASTQ files into a samplesheet
- Run the `nf-core/viralrecon` pipeline (pinned to v2.6.0) using Nextflow
- Produce quality-control reports (FastQC / MultiQC), alignment files, and variant/consensus outputs

The repository is designed as a clear, recruiter-friendly example of genomics data processing and reproducible bioinformatics workflows.

Data used
---------
- Input: paired-end Illumina FASTQ files (.fastq or .fastq.gz). These are large raw read files and are intentionally ignored in git history.
- Reference: a viral reference FASTA (e.g., MN908947.3) used for mapping and variant calling.
- Sample metadata: `samplesheet.csv` and `samples.txt` — small, human-readable files that describe samples and are tracked in this repo.

Analysis performed
------------------
The pipeline performs the following high-level steps (configurable via `workflow commands.sh`):

1. Quality control (FastQC) and summarisation (MultiQC)
2. Read trimming and filtering (fastp / cutadapt)
3. Alignment to reference and BAM processing (bowtie2/samtools)
4. Variant calling and consensus generation (ivar/bcftools)
5. Optional assembly and downstream analyses (SPAdes, QUAST)

Reproducibility and environment
------------------------------
- Nextflow is installed into a Conda environment pinned to `nextflow=23.10.1` for reproducible workflow execution.
- The pipeline run in this repository uses `nf-core/viralrecon` pinned to tag `v2.6.0` to avoid breaking changes on `master`.
- Docker is the recommended execution engine (see `workflow commands.sh`), or you can switch to `conda`/`singularity` by editing the profile.

How to run (minimal)
---------------------
1. Install prerequisites (WSL/Ubuntu example):

```bash
# recommended: increase WSL memory via C:\Users\<you>\.wslconfig
# then in WSL:
sudo apt update && sudo apt upgrade -y
# install docker prerequisites (script contains commands)
```

2. Create the Nextflow environment and install Nextflow (conda):

```bash
conda create -n nextflow -c bioconda nextflow=23.10.1 -y
conda activate nextflow
nextflow -version
```

3. Generate a samplesheet from a FASTQ directory (helper included):

```bash
wget -L https://raw.githubusercontent.com/nf-core/viralrecon/master/bin/fastq_dir_to_samplesheet.py
chmod +x fastq_dir_to_samplesheet.py
python3 fastq_dir_to_samplesheet.py data samplesheet.csv -r1 _1.fastq.gz -r2 _2.fastq.gz
```

4. Run the pipeline (example):

```bash
nextflow run nf-core/viralrecon -r 2.6.0 -profile docker \
  --input samplesheet.csv --outdir results/viralrecon --protocol amplicon \
  --platform illumina --genome MN908947.3 --primer_set artic --primer_set_version 3 \
  --skip_kraken2 --skip_assembly -resume
```

Outputs
-------
- `results/viralrecon/` — pipeline outputs (reports, BAM/VCF/consensus FASTA, MultiQC html)
- `work/` — Nextflow temporary working directory (ignored by git)

Notes for recruiters
--------------------
This repository is intentionally compact and focuses on demonstrating:
- Best practices for reproducible genomics (version pinning, containerisation)
- Familiarity with nf-core pipelines and Nextflow orchestration
- Experience handling sequencing file formats and downstream QC/variant analysis

If you would like to see a small runnable example (using the test dataset or mocked FASTQ files), I can add a `demo/` folder with a tiny example and a short GitHub Actions job that runs the pipeline on CI.

Contact
-------
If you have questions about this repository or want additional examples (CI, smaller demo dataset, or a narrated walkthrough), tell me what you prefer and I'll add it.
