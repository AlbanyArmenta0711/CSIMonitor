%Script to label in superclass the dataset
%First Label corresponds to breathing rate estimation in superclasses
%based on equal frequency discretization in 5 superclasses

%Second Label corresponds to breathing pattern 
%1 - bradicardia, BPM < 12
%2 - eupnea, BPM normal
%3 - taquipnea, BPM > 20 

%Third Label corresponds superclasses based on the next ranges: 
% 10 BPM or below = 1
% 11 - 13 BPM = 2
% 14 - 16 BPM = 3
% 17 - 19 BPM = 4
% 20 + BPM = 5
clc; clear;
dataset = load('datasetBreathingTRN.csv');
%labelDisc = discretizarEqualFrequency(dataset(:,202),3);

label = dataset(:,202); 

labelPattern = zeros(length(label),1);
for i = 1:length(label)
    if label(i) < 12
        labelPattern(i) = 1; 
    else
        if label(i) > 20
            labelPattern(i) = 3;
        else 
            labelPattern(i) = 2;
        end
    end
end 

labelRange = zeros(length(label),1);
for i = 1:length(label)
    if label(i) < 11
        labelRange(i) = 1; 
    else 
        if label(i) >= 11 && label(i) < 14
            labelRange(i) = 2; 
        else 
            if label(i) >= 14 && label(i) < 17
                labelRange(i) = 3; 
            else
               if label(i) >= 17 && label(i) < 20
                   labelRange(i) = 4; 
               else 
                   labelRange(i) = 5; 
               end
            end
        end
    end
end
