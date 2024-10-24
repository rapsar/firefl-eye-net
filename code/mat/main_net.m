%% define training set
fdir = {'gp360/ffeye/f-220718AZMSSEcGPM1m02','gp360/ffeye/f-220718AZMSSEcGPM1m03','gp360/ffeye/f-220718AZMSSEcGPM1m05'};
bdir = {'gp360/ffeye/b-220718AZMSSEcGPM1m02','gp360/ffeye/b-220718AZMSSEcGPM1m03'};

%% to train a ffnet with RGB patches
ffnet_rgb_241025 = ffnetTrainCNNrgb(fdir,bdir);

%% to train a ffnet with grayscale patches
ffnet_gs_241025 = ffnetTrainCNNgs(fdir,bdir);