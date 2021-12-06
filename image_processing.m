i = imread('scene.png') %This will assign the image to i
imshow(i) %displayimage
figure;
%image filtering
Red = i(:,:,1);
Green = i(:,:,2);
Blue = i(:,:,3);
temp = i;
imhist(Red)
figure;
temp = i;
temp(:,:,1) = temp(:,:,1) + 100;
imshow(temp)
figure;
%close();
imhist(Green)
figure;
temp = i;
temp(:,:,2) = temp(:,:,2) + 100;
imshow(temp)
figure;
imhist(Blue)
figure;
temp = i;
temp(:,:,3) = temp(:,:,3) + 100;
imshow(temp)

%Image deblurring
PSF = fspecial('motion',50,10);
Idouble = im2double(i);
blurred = imfilter(Idouble,PSF,'conv','circular');
imshow(blurred)
figure;
wnr1 = deconvwnr(blurred,PSF);
imshow(wnr1)
figure;
%Finding an area in an image of a specific color
% Thresholding is assigning pixels to certain classes based on intensity.
%example :finding the area of a water body in a satellite Map.
i2 = rgb2gray(i); % make a grayscale image of i
imshow(i2)
figure;
imhist(i2)
figure;
imshowpair(i,BW,'montage')
stats = regionprops('table',BW,'all');

