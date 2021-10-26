clc; clear;
load('datasetBRTRNPattern.mat');
X = datasetBreathingTRNPattern(:,1:201);
Y = datasetBreathingTRNPattern(:,202);
figure(1)
Ytsne = tsne(X,'Distance','euclidean');
gscatter(Ytsne(:,1),Ytsne(:,2),Y);
title('Clusters with Activity Label(Euclidean)');
xlabel('t-SNE Dimension 1');
ylabel('t-SNE Dimension 2');
figure(2)
Ytsne = tsne(X,'Distance','chebychev');
gscatter(Ytsne(:,1),Ytsne(:,2),Y);
title('Clusters with Activity Label (Chebychev)');
xlabel('t-SNE Dimension 1');
ylabel('t-SNE Dimension 2');
