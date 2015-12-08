boxImage1 = imread('Mosaic.jpg');

Q= rgb2gray (boxImage1);

Q1=Q(1:size(Q,1)/2,1:size(Q,2)/2,:);

Q2=Q(size(Q,1)/2+1:size(Q,1),1:size(Q,2)/2,:);

Q3=Q(1:size(Q,1)/2,size(Q,2)/2+1:size(Q,2),:);

Q4=Q(size(Q,1)/2+1:size(Q,1),size(Q,2)/2+1:size(Q,2),:);

figure(2);

subplot(2,2,1);

imshow(Q1);

subplot(2,2,3);

imshow(Q2);

subplot(2,2,2);

imshow(Q3);

subplot(2,2,4);

imshow(Q4);