# imputation_sim
gtool -G --g h.controls.gen --s h.controls.sample --ped h.ped --map h.map --threshold 0.9
plink --file h --recode vcf
./mask.py plink.vcf
shapeit -T 2 --main 20 -V plink_missing.txt -M genetic_map_chr22_combined_b37.txt -O plink_phased.out
shapeit -convert --input-haps plink_phased.out --output-vcf plink_phased.vcf
sed -i "s/^0/22/g" plink_phased.vcf
head -n6 plink_phased.vcf > plink_phased_tmp.vcf
sed -i "1,6d" plink_phased.vcf
awk -v OFS='\t' '$3=$1":"$2' plink_phased.vcf >> plink_phased_tmp.vcf
mv plink_phased_tmp.vcf plink_phased.vcf
rm -f shapeit_*
