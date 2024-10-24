function ffnet = ffnetTrainCNNrgb(fdir,bdir)
%FFNETTRAIN Train a ffnet based on training sets 
% convolutional neural network for RGB patches
% combine folders of flash/background patches (fdir/bdir)

%% Prepare training set
% Load flash patches
flsh = imageDatastore(fdir,'FileExtensions','.png');
flsh.Labels = categorical(ones(length(flsh.Files),1));

% Load background patches
bkgr = imageDatastore(bdir,'FileExtensions','.png');
bkgr.Labels = categorical(zeros(length(bkgr.Files),1));

% combine and split
db = imageDatastore(cat(1,flsh.Files,bkgr.Files));
db.Labels = cat(1,flsh.Labels,bkgr.Labels);
[traindb,validdb,testdb] = splitEachLabel(db,0.7,0.15,'randomized');


%% Define network
layers = [
    imageInputLayer([65 65 3]) % Assuming 65x65 rgb patches

    convolution2dLayer(2, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    dropoutLayer(0.2)

    maxPooling2dLayer(2, 'Stride', 2)

    convolution2dLayer(2, 64, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    dropoutLayer(0.2)

    maxPooling2dLayer(2, 'Stride', 2)

    convolution2dLayer(2, 128, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    dropoutLayer(0.2)

    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];


%% Define training options
options = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.01, ...
    'MaxEpochs', 30, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', validdb, ...
    'ValidationFrequency', 30, ...
    'Verbose', true, ...
    'Plots', 'training-progress');

%% Train network
ffnet = trainNetwork(traindb, layers, options);

%% Test trained network
predictedLabels = classify(ffnet, testdb);
accuracy = sum(predictedLabels == testdb.Labels) / numel(testdb.Labels);
disp(['Test accuracy: ', num2str(accuracy)]);


end



