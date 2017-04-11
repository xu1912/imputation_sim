# imputation_sim
gtool -G --g h.controls.gen --s h.controls.sample --ped h.ped --map h.map --threshold 0.9
plink --file h --recode vcf
./mask.py plink.vcf
shapeit -T 2 --main 20 -V plink_missing.txt -M genetic_map_chr22_combined_b37.txt -O plink_phased.out
shapeit -convert --input-haps plink_phased.out --output-vcf plink_phased.vcf
rm -f shapeit_*
