# firefl👁️-net
Flash database and trained neural nets for firefly flash classification.

## Introduction
Reliably identifying firefly flashes in video frames becomes difficult when recording in suboptimal conditions (low contrast). Flashes are featureless blobs of bright pixels, hard to differentiate from other hot spots.

For more details, see [Tracking and Triangulating Firefly Flashes in Field Recordings](https://arxiv.org/abs/2410.19932).

After trying various approaches, I found that trained convolutional neural networks (CNN) are very effective in classifying flashes from other artifacts. Here, I manually labelled firefly flashes from various video sources and provide a database to train neural nets for flash classification.

Because contextual information is important for flash identification, flashes and background are extracted with their local vicinity as uniformly-sized patches (typically 2<sup>n</sup> + 1 pixels wide, with the brightest pixel at the center).

![f-4607rs1203-f0007x0624y1019](https://github.com/user-attachments/assets/3f15c0bd-1134-42f9-87d5-8da27508ef3f)
![f-4607rs1203-f0073x0627y1111](https://github.com/user-attachments/assets/a5592404-1807-4b96-9b98-8a7b5bf9ed1f)
![f-4612rs1289-f0153x0905y0668](https://github.com/user-attachments/assets/778216f1-e765-4f67-9aa1-f678019aa63f)
![b-4625rs1834-f0240x0965y0250](https://github.com/user-attachments/assets/7d180d10-fd73-43e4-a9b4-ead3e3166c3e)
![b-4625rs1834-f0240x1141y0235](https://github.com/user-attachments/assets/ad1c892a-1314-465c-b9c8-7270c3496cc5)
![b-4625rs1834-f0150x0678y0167](https://github.com/user-attachments/assets/13f629a2-6732-4246-8212-4eed461e0c8a)
(3 flashes, 3 backgrounds)

## Structure
- `code`: Scripts for preprocessing, training, and evaluating CNNs (more scripts coming soon).
- `ff-eye`: Labelled patches of flashes (`flsh`) and background (`bkgr`) in `.png` format, compressed into `.zip` files for ease of download.
- `ff-net`: Trained neural networks for flash classification available in multiple formats (Python, JavaScript, MATLAB).

Both folders are divided between data/CNN for GoPro 360 videos (`gp360`) and for smartphone videos (`phone`). 
The `gp360` data is mostly for use in my project on 3D reconstruction of firefly swarms from stereoscopic 360-degree videos. See [`oorb`](https://github.com/rapsar/oorb).

`gp360` patches are 65x65 pixels<sup>2</sup> and `phone` patches are 33x33.

## Usage
Use the labelled patches for training your own models, or incorporate the pretrained ffnets in your video processing pipeline. Let me know how it works out for you!

## App
Under [releases](https://github.com/rapsar/firefl-eye-net/releases), you can find a packaged standalone app (currently in beta, feedback appreciated) to track flashes in your own smartphone movies.

Download the `.app.zip` file, unzip, and double-click to start.  
**Note:** MacOS will block unverified apps unless you manually enable them in **System Settings > Privacy & Security**. Updates and improvements coming soon!

