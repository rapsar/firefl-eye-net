%% define training set
fdir = {'path/to/flash/folder1','path/to/flash/folder2','path/to/flash/folder3'};
bdir = {'path/to/background/folder1','path/to/background/folder2'};

%% to train a ffnet with RGB patches
ffnet_rgb_241025 = ffnetTrainCNNrgb(fdir,bdir);

%% to train a ffnet with grayscale patches
ffnet_gs_241025 = ffnetTrainCNNgs(fdir,bdir);