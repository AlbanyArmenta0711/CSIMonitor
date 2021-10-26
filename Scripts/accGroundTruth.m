clc; clear;

csi_amps = load('./Datasets/s5/Breathing/AccData21BPM.csv');
magnitudes=csi_amps(:,2);
%magnitudes = sqrt(csi_amps(:,1).^2+csi_amps(:,2).^2+csi_amps(:,3).^2);
fs = 25; %Sample Frequency
t = 40; %sample window sizeBREstimation
[numData,~] = size(magnitudes);
dur = ceil(numData/fs)-t; 
lastF = NaN; 
lfSize = 3; %number of means to consider for each estimation
lfIndex = 1; 
atributesIndex = 1; 
BREstimation = zeros(dur,1); %Breathing Rate Estimation
%Designing bandpass filter
filterOrder = 8; 
filter = designfilt('bandpassiir','FilterOrder',filterOrder, ...
    'HalfPowerFrequency1',0.1,'HalfPowerFrequency2',0.4,  ...
    'SampleRate',fs);
[b,a] = sos2tf(filter.Coefficients);
for i=1:fs:numData - (numData - (dur*fs))
    upperBound = i+t*fs-1;
    if upperBound > numData
        upperBound = numData; 
    end
    csiWindow = magnitudes(i:upperBound,:);
    
    %Data Calibration
    [rows,cols] = size(csiWindow);
    %Hampel identifier 
    r = round(rows/5);
    if r > 0
        [csiHampel,hampelIndex] = hampel(csiWindow,round(rows/5),2); 
        maf = csiHampel;
        for j = 1:cols %Savitzky-Golay Filter to each sc
            if round(rows/10) > 0 
                maf(:,j) = sgolayfilt(csiHampel(:,j),3,51);                
            end
        end 
        if i == 1 
            dataCalibrated = filtfilt(b,a,maf);
        else 
            dataCalibrated = filtfilt(b,a,maf);
        end
        %Power Spectrum
        n = 2^nextpow2(rows);
        X = fft(dataCalibrated,n);
        X = X./max(X);
        X = fftshift(X);
        psd = abs(X);
        kk = 0:n-1;
        F = kk/n*fs-fs/2;
        [~,index] = find(F==0);
        F = F(index:n);
        psd = psd(index:n,:);
        [maxAmplitudes,indexMaxFrequencies] = max(psd);
        frequency = F(indexMaxFrequencies); 
        err = zeros(length(frequency),1);  
        if isnan(lastF) %if first estimation...
            lastF = frequency(1); %Max frequency in power spectrum
            nearestF = lastF;   
            lastEstimations(1) = lastF; 
            lfIndex = lfIndex + 1; 
        else
            if lfIndex < lfSize
                lastEstimations(lfIndex) = (sum(lastEstimations) + frequency(1))/(numel(lastEstimations)+1); 
                nearestF = lastEstimations(lfIndex);
                lfIndex = lfIndex + 1; 
            else                           
                lfIndex = 1; 
                lastEstimations(lfIndex) = (sum(lastEstimations) + frequency(1))/lfSize;
                nearestF = lastEstimations(lfIndex);
            end
        end 
        %First Estimation
        BREstimation(atributesIndex) = round(60*nearestF);
        atributesIndex = atributesIndex + 1; 
    end 
end