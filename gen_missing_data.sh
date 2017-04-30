#!/bin/bash
##imputation_sim
SN=$1
n_case=0
n_control=1000
REGION_FL="~/missing_gp/region/"$SN".txt"   	##Region file location
hap_ref="/home/xc/ngs/hap_ref/"
out_dir="~/missing_gp"
mkdir -p $out_dir"/"$SN
count=0
while read line;do
        a[$count]=${line##*:}
        count=$(( $count + 1 ))
done < $REGION_FL

causl_l=${a[2]}" 1 1.1 1.2"
let LOW_BOUND=${a[0]}
let UP_BOUND=${a[1]}

hapgen2 -m $hap_ref/chr22_combined_b37.txt -l $hap_ref/chr22_EUR.legend -h $hap_ref/chr22_EUR.hap -o $out_dir/$SN/h -dl $causl_l -n $n_case $n_control -int $LOW_BOUND $UP_BOUND >$out_dir/$SN/debug.txt

gtool -G --g h.controls.gen --s h.controls.sample --ped h.ped --map h.map --threshold 0.9
plink --file h --recode vcf
~/missing_gp/mask.py plink.vcf
shapeit -T 2 --main 20 -V plink_missing.txt -M genetic_map_chr22_combined_b37.txt -O plink_phased.out
shapeit -convert --input-haps plink_phased.out --output-vcf plink_phased.vcf
sed -i "s/^0/22/g" plink_phased.vcf
head -n6 plink_phased.vcf > plink_phased_tmp.vcf
sed -i "1,6d" plink_phased.vcf
awk -v OFS='\t' '$3=$1":"$2' plink_phased.vcf >> plink_phased_tmp.vcf
mv plink_phased_tmp.vcf plink_phased.vcf
rm -f shapeit_*
