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

%% Sam's code


%% Tell position of cubes to user



%% Select top left cube bu matching to 6 top faces - AEIMQU
% Use Harris to check rotation. 6 faces x 4 possible rotations = 24 max matches

webim=imread('21.jpg');
webim=imrotate(webim,180);
status=1;
for i = 1:4:24
    boxImage=face(i).image;
    figure;
    imshow(boxImage);
    if (ndims(boxImage)>2)
        boxImage=rgb2gray(boxImage);
    end
    title('Guitar template');
    boxPoints = detectSURFFeatures(boxImage);
    figure;
    imshow(boxImage);
    title('500 Strongest Feature Points from Box Image');
    hold on;
    plot(selectStrongest(boxPoints, 500));
    
    im=webim;
    figure;
    imshow(im);
    im=rgb2gray(im);
    scenePoints = detectSURFFeatures(im);
    title('1000 Strongest Feature Points from Scene Image');
    hold on;
    plot(selectStrongest(scenePoints, 1000));
    
    [boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
    [sceneFeatures, scenePoints] = extractFeatures(im, scenePoints);
    
    boxPairs = matchFeatures(boxFeatures, sceneFeatures);
    
    matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
    matchedScenePoints = scenePoints(boxPairs(:, 2), :);
    figure;
    showMatchedFeatures(boxImage, im, matchedBoxPoints, ...
        matchedScenePoints, 'montage');
    title('Putatively Matched Points (Including Outliers)');
    
    
    
    
    
    [tform, inlierBoxPoints, inlierScenePoints, status] = ...
        estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine'); %Make this function return the status
    
    
    display(status);
    
    
    if (status == 0)
        for j = 1:4
            
            boxImage=face(i).image; %template
            figure;
            imshow(boxImage);
            if (ndims(boxImage)>2)
                boxImage=rgb2gray(boxImage);
            end
            title('Guitar template');
            boxPoints = detectHarrisFeatures(boxImage);
            figure;
            imshow(boxImage);
            title('500 Strongest Feature Points from Box Image');
            hold on;
            plot(selectStrongest(boxPoints, 500));
            
            im=webim; %getsnapshot on buttonpress or.. showcube function
            figure;
            imshow(im);
            im=rgb2gray(im);
            scenePoints = detectHarrisFeatures(im);
            title('1000 Strongest Feature Points from Scene Image');
            hold on;
            plot(selectStrongest(scenePoints, 1000));
            
            
            [boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
            [sceneFeatures, scenePoints] = extractFeatures(im, scenePoints);
            
            boxPairs = matchFeatures(boxFeatures, sceneFeatures);
            
            matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
            matchedScenePoints = scenePoints(boxPairs(:, 2), :);
            figure;
            showMatchedFeatures(boxImage, im, matchedBoxPoints, ...
                matchedScenePoints, 'montage');
            title('Putatively Matched Points (Including Outliers)');
            
            
            
            [tform, inlierBoxPoints, inlierScenePoints, status] = ...
                estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine'); %Make this function return the status
            
            
            display(status);
            
            if (status == 0)
                topleft=face(i).label;
                ii=i;
                fprintf('MATCHED in LOOP 2, face %s\n', face(i).label);
                break;
            end
            
            
            
            fprintf('\nNO MATCH!! ROTATE THIS IMAGE 90 degrees \n');
        end
    end
    if (status == 0)
        fprintf('MATCHED in LOOP 1\n');
        break;
    end
    fprintf('\n NO MATCH!! ROTATE THIS CUBE \n');
end



