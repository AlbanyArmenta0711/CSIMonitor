function[sensitiveSubcarriers,indexes] = subcarrierSelection(csiData, n) 

%El n�mero de subportadoras se determina de acuerdo al n�mero de columnas
%que contenga csiData. 
[~,sNumber] = size(csiData); 

%Se calcula la varianza de cada subportadora
sVar = var(csiData); 
[maxVar,indexes] = maxk(sVar,n);
sensitiveSubcarriers = csiData(:,indexes); 