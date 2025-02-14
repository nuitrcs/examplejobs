#!/bin/bash

#SBATCH --account=b1042
#SBATCH --partition=genomics
#SBATCH --job-name=minimap2_olava
#SBATCH --output=minimap2_olava.out
#SBATCH --error=minimap2_olava.err
#SBATCH --time=30:00:00
#SBATCH --mem=100G       ### edit this line to reserve more/less memory
#SBATCH --ntasks=8      ### edit this line to reserve different no. of cores
#SBATCH --nodes=1

module purge all
module load minimap2/2.24

# files
f1=/projects/b1042/Carter/PacBioRaw/lavandulifolia/m64190e_210918_124621.hifi_reads.fasta.gz
f2=/projects/b1042/Carter/PacBioRaw/lavandulifolia/m64190e_211003_030651.hifi_reads.fasta.gz
f3=/projects/b1042/Carter/PacBioRaw/lavandulifolia/m64190e_211020_054525.hifi_reads.fasta.gz

minimap2 -ax map-hifi -t 8 olava.canuassem1.mmi $f1 > m64190e_210918_124621.aln1.sam
minimap2 -ax map-hifi -t 8 olava.canuassem1.mmi $f2 > m64190e_211003_030651.aln1.sam
minimap2 -ax map-hifi -t 8 olava.canuassem1.mmi $f3 > m64190e_211020_054525.aln1.sam
