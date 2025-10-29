#!/bin/bash
#$ -wd /net/dunham/vol2/Zilong/updating_pipeline_2024/finding_structural_variants_yeast
#$ -l h_rt=12:00:00
#$ -l mem_free=8G
#$ -o /net/dunham/vol2/Zilong/updating_pipeline_2024/outputs/
#$ -e /net/dunham/vol2/Zilong/updating_pipeline_2024/errors/

module load modules modules-init modules-gs
module load bedtools/2.31.1

# Just give sample names, and the script will search the results folder for the corresponding vcf.
EVOLVED=$1
ANC=$2

cd results

# Check to see if both the Evolved and Ancestor vcfs have been created
if [[ -f "${EVOLVED}_sniffles.vcf" && -f "${ANC}_sniffles.vcf" ]]; then
    (>&2 echo Both ${EVOLVED}_sniffles.vcf and ${ANC}_sniffles.vcf found.)
else
    (>&2 echo Error: missing one or both VCF files in $(pwd):)
    if [[ ! -f "${EVOLVED}_sniffles.vcf" ]]; then
        (>&2 echo Missing: ${EVOLVED}_sniffles.vcf)
    fi
    if [[ ! -f "${ANC}_sniffles.vcf" ]]; then
        (>&2 echo Missing: ${ANC}_sniffles.vcf)
    fi
    exit 1  # else terminate the script if files are missing
fi

(>&2 echo ***Bedtools - Intersect***)
bedtools intersect -v -header \
    -a ${EVOLVED}_sniffles.vcf \
    -b ${ANC}_sniffles.vcf \
    > ${EVOLVED}_sniffles_AncFiltered.vcf

