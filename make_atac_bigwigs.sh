
bam=$1
prefix=$(echo "$bam" | sed 's/.bam//g')
cores=$2

bamCoverage -p "$cores" --normalizeUsing CPM --binSize 1 -b "$1" -o "$prefix"_cpm.bigwig