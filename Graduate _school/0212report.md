## Analysis of Isoform and Alternative Splicing Report

IDP requires both long reads and short reads information to run the prediction, particularly, **IDP does not use the output of Iso-Seq as long reads input**.IDP runs the prediction following the pipeline below:

![IDP pipeline](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/IDP-pipeline.png)

This SpliceMap-LSC-IDP system is consist of three different softwares(developed by the same group):
* SpliceMap takes short reads form SGS platform to detect junctions.
* LSC uses short reads to correct the long reads from PacBio platform. The output is the error-corrected long reads. This LSC module also requires both long reads and short reads.
* IDP uses the junction detections and the alignment of error-corrected ling reads to detect the relatively short short isoforms at full-length and predict the very long isoforms by statistical modeling.
* All of the three modules prefer FASTA files, bam files can not be identified.(samtools or EMBOSS can convert bam files into FASTA format.)

LSC can use the Iso-seq output as long reads and the file produced by LSC is preferred by IDP.However it also requires short reads to correct the long reads. For there might be some informative junctions in the long reads region, we could lose that data if the long reads were not corrected by short reads.
**As a conclusion**, IDP can not be used when short reads are not available.

## Poisson model and MLE solution

F_g
