%% define training set
fdir = {'',''};
bdir = {'',''};

%% to train a ffnet with RGB patches
ffnet_rgb_241025 = ffnetTrainCNNrgb(fdir,bdir);

%% to train a ffnet with grayscale patches
ffnet_gs_241025 = ffnetTrainCNNgs(fdir,bdir);
