import os
import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, transforms
from torch.utils.data import DataLoader, random_split
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
import numpy as np
import matplotlib.pyplot as plt
import torch.nn.functional as F

def ffnetTrainCNNiphone(fdir):
    """
    Train a CNN to recognize firefly flashes in 33x33 RGB patches using PyTorch.
    Firefly flashes are centered bright blobs (2-6 pixels across) surrounded by dark pixels,
    while background patches can have several bright spots elsewhere.

    Parameters:
        fdir (str): Directory containing image patches (in bkgr and flsh folders).

    Returns:
        model: Trained CNN model.
    """
    # Image parameters
    image_size = 33  # 33x33 RGB patches
    batch_size = 64
    learning_rate = 1e-3
    epochs = 60

    # Define data transformations
    transform = transforms.Compose([
        transforms.Resize((image_size, image_size)),
        transforms.RandomRotation(5),
        transforms.RandomHorizontalFlip(),
        transforms.ColorJitter(brightness=0.2),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5])  # Normalize between [-1, 1]
    ])

    # Load dataset
    dataset = datasets.ImageFolder(root=fdir, transform=transform)
    train_size = int(0.8 * len(dataset))
    val_size = len(dataset) - train_size
    train_dataset, val_dataset = random_split(dataset, [train_size, val_size])

    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
    val_loader = DataLoader(val_dataset, batch_size=batch_size, shuffle=False)

    # Define the CNN model
    class FireflyCNN(nn.Module):
        def __init__(self):
            super(FireflyCNN, self).__init__()
            self.conv1 = nn.Sequential(
                nn.Conv2d(3, 16, kernel_size=3, padding=1),
                nn.BatchNorm2d(16),
                nn.ReLU(),
                nn.MaxPool2d(kernel_size=2, stride=2)
            )
            self.conv2 = nn.Sequential(
                nn.Conv2d(16, 32, kernel_size=3, padding=1),
                nn.BatchNorm2d(32),
                nn.ReLU(),
                nn.MaxPool2d(kernel_size=2, stride=2)
            )
            self.conv3 = nn.Sequential(
                nn.Conv2d(32, 64, kernel_size=3, padding=1),
                nn.BatchNorm2d(64),
                nn.ReLU(),
                nn.MaxPool2d(kernel_size=2, stride=2)
            )
            self.fc1 = nn.Sequential(
                nn.Flatten(),
                nn.Linear(64 * 4 * 4, 128),
                nn.ReLU(),
                nn.Dropout(0.5)
            )
            self.fc2 = nn.Linear(128, 2)  # Binary classification with softmax

        def forward(self, x):
            x = self.conv1(x)
            x = self.conv2(x)
            x = self.conv3(x)
            x = self.fc1(x)
            x = self.fc2(x)
            x = F.softmax(x, dim=1)
            return x

    # Initialize the model, loss, and optimizer
    model = FireflyCNN()
    criterion = nn.NLLLoss() #nn.CrossEntropyLoss()  # For softmax with 2 classes
    optimizer = optim.Adam(model.parameters(), lr=learning_rate)

    # Training loop
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    model.to(device)

    print("Starting Training...")
    for epoch in range(epochs):
        model.train()
        running_loss = 0.0
        for inputs, labels in train_loader:
            inputs, labels = inputs.to(device), labels.to(device)

            # Zero the parameter gradients
            optimizer.zero_grad()
            
            # Forward, backward, optimize
            outputs = model(inputs)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()

            running_loss += loss.item() * inputs.size(0)
        epoch_loss = running_loss / len(train_loader.dataset)

        print(f"Epoch [{epoch+1}/{epochs}], Loss: {epoch_loss:.4f}")

    # Validation loop
    model.eval()
    all_preds = []
    all_labels = []
    with torch.no_grad():
        for inputs, labels in val_loader:
            inputs, labels = inputs.to(device), labels.to(device)
            outputs = model(inputs)
            _, preds = torch.max(outputs, 1)
            all_preds.extend(preds.cpu().numpy())
            all_labels.extend(labels.cpu().numpy())

    # Compute confusion matrix
    cm = confusion_matrix(all_labels, all_preds)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=dataset.classes)
    disp.plot()
    plt.show()

    # Print accuracy
    accuracy = np.sum(np.array(all_preds) == np.array(all_labels)) / len(all_labels)
    print(f"Validation Accuracy: {accuracy * 100:.2f}%")

    return model

if __name__ == "__main__":
    # Define path to dataset
    fdir = "path/to/folder"
    
    # Train the model
    model = ffnetTrainCNNiphone(fdir)
    
    # # Save the trained model
    # torch.save(model.state_dict(), "firefly_cnn_model.pth")
    # print("Model saved as 'firefly_cnn_model.pth'")
    
    model.eval()  # Put model in evaluation mode

    # Save as TorchScript model
    scripted_model = torch.jit.script(model)
    scripted_model.save("ffnet.pth")
    print("Model scripted and saved.")
    

