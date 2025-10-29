#!/bin/bash
#$ -wd /net/dunham/vol2/Zilong/updating_pipeline_2024/finding_structural_variants_yeast
#$ -l h_rt=12:00:00
#$ -l mem_free=32G
#$ -o /net/dunham/vol2/Zilong/updating_pipeline_2024/outputs/
#$ -e /net/dunham/vol2/Zilong/updating_pipeline_2024/errors/

module load minimap2/2.26
module load samtools/1.21
module load python/3.12.1
module load sniffles/2.6.3
mkdir -p results

# Give path to your long read as the first argument to the script
READS=$1
REF=genomes/sacCer3.fasta

# strip path and extension from the input filename
BASENAME=$(basename "$READS" .fastq.gz)
OUT=results/${BASENAME}.aligned.sorted.bam

minimap2 -t 1 -ax map-ont $REF "$READS" | \
    samtools view -bS - | \
    samtools sort -m 8G -@ 1 -o "$OUT"

samtools index "$OUT"

# Use Sniffles2 for detecting structural variants
cd results

sniffles -i ${BASENAME}.aligned.sorted.bam -v ${BASENAME}_sniffles.vcf




