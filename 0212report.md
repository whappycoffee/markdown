## Analysis of Isoform and Alternative Splicing Report

IDP requires both long reads and short reads information to run the prediction, particularly, IDP does not use the output of Iso-Seq as long reads input. For IDP runs the prediction following the pipeline below:

![IDP pipeline](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/IDP-pipeline.png)

This SpliceMap-LSC-IDP system is consist of three different softwares(developed by the same group)
* SpliceMap takes short reads form SGS platform to detect junctions. 
* LSC uses short reads to correct the long reads from Third Generation Seq, and produce error-corrected long reads.

IDP requires FASTA or GPD format for long reads and requires SpliceMap BED or SAM format for short reads
