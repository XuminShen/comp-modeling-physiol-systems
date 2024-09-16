%Dataset upload and scGEA Toolbox installation
[X,genelist,barcodelist] = sc_readmtxfile('matrix.mtx','features.tsv','barcodes.tsv',1);
Metadata_Table = readtable('metadata.csv');

%% Q1-2
X = sc_norm(X,'type','deseq');

%% Q1-3
percellcount = sum(X, 1);
barcode = [1:length(percellcount)];
total_num = sort(percellcount,'descend');
loglog(total_num,barcode)
xlabel('Cell');
ylabel('genetic UMI count');
title('Log10 Counts by Log10 Barcode Rank');
%% Q1-4 violin plot
violinplot(total_num,Metadata_Table.('sample'),'ShowData',true,'Width',0.5)
%% Q2-1
[genelistnew,Xhvg]=sc_hvg(X,genelist);
sc_plotcells(Xhvg(1:2000,:),genelistnew(1:2000,1));
title('UMAP of 2000 over-dispersed genes with default setting');

%% Q2-2
a=table2array(genelistnew(1:2000,1))
sc_plotcells(Xhvg(1:2000,:),a,"None",2,false,true,0.1,15);
title('UMAP of 2000 over-dispersed genes with mindist=0.1');
sc_plotcells(Xhvg(1:2000,:),a,'none',2,false,true,0.5,15);
title('UMAP of 2000 over-dispersed genes with mindist=0.3');
sc_plotcells(Xhvg(1:2000,:),a,'none',2,false,true,0.79,15);
title('UMAP of 2000 over-dispersed genes with mindist=0.79');

sc_plotcells(Xhvg(1:2000,:),a,"None",2,false,true,0.4,5);
title('UMAP of 2000 over-dispersed genes with number of neighbors=5');
sc_plotcells(Xhvg(1:2000,:),a,'none',2,false,true,0.4,20);
title('UMAP of 2000 over-dispersed genes with number of neighbors=20');
sc_plotcells(Xhvg(1:2000,:),a,'none',2,false,true,0.4,100);
title('UMAP of 2000 over-dispersed genes with number of neighbors=100');

%% Q2-3 i
sc_plotcells(X,genelist,"ITGAM");
sc_plotcells(X,genelist,"CD5");
sc_plotcells(X,genelist,"MOG");

%% Q2-3 ii
sc_violinplot(X,genelist,Metadata_Table.('cell_assignment'),"MOG")

%% Q3-1
idx = Metadata_Table.("cell_assignment")=="Malignant";
Maligant_Table = Metadata_Table(idx,:);
Maligant_X = X(:,idx);

adultidx = Maligant_Table.("GBM_type")=="Adult";
pediatricidx = Maligant_Table.("GBM_type")=="Pediatric";
T = sc_deg(Maligant_X(:,adultidx),Maligant_X(:,pediatricidx),genelist);

T=T(T.p_val<0.001,:);
T=T(T.avg_log2FC~=NaN,:);
T=T(T.avg_log2FC~=inf,:);
T=T(T.avg_log2FC~=-inf,:);

%% Q3-2

X_umap = sc_umap(X);

gscatter(X_umap(:,1),X_umap(:,2), Metadata_Table.cell_assignment);

sc_plotcells(Maligant_X,genelist,"ATXN3L");
sc_plotcells(Maligant_X,genelist,"C6orf15");
sc_plotcells(Maligant_X,genelist,"MAGEA3");
sc_plotcells(Maligant_X,genelist,"MAGEA12");
X_umap2 = sc_umap(Maligant_X)
gscatter(X_umap2(:,1),X_umap2(:,2), Maligant_Table.sample);
gscatter(X_umap2(:,1),X_umap2(:,2), Maligant_Table.GBM_type);
ID_1 = Maligant_Table.sample==string('BT830');
ID_2 = Maligant_Table.sample==string('MGH152');
ID_1_2 = boolean(ID_1+ID_2);

gscatter(X_umap2(ID_1_2,1),X_umap2(ID_1_2,2), Maligant_Table.sample(ID_1_2));
for i = 1:28
    subplot(5,6,i)
    ID_i = Maligant_Table.sample==string(sample_list(i));
    gscatter(X_umap2(ID_i,1),X_umap2(ID_i,2), Maligant_Table.sample(ID_i));
end

gscatter(X_umap(ID_1_2,1),X_umap(ID_1_2,2), Maligant_Table.sample(ID_1_2));
for i = 1:28
    subplot(5,6,i)
    ID_i = Maligant_Table.sample==string(sample_list(i));
    gscatter(X_umap(ID_i,1),X_umap(ID_i,2), Maligant_Table.sample(ID_i));
end