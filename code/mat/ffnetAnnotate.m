function ffnetAnnotate(fxy)
% annotates videos for firefly flashes
% input: nothing or fxy array
% output: fxy array containing (frame,x,y) coordinates of flashes
% if input is fxy, then starts video at the last annotated frame
%
% loads video (select with UI) and allows to click on flashes
% saves clicks on the go (fxy array updated in console)
% fxy coordinates are converted to patches using fxy2png
%
% starts by picking a fxy name with fxyName
%
% to-do updates:
% -possibility to remove clicks
% -possibility to enter frame number
% -possibility to move to frame corresponding to n>0  time series
%
% RS, 2023

persistent currentFrameNumber
persistent videoReader
persistent fxyArray
persistent fxyName

%fxyName = 'fxy_f1705gp1'
fxyName = 'fxy_f1601gp1'

% Load video file
[videoFile, path] = uigetfile({'*.avi;*.mp4;*.mov'}, 'Select a video file');
videoReader = VideoReader(fullfile(path, videoFile));

% Create a GUI
fig = figure('Name', 'Annotate firefly flashes by clicking on them', ...
    'units', 'normalized', ...
    'outerposition', [0 0 1 1], 'Toolbar', 'none', 'Menubar', 'none');
ax = axes(fig, 'Position', [0.1, 0.25, 0.8, 0.7], 'ButtonDownFcn', @clickAnnotate);

% Add UI controls
slider = uicontrol('Style', 'slider', 'Min', 1, 'Max', videoReader.NumFrames, ...
    'Value', 1, 'Position', [20, 20, 300, 20], 'Callback', @updateFrame);
nextButton = uicontrol('Style', 'pushbutton', 'String', 'Next', ...
    'Position', [350, 20, 100, 20], 'Callback', @nextFrame);
prevButton = uicontrol('Style', 'pushbutton', 'String', 'Previous', ...
    'Position', [450, 20, 100, 20], 'Callback', @prevFrame);

% Initialize storage for annotations
if nargin > 0
    fxyArray = [fxyArray; fxy];
    currentFrameNumber = max(fxyArray(:, 1));
else
    fxyArray = [];
    currentFrameNumber = 1;
end

% Display the first frame
currentFrame = read(videoReader, currentFrameNumber);
imagesc(ax, rgb2gray(currentFrame));
set(ax, 'XTick', [], 'YTick', []);

% Add text above slider to indicate current frame number
uicontrol('Style', 'text', 'String', sprintf('Current Frame: %d', currentFrameNumber), ...
    'Position', [20, 50, 200, 20]);

% UI control callbacks
    function updateFrame(source, ~)
        currentFrameNumber = round(source.Value);
        currentFrame = read(videoReader, currentFrameNumber);
        h = imagesc(ax, rgb2gray(currentFrame));

        set(ax, 'XTick', [], 'YTick', []);
        set(h, 'ButtonDownFcn', @clickAnnotate);


        % Update text above slider with current frame number
        textHandle = findobj(fig, 'Type', 'uicontrol', 'Style', 'text');
        set(textHandle, 'String', sprintf('Current Frame: %d', currentFrameNumber));

        % Redraw markers for the current frame
        if ~isempty(fxyArray)
            currentFrameAnnotations = fxyArray(fxyArray(:, 1) == currentFrameNumber, 2:end);
            for i = 1:size(currentFrameAnnotations, 1)
                pos = currentFrameAnnotations(i,:);
                hold(ax, 'on');
                plot(ax, pos(1), pos(2), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
                hold(ax, 'off');
            end
        end
    end

    function nextFrame(~, ~)
        currentFrameNumber = min(currentFrameNumber + 1, videoReader.NumFrames);
        slider.Value = currentFrameNumber;
        updateFrame(slider);
    end

    function prevFrame(~, ~)
        currentFrameNumber = max(currentFrameNumber - 1, 1);
        slider.Value = currentFrameNumber;
        updateFrame(slider);
    end

% Annotate flash location with a click
    function clickAnnotate(ax, ~)
        ax = gca;
        pos = round(ax.CurrentPoint(1, 1:2));
        fxyArray = [fxyArray; currentFrameNumber, pos];
        hold(ax, 'on');
        plot(ax, pos(1), pos(2), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
        hold(ax, 'off');

        % Update fxyArray in the workspace
        assignin('base', fxyName, fxyArray);
    end

end
