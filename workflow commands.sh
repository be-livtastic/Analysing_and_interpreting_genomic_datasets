#Set Up Docker and Conda


#Install Conda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# Set Up Conda Channels
conda config --add channels conda-forge
conda config --add channels bioconda
conda config --add channels defaults

# Install Docker external apt repo for Ubuntu by running the following commands in your terminal:
# For Docker installation, run this line by line

# DOCKER INSTALL (Ubuntu/WSL)
# update system packages
sudo apt update && sudo apt upgrade -y

# install dependencies for docker
sudo apt install -y ca-certificates curl gnupg lsb-release

# add docker key 
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# add repo
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# start + permission
sudo service docker start
sudo usermod -aG docker $USER
newgrp docker

# test
docker run hello-world

# fix errors
# permission denied → run usermod + newgrp again
# daemon error → sudo service docker start


#Create Nextflow Environment and Install Nextflow (version 23.10.1)
conda create -n nextflow -c bioconda nextflow=23.10.1 -y

# Activate Nextflow Environment
conda activate nextflow

# Check Nextflow Installation
nextflow -version

# Activate MOOC Environment
conda activate MOOC


wget -L https://raw.githubusercontent.com/nf-core/viralrecon/master/bin/fastq_dir_to_samplesheet.py #Download the fastq_dir_to_samplesheet.py script from the nf-core/viralrecon 
# repository on GitHub. This script is used to convert a directory of FASTQ files into a samplesheet format that can be used by the viralrecon pipeline.
chmod +x fastq_dir_to_samplesheet.py #Make the downloaded script executable.

python3 fastq_dir_to_samplesheet.py data samplesheet.csv -r1 _1.fastq.gz -r2 _2.fastq.gz #Run the fastq_dir_to_samplesheet.py script, 
# specifying the input directory (data), the output samplesheet file (samplesheet.csv), and the patterns for read 1 
# and read 2 FASTQ files. This will generate a samplesheet that can be used by the viralrecon pipeline 
# to process the sequencing data.

cat samplesheet.csv #Display the contents of the generated samplesheet.csv file to verify that 
#it has been created correctly and contains the expected information about the samples and 
#  their corresponding FASTQ files.

# Run the viralrecon pipeline using Nextflow with the specified parameters. 
# This command will execute the viralrecon workflow,
# using the Docker profile, and it will process the samples defined in the samplesheet.csv file
nextflow run nf-core/viralrecon -r 2.6.0 -profile docker \
--max_memory '8.GB' --max_cpus 2 \
--input samplesheet.csv \
--outdir results/viralrecon \
--protocol amplicon \
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 3 \
--skip_kraken2 \
--skip_assembly \
--skip_pangolin \
--skip_nextclade \
--skip_asciigenome \
--platform illumina \
-resume

# Navigate to the results directory and list its contents to verify that the viralrecon pipeline has completed successfully and that the output files are present.
cd results/viralrecon
ls

# check the multiqc report to see the summary of the results
open multiqc_report.html

du -sh work/* # Check the disk usage of the work directory to see how much space is being used by the intermediate files generated during the viralrecon pipeline execution.
rm -rf work/* # Remove the intermediate files in the work directory to free up disk space after confirming that the results have been successfully generated and are stored 
# in the results/viralrecon directory.