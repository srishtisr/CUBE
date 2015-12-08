url = 'http://130.215.120.88:8080/shot.jpg';
ss  = imread(url);
 colormap(gray(256));
hVideoIn = vision.VideoPlayer('Name', 'Final Video');


while(1)
    ss  = imread(url);
    ss=rgb2gray(ss);
    step(hVideoIn,ss)
end

