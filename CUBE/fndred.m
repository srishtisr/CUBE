url = 'http://130.215.216.169:8080/shot.jpg'; 
framesAcquired = 0;
while (framesAcquired <= 50)% the video will work till the 50 video frames, after that the vedio will stop. You can use while(1) for infinite loop
      data = imread(url);
      framesAcquired = framesAcquired + 1;    
      diff_im = imsubtract(data(:,:,1), rgb2gray(data));  % subtracting red component from the gray image
      diff_im = medfilt2(diff_im, [3 3]);% used in image processing to reduce noise and for filtering
      diff_im = im2bw(diff_im,0.18);% convert image to binary image
      stats = regionprops(diff_im, 'BoundingBox', 'Centroid');  % measures a set of properties for each connected component in the binary image
      drawnow;
      imshow(data);
      hold on  
      for object = 1:length(stats)
          bb = stats(object).BoundingBox;
          bc = stats(object).Centroid;
          rectangle('Position',bb,'EdgeColor','b','LineWidth',2)
          plot(bc(1),bc(2), '-m+')       
      end
      hold off  
end