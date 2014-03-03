function [aname,mname] = make_scenes(imgSz)

img = ones(imgSz)*0.5;            % Init to black
img(:, round(imgSz(2)/2)) = .99;  % Draw vertical straight line in middle
aname = 'scene_a.png';
imwrite(img,aname);
img(1:round(imgSz(1)/2), :) = circshift(img(1:round(imgSz(1)/2), :),[0 1]);
mname = 'scene_m.png';
imwrite(img,mname);

return