#!/bin/bash

# Added safety. If any command fails or a pipe breaks, the script will stop running.
set -eu -o pipefail -o verbose

# Bam file with PCR duplicates removed
bam=$1

# output file prefix
prefix=$(echo $bam | sed 's/.bam//g')

# Path to blacklisted regions
blacklist="/home/sbuckberry/working_data_01/genomes/Homo_sapiens/UCSC/hg19/Annotation/ENCFF000KJP.bed"

# Remove blacklist regions
samtools view -L "$blacklist" -U "$prefix".filtered.bam -b "$bam" > "$prefix".blacklist.bam

# Call peaks
macs2 callpeak --nomodel -t "$prefix".filtered.bam -f BAM -n "$prefix" --keep-dup all --gsize hs

# peaks to bed
cut -f 1-3 "$prefix"_peaks.narrowPeak > "$prefix"_peaks.bed

# bed to bigbed
#bedToBigBed "$prefix"_peaks.bed hg19.chromSizes "$prefix"_peaks.bigbed

# file cleanup
rm "$prefix".blacklist.bam
