clc; clear; close all;
original = imread('man.jpg');
figure;
imshow(original);
scale = 1.3;
J = imresize(original,scale);
theta = 31;
distorted = imrotate(J,theta);
figure
imshow(distorted)
ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
[featuresOriginal,validPtsOriginal]  = extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = extractFeatures(distorted,ptsDistorted);
indexPairs = matchFeatures(featuresOriginal,featuresDistorted);
matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));
figure
showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted)
title('Candidate matched points (including outliers)')
[tform, inlierDistorted,inlierOriginal] = estimateGeometricTransform(matchedDistorted,matchedOriginal,'similarity');
figure
showMatchedFeatures(original,distorted,inlierOriginal,inlierDistorted)
title('Matching points (inliers only)')
legend('ptsOriginal','ptsDistorted')
outputView = imref2d(size(original));
recovered  = imwarp(distorted,tform,'OutputView',outputView);
figure
imshowpair(original,recovered,'montage')
% original = imread('man.jpg');
% figure;
% imshow(original);
% text(size(original,2),size(original,1)+15, ...
%     'Image courtesy of Massachusetts Institute of Technology', ...
%     'FontSize',7,'HorizontalAlignment','right');
% scale = 1.3;
% J = imresize(original, scale);
% 
% theta = 31;
% distorted = imrotate(J,theta);
% figure
% imshow(distorted)
% ptsOriginalBRISK  = detectBRISKFeatures(original, 'MinContrast', 0.01);
% ptsDistortedBRISK = detectBRISKFeatures(distorted, 'MinContrast', 0.01);
% 
% ptsOriginalSURF  = detectSURFFeatures(original);
% ptsDistortedSURF = detectSURFFeatures(distorted);
% [featuresOriginalFREAK,  validPtsOriginalBRISK]  = extractFeatures(original,  ptsOriginalBRISK);
% [featuresDistortedFREAK, validPtsDistortedBRISK] = extractFeatures(distorted, ptsDistortedBRISK);
% 
% [featuresOriginalSURF,  validPtsOriginalSURF]  = extractFeatures(original,  ptsOriginalSURF);
% [featuresDistortedSURF, validPtsDistortedSURF] = extractFeatures(distorted, ptsDistortedSURF);
% 
% indexPairsBRISK = matchFeatures(featuresOriginalFREAK, featuresDistortedFREAK, 'MatchThreshold', 40, 'MaxRatio', 0.8);
% 
% indexPairsSURF = matchFeatures(featuresOriginalSURF, featuresDistortedSURF);
% 
% matchedOriginalBRISK  = validPtsOriginalBRISK(indexPairsBRISK(:,1));
% matchedDistortedBRISK = validPtsDistortedBRISK(indexPairsBRISK(:,2));
% 
% matchedOriginalSURF  = validPtsOriginalSURF(indexPairsSURF(:,1));
% matchedDistortedSURF = validPtsDistortedSURF(indexPairsSURF(:,2));
% 
% figure
% showMatchedFeatures(original, distorted, matchedOriginalBRISK, matchedDistortedBRISK)
% title('Putative matches using BRISK & FREAK')
% legend('ptsOriginalBRISK','ptsDistortedBRISK')
% 
% matchedOriginalXY  = [matchedOriginalSURF.Location; matchedOriginalBRISK.Location];
% matchedDistortedXY = [matchedDistortedSURF.Location; matchedDistortedBRISK.Location];
% 
% [tformTotal,inlierDistortedXY,inlierOriginalXY] = estimateGeometricTransform(matchedDistortedXY,matchedOriginalXY,'similarity');
% 
% figure
% showMatchedFeatures(original,distorted,inlierOriginalXY,inlierDistortedXY)
% title('Matching points using SURF and BRISK (inliers only)')
% legend('ptsOriginal','ptsDistorted')
% 
% outputView = imref2d(size(original));
% recovered  = imwarp(distorted,tformTotal,'OutputView',outputView);
% 
% figure;
% imshowpair(original,recovered,'montage')