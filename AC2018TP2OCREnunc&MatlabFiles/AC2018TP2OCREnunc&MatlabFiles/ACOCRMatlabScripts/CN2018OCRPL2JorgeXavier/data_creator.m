% Criação dos Targets de treino(10x500) e teste(10x50)
y_train = repmat(eye(10),[1 50]);
y_test  = repmat(eye(10),[1 5]);

save y_train.mat y_train;
save y_test.mat y_test;

%criação da matriz perfeita

load PerfectArial.mat;
