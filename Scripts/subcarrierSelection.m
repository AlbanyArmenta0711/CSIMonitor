function[sensitiveSubcarriers,indexes] = subcarrierSelection(csiData, n) 

%El número de subportadoras se determina de acuerdo al número de columnas
%que contenga csiData. 
[~,sNumber] = size(csiData); 

%Se calcula la varianza de cada subportadora
sVar = var(csiData); 
[maxVar,indexes] = maxk(sVar,n);
sensitiveSubcarriers = csiData(:,indexes); 