function Classify= myclassify(data,filled)

escolha = app();
if strcmp(escolha,'Hardlim')
    load HardLim.mat;
elseif strcmp(escolha,'Hardlim + AM')
    load HardLimAM.mat;
elseif strcmp(escolha,'Logsig')
    load LogSig.mat;
elseif strcmp(escolha,'Logsig + AM')
    load LogSigAM.mat;
elseif strcmp(escolha,'Hardlim')
    load LogSigAM.mat;
elseif strcmp(escolha,'Purelin')
    load PureLin.mat;
elseif strcmp(escolha,'Purelin + AM')
    load PureLinAM.mat;
end


res=net(data);
[x,y]=max(res);
Classify=int64(y(filled));
end

