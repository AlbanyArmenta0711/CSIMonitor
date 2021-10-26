clc; clear;
load('datasetActivityFeatured.csv');
X = datasetActivityFeatured(:,1:80);
Y = datasetActivityFeatured(:,81);

cvp = cvpartition(Y,'KFold',5); 
%FOR KNN
%neighbors = 11;
%neighbors = 1:2:15;
%distanceMetric = "euclidean";
%distanceMetric = ["euclidean","chebychev"];

%FOR SVM
solver = "SMO";
%solver = ["ISDA","L1QP","SMO"];
%kernel = ["gaussian","linear","polynomial"];
kernel = "linear";

%order = 3; 

%FOR QDC
%model = fitcdiscr(X,Y,'DiscrimType','quadratic','CVPartition',cvp);

%kernelSVM = templateSVM('KernelFunction','polynomial','PolynomialOrder',neighbors(i),'Standardize',true);
%model = fitcecoc(X,Y,'Learners',kernelSVM,'CVPartition',cvp);
for i = 1:length(kernel)
    for j = 1:length(solver)
        %model = fitcknn(X,Y,'NumNeighbors',neighbors(i),'Distance',distanceMetric(j),'Standardize',true,'CVPartition',cvp); 
        if kernel(i) ~= "polynomial" 
            kernelSVM = templateSVM('KernelFunction',kernel(i),'Solver',solver(j),'Standardize',true,'CacheSize','maximal');
        else 
            kernelSVM = templateSVM('KernelFunction',kernel(i),'PolynomialOrder',2,'Solver',solver(j),'Standardize',true,'CacheSize','maximal');
        end
        model = fitcecoc(X,Y,'Learners',kernelSVM,'CVPartition',cvp);
        %prediction = kfoldPredict(model); 
        %C=confusionmat(prediction,Y);
        FoldPredictions = zeros(model.KFold,3,3);
        %PERFORMANCE PER CLASS
        accuracy = zeros(model.KFold,3); 
        recall = zeros(model.KFold,3); 
        specificity  = zeros(model.KFold,3); 
        precision  = zeros(model.KFold,3); 
        fscore  = zeros(model.KFold,3);
        %MEAN OVERALL ACCURACY
        overallAccuracy = 0; 
        fprintf("********* SVM Classifier *********\n");
        fprintf("Kernel:");
        disp(kernel(i));
        fprintf("Solver:");
        disp(solver(j));
        fprintf("\n");
        for counter = 1:model.KFold
            index = test(cvp,counter);
            [predictFolds,score] = predict(model.Trained{counter},X(index,:));
            stats = confusionmatStats(Y(index),predictFolds); 
            accuracy(counter,:) = stats.accuracy;
            recall(counter,:) = stats.recall;
            specificity(counter,:) = stats.specificity; 
            precision(counter,:) = stats.precision;
            fscore(counter,:) = stats.Fscore;
            FoldPredictions(counter,:,:) = stats.confusionMat; 
            ovacc = sum(diag(stats.confusionMat))/length(predictFolds);
            overallAccuracy = ovacc + overallAccuracy; 
        end 
        overallAccuracy = overallAccuracy/10; 
        meanC1 = mean(FoldPredictions(:,1,1));
        C1Error = std(FoldPredictions(:,1,1))/sqrt(10);
        meanC2 = mean(FoldPredictions(:,2,2));
        C2Error = std(FoldPredictions(:,2,2))/sqrt(10);
        meanC3 = mean(FoldPredictions(:,3,3));
        C3Error = std(FoldPredictions(:,3,3))/sqrt(10);
%         meanC4 = mean(FoldPredictions(:,4,4));
%         C4Error = std(FoldPredictions(:,4,4))/sqrt(10);
%         meanC5 = mean(FoldPredictions(:,5,5));
%         C5Error = std(FoldPredictions(:,5,5))/sqrt(10);
        %fprintf("Overall accuracy: %f\n",overallAccuracy); 
        fprintf("Overall accuracy: %f\n",mean(mean(accuracy)));
        fprintf("Accuracy per class:"); 
        disp(mean(accuracy));
        fprintf("\n");
        fprintf("Recall per class:");
        disp(mean(recall)); 
        fprintf("\n"); 
        fprintf("Precision per class:");
        disp(mean(precision)); 
        fprintf("\n");
        fprintf("Specificity per class:");
        disp(mean(specificity));
        fprintf("\n");
        fprintf("FScore per class:");
        disp(mean(fscore));
        fprintf("\n");
        
    end
    
    
end 
