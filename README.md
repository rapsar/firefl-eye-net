# firefl👁️-net
Flash database and trained neural nets for firefly flash classification.

## Introduction
Reliably identifying firefly flashes in video frames becomes difficult when recording in suboptimal conditions (low contrast). Flashes are featureless blobs of bright pixels, hard to differentiate from other hot spots.

For more details, see [Tracking and Triangulating Firefly Flashes in Field Recordings](https://arxiv.org/abs/2410.19932).

After trying various approaches, I found that trained convolutional neural networks (CNN) are very effective in classifying flashes from other artifacts. Here, I manually labelled firefly flashes from various video sources and provide a database to train neural nets for flash classification.

Because contextual information is important for flash identification, flashes and background are extracted with their local vicinity as uniformly-sized patches (typically 2<sup>n</sup> + 1 pixels wide, with the brightest pixel at the center).

## Structure
- `code`: Scripts for preprocessing, training, and evaluating CNNs (more scripts coming soon).
- `ff-eye`: Labelled patches of flashes (`flsh`) and background (`bkgr`) in `.png` format, compressed into `.zip` files for ease of download.
- `ff-net`: Trained neural networks for flash classification available in multiple formats (Python, JavaScript, MATLAB).

Both folders are divided between data/CNN for GoPro 360 videos (`gp360`) and for smartphone videos (`phone`). 
The `gp360` data is mostly for use in my project on 3D reconstruction of firefly swarms from stereoscopic 360-degree videos. See [`oorb`](https://github.com/rapsar/oorb).

## Usage
Use the labelled patches for training your own models, or incorporate the pretrained ffnets in your video processing pipeline. Let me know how it works out for you!

## App
Under [releases](https://github.com/rapsar/firefl-eye-net/releases), you can find a packaged standalone app (currently in beta, feedback appreciated) to track flashes in your own smartphone movies.

Download the `.app.zip` file, unzip, and double-click to start.  
**Note:** MacOS will block unverified apps unless you manually enable them in **System Settings > Privacy & Security**. Updates and improvements coming soon!

