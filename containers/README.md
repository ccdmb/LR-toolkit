# Containers built

This folder contains the Dockerfiles to build containers to run the pipeline.

To build the images you will need [Docker](https://docs.docker.com/install/), [Make](https://www.gnu.org/software/make/), and optionally [Singularity](https://sylabs.io/guides/latest/user-guide/) installed.
You will also need root permission for your computer.

The following commands should work for Linux, Mac, and Linux emulators/VMs (e.g. WSL or Cygwin). 

```
# To build the monolithic docker image
sudo make docker/ont-tools

# To build a the singularity image.
sudo make singularity/ont-tools.sif

# To tidy the docker image registry and singularity cache.
# Note that this may also remove docker images created by other methods.
sudo make tidy

# To remove all docker images and singularity images from your computer.
# Will remove EVERYTHING, aka. the "help i've run out of root disk space" command.
sudo make clean
```

Singularity images are placed in a `singularity` subdirectory with the extension `.sif`.

Note that singularity images are built from docker images, so you may want to clean up the `docker images`.
Note also that singularity leaves some potentially large tar files in tmp folders that wont be removed automatically.
On my computers (ubuntu/fedora) these are put in `/var/tmp/docker-*`.
It's worth deleting them.

## List of tools
The following tools are used for the following applications:

| Tool            | Description             | Workflow                           |
|-----------------|-------------------------|------------------------------------|
| fastqc,multiqc  | reads QC                | READS_QC                           |
| ayss-fac        | reads stats             | READS_QC                           |
| pycoQC          | ONT reads QC            |                                    |
| minimap2        | reads mapping           | CHLO_CONTAMINATION, GENOME_MAPPING |
| samtools        | manage alignement files | CHLO_CONTAMINATION, GENOME_MAPPING |
| seqkit          | filter reads            | READS_FILTER                       |
| subreads        | count reads in features | GENOME_MAPPING                     |
| isoquant        | identify isoforms       | GET_ISOFORMS                       |

