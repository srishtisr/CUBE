clc; clear; close all;

%Need 8 arrays related to 8 cubes

%Name the 24 templates

for i=1:24
    face(i).label=char(64+i) %Labeling 24 faces
end

myFolder = 'C:\Users\ssrivastava\My Documents\MATLAB\CUBE\Templates'; %Folder where images are stored
if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end
filePattern = fullfile(myFolder, '*.jpg'); %Find all files with extension .jpg
jpegFiles = dir(filePattern);
x=1;
for k = 1:length(jpegFiles)
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    Q = imread(fullFileName);
    
    face(x).image=Q(1:size(Q,1)/2,1:size(Q,2)/2,:); %Check numbering of faces
    face(x+1).image=Q(size(Q,1)/2+1:size(Q,1),1:size(Q,2)/2,:);
    face(x+2).image=Q(size(Q,1)/2+1:size(Q,1),size(Q,2)/2+1:size(Q,2),:);
    face(x+3).image=Q(1:size(Q,1)/2,size(Q,2)/2+1:size(Q,2),:);
    
    x=x+4;
end


cube(1).arr=['U','D','G','R','R','J'];
cube(2).arr=['V','L','T','Q','B','M'];
cube(3).arr=['X','F','V','M','O','A'];
cube(4).arr=['W','E','S','N','H','L'];
cube(5).arr=['X','J','B','T','I','O'];
cube(6).arr=['W','I','A','S','U','N'];
cube(7).arr=['P','C','C','H','F','P'];
cube(8).arr=['K','Q','D','G','K','E'];

set(0,'DefaultFigureWindowStyle','docked'); %Will dock all images. Put in startup.m to set as default
% set(0,'DefaultFigureWindowStyle','normal') %to switch back to undocked mode

for i=1:8
    figure(i);
    for x=1:6
        for j=1:24
            if (cube(i).arr(x)==face(j).label);
                subplot(2,3,x);
                imshow(face(j).image);
                drawnow;
            end
        end
    end
end

% tilefigs; %function to tile all figure windows. NOT for docked windows


%% PFM

boxImage=face(7).image;
figure;
imshow(boxImage);
boxImage=rgb2gray(boxImage);
title('Guitar template');
boxPoints = detectHarrisFeatures(boxImage);
figure;
imshow(boxImage);
title('500 Strongest Feature Points from Box Image');
hold on;
plot(selectStrongest(boxPoints, 500));
% plot(boxPoints, 'showPixelList', true, 'showEllipses', false);
im=imread('clutteredDesk.jpg');
figure;
imshow(im);
im=rgb2gray(im);
scenePoints = detectHarrisFeatures(im);
title('1000 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 1000));
% plot(scenePoints, 'showPixelList', true, 'showEllipses', false);

[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(im, scenePoints);

boxPairs = matchFeatures(boxFeatures, sceneFeatures);

matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
figure;
showMatchedFeatures(boxImage, im, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');

[tform, inlierBoxPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');

figure;
showMatchedFeatures(boxImage, im, inlierBoxPoints, ...
    inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');

boxPolygon = [1, 1;...                           % top-left
        size(boxImage, 2), 1;...                 % top-right
        size(boxImage, 2), size(boxImage, 1);... % bottom-right
        1, size(boxImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon

newBoxPolygon = transformPointsForward(tform, boxPolygon);

figure;
imshow(im);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected Box');

elephantImage = face(15).image;
elephantImage=rgb2gray(elephantImage);
figure;
imshow(elephantImage);
title('Image of an Elephant');


elephantPoints = detectHarrisFeatures(elephantImage);
figure;
imshow(elephantImage);
hold on;
plot(selectStrongest(elephantPoints, 500));
% plot(elephantPoints, 'showPixelList', true, 'showEllipses', false);
title('500 Strongest Feature Points from Elephant Image');

[elephantFeatures, elephantPoints] = extractFeatures(elephantImage, elephantPoints);

elephantPairs = matchFeatures(elephantFeatures, sceneFeatures, 'MaxRatio', 0.9);

matchedElephantPoints = elephantPoints(elephantPairs(:, 1), :);
matchedScenePoints = scenePoints(elephantPairs(:, 2), :);
figure;
showMatchedFeatures(elephantImage, im, matchedElephantPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');
%Fine till here

[tform, inlierElephantPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedElephantPoints, matchedScenePoints, 'affine'); %%Problem Area. Considers everything as outliers
figure;


%%If very few inliers, rotate image and check again
%%repeat until enough inliers found?

showMatchedFeatures(elephantImage, im, inlierElephantPoints, ...
    inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');

elephantPolygon = [1, 1;...                                 % top-left
        size(elephantImage, 2), 1;...                       % top-right
        size(elephantImage, 2), size(elephantImage, 1);...  % bottom-right
        1, size(elephantImage, 1);...                       % bottom-left
        1,1];                         % top-left again to close the polygon

newElephantPolygon = transformPointsForward(tform, elephantPolygon);

figure;
imshow(im);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
line(newElephantPolygon(:, 1), newElephantPolygon(:, 2), 'Color', 'g');
title('Detected Elephant and Box');

