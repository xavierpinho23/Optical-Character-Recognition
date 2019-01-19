% Conjuntos de funções para a arquitetura: Classificador + AM

function function_AM(option)
    load M_P.mat;          %Treino
    load PerfectArial.mat; %Numeros perfeitos
    load P.mat;            %Teste
    load y_train;          %label treino
    load y_test;           %label teste
    X_train = M_P;
    X_test = P;

    % Matriz de numeros perfeitos (256x500)
    ideal = [Perfect(:,10), Perfect(:,1),Perfect(:,2),Perfect(:,3),Perfect(:,4),Perfect(:,5),Perfect(:,6),Perfect(:,7),Perfect(:,8),Perfect(:,9)];
    T   = [ideal ideal ideal ideal ideal ideal ideal ideal ideal ideal];
    Perfect_numbers = [T T T T T];

    save Perfect_numbers.mat Perfect_numbers
    
    % Associative Memory
    Wp = Perfect_numbers * pinv(X_train);
    outputAM = Wp * X_train;
    X_train = outputAM; %now our training data is the output of the AM 
    
if option==1
    %PURELIN
    
    % Usamos batch learning porque os nossos dados são pequenos e torna-se mais rápido
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
    net.biases{1}.learnFcn='trainscg';
    net.trainFcn='trainscg';
       
    % Data Division
    net.divideFcn  = 'dividerand'; % Divide data randomly
    net.divideMode = 'sample';     % Divide up every sample
    net.performFcn = 'sse';        % criterion
    net.divideParam.trainRatio = 85/100;
    net.divideParam.valRatio = 15/100;
    
    % net parameters
    net.performParam.lr = 0.5;    % learning rate
    net.trainParam.epochs = 1000; % maximum epochs
    net.trainParam.show = 35;     % show
    net.trainParam.goal = 1e-6;   % goal=objective
    
    % Train   
    [net,tr] = train(net,X_train,y_train);

    %Validation
    outputs_purelin_test=sim(net,X_test);
    outputs_purelin_test=FunctionHeur(outputs_purelin_test); %converter para binário

    %Performance
    plotperf(tr)
    
    % ROC Curves
    figure
    plotroc(y_test,outputs_purelin_test);

    % Accuracy
    accuracyTest(outputs_purelin_test,y_test)*100
    
    % Save network
    PureLinAM = net;
    save PureLinAM;
end

if option==2
    %HARDLIM

    net=perceptron('hardlim','learnp');

    % Data Division
    net.divideFcn  = 'dividerand'; % Divide data randomly
    net.divideMode = 'sample';    % Divide up every sample
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
    HardLimAM = net;
    save HardLimAM;

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
    net.trainFcn='trainscg';
    
    % Data Division
    net.divideFcn = 'dividerand'; % Divide data randomly
    net.divideMode = 'sample';    % Divide up every sample
    net.performFcn = 'sse';       % criterion
    net.divideParam.trainRatio = 85/100;
    net.divideParam.valRatio = 15/100;
    
    % net parameters
    net.performParam.lr = 0.5;     % learning rate
    net.trainParam.epochs = 1000;  % maximum epochs
    net.trainParam.show = 35;      % show
    net.trainParam.goal = 1e-6;    % goal=objective
    
    %Train
    [net,tr] = train(net,X_train,y_train);
    
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
    LogSigAM = net;
    save LogSigAM;
end
end