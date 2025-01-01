# firefl-👀-net
Training set and trained CNN for firefly flash classification in video recordings.

## Introduction
Porperly identifying firefly flashes in video frames is difficult when recording in suboptimal conditions (light artifacts).
Details in my [arxiv preprint](https://arxiv.org/abs/2410.19932).
I have found trained convolutional neural networks (CNN) to be very good at differentiating flashes from artifacts. 
I manually labelled firefly flashes (and common artifacts) from various video sources, and provide the training data here to trained neural nets for flash classification.

## Structure
- ff-eye contains labelled patches of flashes (flsh) and background (bkgr). The .png flashes are present in corresponding .zip files.
- ff-net contains trained neural nets in various formats (python, javascript, matlab).
  
Both folders are split between data/CNN for GoPro 360 videos ('gp360') and for smartphone videos ('phone').

## Usage
Use the labelled patches for training your own models, or used the pretrained neural nets.

## App
Under [releases](https://github.com/rapsar/firefl-eye-net/releases), you can find a packaged standalone app (currently in beta, feedback appreciated) to analyze your own smartphone movies of fireflies. Download the .app.zip file, unzip, and double click to start. NB: MacOS will not allow to use the (unverified) App unless specifically enabled in Settings. Updates coming soon.

