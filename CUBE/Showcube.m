function frame = Showcube()
%% acquiring image from live feed
% vidobj = imaq.VideoDevice('winvideo', 1, 'MJPG_1280x1024', ... % Select your device accordingly
%                     'ROI', [1 1 640 480], ...
%                     'ReturnedColorSpace', 'grayscale');
% preview(vidobj);
%
%
global check

url = 'http://130.215.120.88:8080/shot.jpg';
ss  = imread(url);
colormap(gray(256));
hVideoIn = vision.VideoPlayer('Name', 'Final Video');
set(gcf,'currentchar',' ')
while (1)
    ss  = imread(url);
    ss=rgb2gray(ss);
    step(hVideoIn,ss)
    %     if (check)
    if (check==1)
        frame=ss;
        break;
    end
end


%i=input('take snapshot? 1/0 : ');
%%Acquire a single frame.
%if(i==1)
% frame = step(hVideoIn);
%end
%%Release the hardware resource.
% release(vidobj);
%%Clear the VideoDevice System object.
% clear vidobj;
end