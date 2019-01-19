% Conjuntos de funções para a arquitetura: Classificador

function function_WAM(option)
    load M_P.mat;       %Treino
    load P.mat;         %Teste
    load y_train.mat;   %label treino
    load y_test.mat;    %label test
    X_train = M_P;
    X_test = P;
    
if option==1
    %PURELIN
 
    % Usamos batch learning pq os nossos dados são pequenos e torna-se mais rápido
    net=network;
    net.numInputs=1;
    net.inputs{1}.size=256;
    net.numLayers=1;
    net.layers{1}.size=10;
    net.inputConnect(1)=1;
    net.biasConnect(1)=1;
    net.outputConnect(1)=1;
    net.layers{1}.transferFcn='purelin';
    net.inputWeights{1}.learnFcn='trainscg'; %Scaled conjugate gradient backpropagation
    net.trainFcn = 'trainscg'; 
    net.biases{1}.learnFcn='trainscg';
    
    % Data Division
    net.divideFcn  = 'dividerand'; % Divide data randomly
    net.divideMode = 'sample';     % Divide up every sample
    net.performFcn = 'msereg';     % criterion
    net.divideParam.trainRatio = 85/100;
    net.divideParam.valRatio   = 15/100;
    
    % net parameters
    net.performParam.lr = 0.5;    % learning rate
    net.trainParam.epochs = 1000; % maximum epochs
    net.trainParam.show = 35;     % show
    net.trainParam.goal = 1e-6;   % goal=objective
    
    % Train   
    [net,tr] = train(net,X_train,y_train);

    %Validation
    outputs_purelin_test = sim(net,X_test);
    outputs_purelin_test = FunctionHeur(outputs_purelin_test); %converter para binário

    %Performance
    plotperf(tr)
    
    % ROC Curves
    figure
    plotroc(y_test,outputs_purelin_test);

    % Accuracy
    accuracyTest(outputs_purelin_test,y_test)*100
    
    % Save network
    PureLin = net;
    save PureLin;
end

if option==2
    %HARDLIM
    
    net = perceptron('hardlim','learnp'); %perceptron = feed-forward pattern recognition networks

    % Data Division
    net.divideFcn  = 'dividerand';  % Divide data randomly
    net.divideMode = 'sample';      % Divide up every sample
    net.performFcn = 'sse';         % criterion
    net.divideParam.trainRatio = 85/100;
    net.divideParam.valRatio = 15/100;
    
    % net parameters
    net.performParam.lr=0.5;    % learning rate
    net.trainParam.epochs=1000; % maximum epochs
    net.trainParam.show=35;     % show
    net.trainParam.goal=1e-6;   % goal=objective
            
    %Train
    [net,tr]=train(net,X_train,y_train);

    %Validation
    outputs_hardlim_test = sim(net,X_test);
    outputs_hardlim_test = FunctionHeur(outputs_hardlim_test);
    
    %Performance
    plotperf(tr)
    
    %ROC Curves
    figure
    plotroc(y_test,outputs_hardlim_test)
    
    %Accuracy
    accuracyTest(outputs_hardlim_test,y_test)*100

    % Save network
    HardLim = net;
    save HardLim;

end
if option==3
    % LOGSIG

    net=network;
    net.numInputs=1;
    net.inputs{1}.size=256;
    net.numLayers=1;
    net.layers{1}.size=10;
    net.inputConnect(1)=1;
    net.biasConnect(1)=1;
    net.outputConnect(1)=1;
    net.layers{1}.transferFcn='logsig';
    net.inputWeights{1}.learnFcn='trainscg';
    net.biases{1}.learnFcn='trainscg';
    net.trainFcn = 'trainscg';
    
    % Data Division
    net.divideFcn  = 'dividerand';  % Divide data randomly
    net.divideMode = 'sample';      % Divide up every sample
    net.performFcn = 'sse';         % criterion
    net.divideParam.trainRatio = 85/100;
    net.divideParam.valRatio = 15/100;
    
    % net parameters
    net.performParam.lr = 0.5;    % learning rate
    net.trainParam.epochs = 1000; % maximum epochs
    net.trainParam.show = 35;     % show
    net.trainParam.goal = 1e-6;   % goal=objective
    
    %Train
    [net,tr]=train(net,X_train,y_train);
    
    %Validation
    outputs_logsig_test = sim(net,X_test);
    outputs_logsig_test = FunctionHeur(outputs_logsig_test); %converter para binário

    %Performance
    plotperf(tr)
    
    %ROC Curves
    figure
    plotroc(y_test,outputs_logsig_test)

    %Accuracy
    accuracyTest(outputs_logsig_test,y_test)*100

    %Save network
    LogSig=net;
    save LogSig;
end
end