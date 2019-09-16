library(reticulate)
library(Seurat)

#################### 1. I load these objects

SEUmac<-readRDS(file="/home/rstudio/data/SEUobj_afterCCcorrFULL-AGG20RAWsubgOver3-afterUMAPtree.rds")

SEUobj_afterCCcorrFULL-AGG20RAWsubgOver3-afterUMAPtree.rds


#################### 2. Plot things like

GeneSetName<-"DC_SeeSCI_2vseDC"
Genes<-c("CD207","CD86","CD1D","ID2","FCGRA2","BATF3","IRAK3","CD1C","CD52","HLA-DQB1","IL13RA1","S100A8","CD1E","S100A9","TREM1","FAM26F","RAB20","FCGBP","OLFM1","VISG4")
GenesIN<-Genes[Genes %in% rownames(SEUdcNoScan@assays$RNA@data)]
NumbRows<-ceiling(length(GenesIN)/4)

png(file=paste0("/lustre/scratch117/cellgen/team170/ca6/cellrangerEBdiff/Aggregate/Results/AGG19DC/FindMarkers/Rplot_UMAP_sample_byGene-",GeneSetName,"noSCANdata.png"),
    width=if(length(GenesIN)<4){500*length(GenesIN)} else {2000},height=400*NumbRows)
FeaturePlot(object = SEUdcNoScan, features = GenesIN, cols = c("ghostwhite", "darkred"),  reduction= "umap",pt.size = 0.01,ncol=4)
dev.off()




##################### 3. Run functions like (it produces a plot too)

pdf(file="/lustre/scratch117/cellgen/team170/ca6/cellrangerEBdiff/Aggregate/Results/AGG20MacExLa/Rplot_sampleTree.pdf",width=14)
SEUmac<-BuildClusterTree(SEUmac)
dev.off()





##################### 4. Also this

AddModuleScore(SEUdcNoScan,GenesIN,ctrl=5,name=GeneSetName)
png(file=paste0("/lustre/scratch117/cellgen/team170/ca6/cellrangerEBdiff/Aggregate/Results/AGG19DC/FindMarkers/Rplot_UMAP_sample_Signature-",GeneSetName,"_noSCANdata.png"),
    width=500,height=400)
FeaturePlot(object = SEUdcNoScan, features = GeneSetName, cols = c("ghostwhite", "darkviolet"),  reduction= "umap",pt.size = 0.01)
dev.off()




##################### 5. Or do differential expression using 

DC_57vsrestFinal<-FindMarkers(SEUdcNoScan,ident.1="57",ident.2=c("13","26","52","40","48","30","43","60"),min.pct = 0.1,logfc.threshold = 0.25)
write.table(DC_57vs13_26,file="/lustre/scratch117/cellgen/team170/ca6/cellrangerEBdiff/Aggregate/Results/AGG19DC/FindMarkers/DCnscan_sample.txt",quote=F,sep="\t",col.names=NA)

##QUESTION: this function can be paralellized with library(future) as in the two lines below ran before the function, 
library(future)
plan("multiprocess", workers = 4)
#will this be possible? I never managed to do so in the interactive sessions in the farm 




###################### 6. This I may need less often, but just in case

SelPC<-29
SEUmac<- RunUMAP(object = SEUmac, dims = 1:SelPC)




##################### 7. And finally I save back some of the objects

saveRDS(SEUmac,file="/lustre/scratch117/cellgen/team170/ca6/cellrangerEBdiff/Aggregate/Results/AGG20MacExLa/SEUobj_sample.rds")
