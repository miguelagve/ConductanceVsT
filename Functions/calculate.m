function [MatrizConductancia,MatrizDOS,Matriz2Deriv] ...
    = calculate(Voltage,MatrizCorriente,Temperature,PuntosDerivada,NormInf,NormSup,flag)

% NCurv = length(dir([FilePath, '/*.blq']));
% curvas = ReducedblqreaderV6([FilePath, '/1.blq']);
% 
% Voltage = curvas(ForthBack).data(:,1);
% MatrizCorriente = zeros(length(curvas(ForthBack).data),NCurv);
% % MatrizCorriente(:,1) = curvas(ForthBack).data(:,2);
% for i=1:NCurv
%     FileName = ['/' int2str(i) '.blq'];
%     curvas = ReducedblqreaderV6([FilePath, FileName]);
%     MatrizCorriente(:,i) = curvas(ForthBack).data(:,2);
% end
A = size(MatrizCorriente);
NCurv = A(2);
MatrizConductancia = zeros(size(MatrizCorriente));
% MatrizNormalizada = zeros(size(MatrizCorriente));
for i=1:NCurv
    MatrizConductancia(:,i)=derivadorLeastSquaresCurva(PuntosDerivada,...
        MatrizCorriente(:,i),Voltage(:,i));
    if flag
    MatrizConductancia(:,i) = normalizacionPA(NormSup,NormInf,...
        Voltage(:,i),MatrizConductancia(:,i),2048,2048);
    end
end
% MatrizNormalizada = normalizacionPA(NormSup,NormInf,Voltage,MatrizConductancia,2048,2048);

Matriz2Deriv = zeros(size(MatrizCorriente));
for i=1:NCurv
    Matriz2Deriv(:,i)=derivadorLeastSquaresCurva(PuntosDerivada,...
        MatrizConductancia(:,i),Voltage(:,i));
end 

kB      = 8.617e-2;
VmV = Voltage*1000;%Voltaje en mV
TK = Temperature;%Temperatura en K
MatrizDOS = zeros(size(MatrizCorriente));

for j=1:NCurv
    if TK(j) == 0
        MatrizDOS(:,j) = MatrizConductancia(:,j);
    else
        Beta = 1/(kB*TK(j));
        %dFermiDist	= (Beta*exp(Beta*VmV(:,j)))./((1+exp(VmV(:,j)*Beta)).^2); % Analítica
        %dFermiDist	= -diff(FermiDist); % Numérica
        %New expression for the analytic form
        dFermiDist = Beta./(4*(cosh(Beta*VmV(:,j)/2)).^2);
        MatrizDOS(:,j) = deconvlucy(MatrizConductancia(:,j),dFermiDist);

% figure
% plot(Voltage(:,j),dFermiDist)

%     assignin('base','dFermiDist',dFermiDist)
%     assignin('base','VmV',VmV)
%     assignin('base','MatrizConductancia',MatrizConductancia)
%     assignin('base','Temperature',Temperature)


        if flag
        MatrizDOS(:,j) = normalizacionPA(NormSup,NormInf,Voltage(:,j),MatrizDOS(:,j),2048,2048);
        end
    end
end

end
