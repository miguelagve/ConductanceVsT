function [curvas] = openBlq()
[FileName, FilePath] = uigetfile('*.blq','Cargar blq');

curvas = ReducedblqreaderV6([FilePath, FileName]);

for i=1:length(curvas)
    if ~rem(i,2)
        curvas(i).data = flipud(curvas(i).data);
    end
end
end