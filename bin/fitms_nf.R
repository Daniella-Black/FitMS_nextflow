#!/usr/local/bin/Rscript
library(VariantAnnotation)
library(signature.tools.lib)

args = commandArgs(trailingOnly=TRUE)


sample <- args[1]
mtr_input <- args[2]


#read in the input file to mutationtimer
tab  <- read.table(mtr_input, sep='\t')
#change the format of the input file to that of FitMS
tab<- tab[,c(1,2,4,5)]
names(tab)[names(tab) == "V1"] <- "chr"
names(tab)[names(tab) == "V2"] <- "position"
names(tab)[names(tab) == "V4"] <- "REF"
names(tab)[names(tab) == "V5"] <- "ALT"

#optinal read in and out tab
#tab  <- write.table('C:/Users/Danie/Documents/scanb/MTR/PD31029a/input/PD31029a_caveman_MTR.txt')
#tab  <- read.table('C:/Users/Danie/Documents/scanb/MTR/PD31029a/input/PD31029a_caveman_MTR.txt')

organ = "Breast"
genome.v  ="hg38"
print(head(tab))
res <- tabToSNVcatalogue(tab, genome.v)
df <- data.frame(res$catalogue)
write.csv(df, paste0(sample,'_catalogue.csv'))


res <-FitMS(catalogues = df, 
            organ =organ, 
            exposureFilterType="giniScaledThreshold",
            useBootstrap = TRUE, 
            nboot = 200)

plotSubsSignatures(signature_data_matrix = df,output_file = paste0(sample, "_SNV_catalogues.pdf"))

#plotFitMS(res, paste0(corepath, '/', sample, sep= ""))