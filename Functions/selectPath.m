function [Voltage,MatrizCorriente,Temperature,MagneticField,FilePath] = selectPath(ForthBack,startPath)
FilePath = uigetdir(startPath);
A = load([FilePath filesep 'Temperature.mat']);
B = load([FilePath filesep 'MagneticField.mat']);
Temperature = A.Temperature;
MagneticField = B.MagneticField;

NCurv = length(dir([FilePath, filesep, '*.blq']));
curvas = ReducedblqreaderV6([FilePath, filesep, '1.blq']);
% Voltage = curvas(ForthBack).data(1);
Voltage = zeros(length(curvas(ForthBack).data),NCurv);
MatrizCorriente = zeros(length(curvas(ForthBack).data),NCurv);

for i=1:NCurv
    FileName = [filesep int2str(i) '.blq'];
    curvas = ReducedblqreaderV6([FilePath, FileName]);
    Voltage(:,i) = curvas(ForthBack).data(:,1);
    MatrizCorriente(:,i) = curvas(ForthBack).data(:,2);
end
end