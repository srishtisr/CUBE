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

% newlabel=[];
% for a=1:3
%     
%     if a == 1
%         webim=imread('1.jpg');
%     elseif a == 2
%         webim=imread('9.jpg');
%     elseif a == 3
%         webim=imread('23.jpg');
%     end
%     
%     status=1;
%     for i = 1:4:24
%         boxImage=face(i).image;
%         figure;
%         imshow(boxImage);
%         if (ndims(boxImage)>2)
%             boxImage=rgb2gray(boxImage);
%         end
%         title('Guitar template');
%         boxPoints = detectHarrisFeatures(boxImage);
%         figure;
%         imshow(boxImage);
%         title('1000 Strongest Feature Points from Box Image');
%         hold on;
%         plot(selectStrongest(boxPoints, 1000));
%         % plot(boxPoints, 'showPixelList', true, 'showEllipses', false);
%         % im=imread('clutteredDesk.jpg');
%         im=webim;
%         figure;
%         imshow(im);
%         if (ndims(im)>2)
%             im=rgb2gray(im);
%         end
%         
%         scenePoints = detectHarrisFeatures(im);
%         title('1000 Strongest Feature Points from Scene Image');
%         hold on;
%         plot(selectStrongest(scenePoints, 1000));
%         % plot(scenePoints, 'showPixelList', true, 'showEllipses', false);
%         
%         [boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
%         [sceneFeatures, scenePoints] = extractFeatures(im, scenePoints);
%         
%         boxPairs = matchFeatures(boxFeatures, sceneFeatures);
%         
%         matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
%         matchedScenePoints = scenePoints(boxPairs(:, 2), :);
%         figure;
%         showMatchedFeatures(boxImage, im, matchedBoxPoints, ...
%             matchedScenePoints, 'montage');
%         title('Putatively Matched Points (Including Outliers)');
%         
%         
%         %while(status= IGNORE THIS
%         
%         
%         [tform, inlierBoxPoints, inlierScenePoints, status] = ...
%             estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine'); %Make this function return the status
%         
%         
%         display(status);
%         
%         
%         if (status == 0)
%             newlabel=[newlabel face(i).label];
%             break;
%         end
%     end
%     if (status == 0)
%         fprintf('MATCHED in LOOP 1\n');
%     end
% end
% % newlabel;
% 
% %% Tell position of cubes to user
% 
% for g=1:8
%     
%     c=0;
%     for h=1:6
%         if newlabel(1)==cube(g).arr(h)
%             c=c+1;
%         end
%         if newlabel(2)==cube(g).arr(h)
%             c=c+1;
%         end
%         if newlabel(3)==cube(g).arr(h)
%             c=c+1;
%         end
%         if c==3
%             fprintf('\nCube %d Found\n', g);
%             break;
%         end
%     end
% end
% 
% 




%% Select top left cube bu matching to 6 top faces - AEIMQU
% Use Harris to check rotation. 6 faces x 4 possible rotations = 24 max matches

webim=imread('1.jpg');
 webim=imrotate(webim,90);
status=1;
for i = 1:4:24
    boxImage=face(i).image;
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
    % plot(boxPoints, 'showPixelList', true, 'showEllipses', false);
    % im=imread('clutteredDesk.jpg');
    im=webim;
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
    
    
    %while(status= IGNORE THIS
    
    
    [tform, inlierBoxPoints, inlierScenePoints, status] = ...
        estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine'); %Make this function return the status
    
    
    display(status);
    
    
    if (status == 0)
        for j = 1:4
            display(i);
            
            original = face(i).image;
            original=rgb2gray(original);
            imshow(original);
            text(size(original,2),size(original,1)+15, ...
                'Image courtesy of Massachusetts Institute of Technology', ...
                'FontSize',7,'HorizontalAlignment','right');
            
            scale = 0.7;
            J = imresize(original, scale); % Try varying the scale factor.
            
            %             theta = 30;
            distorted = webim; % Try varying the angle, theta.
            distorted=rgb2gray(distorted);
            figure, imshow(distorted)
            
            ptsOriginal  = detectSURFFeatures(original);
            ptsDistorted = detectSURFFeatures(distorted);
            
            [featuresOriginal,  validPtsOriginal]  = extractFeatures(original,  ptsOriginal);
            [featuresDistorted, validPtsDistorted] = extractFeatures(distorted, ptsDistorted);
            
            indexPairs = matchFeatures(featuresOriginal, featuresDistorted);
            
            matchedOriginal  = validPtsOriginal(indexPairs(:,1));
            matchedDistorted = validPtsDistorted(indexPairs(:,2));
            
            figure;
            showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted);
            title('Putatively matched points (including outliers)');
            
            [tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
                matchedDistorted, matchedOriginal, 'similarity');
            
            figure;
            showMatchedFeatures(original,distorted,inlierOriginal,inlierDistorted);
            title('Matching points (inliers only)');
            legend('ptsOriginal','ptsDistorted');
            
            Tinv  = tform.invert.T;
            
            ss = Tinv(2,1);
            sc = Tinv(1,1);
            scaleRecovered = sqrt(ss*ss + sc*sc)
            thetaRecovered = atan2(ss,sc)*180/pi
            
            
        end
    end
    if (status == 0)
        fprintf('MATCHED in LOOP 1\n');
        break;
    end
    fprintf('\n NO MATCH!! ROTATE THIS CUBE \n');
end



