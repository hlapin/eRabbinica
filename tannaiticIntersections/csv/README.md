## About this Data

Data files for a project locating overlapping texts among classical rabbinic sources, with the goal of identifying tannaitic (and tannaitic-like) overlaps.     
Texts are:
* Mishnah (ref-m)
* Tosefta (ref-t)
* Mekhilta (ref-mek)
* Sifra (ref-sifra)
* Sifre-Num (ref-sifre-n)
* Sifre-Deut (ref-sifre-d)
* Talmud Bavli (ref-b)
* Talmud Yerushalmi (ref-y)
* Hebrew Bible (ref-bible)
  
*pairwise raw/* contains the original comparison data provided by Dicta.org (thank you!), based on a series of one-to-many comparisons    
*pairwise/* contains deduplicated data. It also reduces overlapping ranges of matches to a single matched pair.       
*one_to_all/* groups the **pairwise** data around a single work. The column labeled **grp-ref-*** contain keys to group the base text into distinct non-overlapping ranges with matches across other works in the corpus.

**Known problem:** *pairwise/* files include also attempt to merge overlapping text. (These are carried over into *one_to_all/*.) Because of problems in the ***WdStart** and ***WdEnd** calculations in the raw data, merged text can lose one or more words. 
