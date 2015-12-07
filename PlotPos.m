clf
figure(1)
for g = 0:2
for i = 0:2

   plot3([g g], [0 2], [i, i], 'Color',[0 0 0])
   hold on
end
end

for g = 0:2
for i = 0:2

   plot3([0 2], [g g], [i, i], 'Color',[0 0 0])
   hold on
end
end

for g = 0:2
for i = 0:2

   plot3([i i], [g g], [0 2], 'Color',[0 0 0])
   hold on
end
end
xlabel('x-axis');
  ylabel('y-axis');
  zlabel('z-axis');
  grid on
  axis off
  
%   img = imread('peppers.png');     %# Load a sample image
% xImage = [-0.5 0.5; -0.5 0.5];   %# The x data for the image corners
% yImage = [0 0; 0 0];             %# The y data for the image corners
% zImage = [0.5 0.5; -0.5 -0.5];   %# The z data for the image corners
% surf(xImage,yImage,zImage,...    %# Plot the surface
%      'CData',img,...
%      'FaceColor','texturemap');


