close all
%The image is read
Ik = imread('G:\Geospatial HW-1\Test_Images\393408659.jpg');
figure;
imshow(Ik);
title("Real Image");

%The image is resized
I=imresize(Ik,.25);

% Gaussian filter is used on the image to remove Noise
g_output = imgaussfilt(I,2);
figure;
imshow(g_output);
title("Gaussian");

%Converting the RGB image to gray image 
gray_output = rgb2gray(g_output);

%Thresholding the image
T = adaptthresh(gray_output);

%The Image is inverse binarized.
bin_output1 = ~imbinarize(gray_output,T);
figure;
imshow(bin_output1);
title("Binary");

%Detecting the edges of the image using canny edge detection method
canny_edge_output = edge(bin_output1,'canny');


% The Areas of the Smeared regions are found using the regionprops method
% and using area statistics.
cc = bwconncomp(canny_edge_output); 
stats = regionprops(cc, 'Area','Eccentricity'); 
idx = find([stats.Area] > 40 & [stats.Area] < 80 & [stats.Eccentricity] < 0.8);
BW2 = ismember(labelmatrix(cc), idx);  
figure;
imshow(BW2)
title('Area Detection');
stats = regionprops('table',BW2,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
title('Shape');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;
hold on
viscircles(centers,radii);
hold off

%The canny edged output and based on the smear area the smear is plotted
cent=cat(1, stats.Centroid)
figure;
imshow(canny_edge_output)
title("Smear detected");
hold on
plot(cent(:,1), cent(:,2), 'b*')
hold off
figure;
imshow(canny_edge_output);
title("edge")

%Contour of the image is found
figure;
imcontour(canny_edge_output);
title("Contour");

% The Final image with the found Smears is highlighted 
figure;
C = imfuse(I,BW2,'blend','Scaling','joint');
imshow(C);
title("Final Image");
stats = regionprops('table',BW2,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;
hold on;
viscircles(centers,radii);
hold off;