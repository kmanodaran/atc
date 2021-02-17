#!/bin/bash

# Added safety. If any command fails or a pipe breaks, the script will stop running.
set -eu -o pipefail -o verbose

# Bam file with PCR duplicates removed
bam=$1

# output file prefix
prefix=$(echo $bam | sed 's/.bam//g')

# Path to blacklisted regions
blacklist="/home/kmanodaran/working_data_04/atc/ATAC21012021/ENCFF001TDO.bed"

# Remove blacklist region
samtools view -L "$blacklist" -U "$prefix".filtered.bam -b "$bam" > "$prefix".blacklist.bam

# Call peaks
/home/sbuckberry/miniconda2/bin/macs2 callpeak --nomodel -t "$prefix".filtered.bam -f BAM -n "$prefix" --keep-dup all --gsize hs

# peaks to bed
cut -f 1-3 "$prefix"_peaks.narrowPeak > "$prefix"_peaks.bed

# bed to bigbed
#bedToBigBed "$prefix"_peaks.bed hg19.chromSizes "$prefix"_peaks.bigbed

# file cleanup
rm "$prefix".blacklist.bam
