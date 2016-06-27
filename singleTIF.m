tic
clc

clear all
close all

% fname = '730 33.tif';
 fname = 'mix321_980nm_no_filter_PC_232_20x_zoom5_withoutND_30m_fiber.tif';
% fname = 'mix321_980nm_no_filter_PC_68_20x_zoom5_withoutND_10m_fiber.tif';

info = imfinfo(fname);
num_images = numel(info);
for k = 1:num_images
    A(k,:,:) = imread(fname, k, 'Info', info);
end

toc

tic
clc
clf


timebins=sum(sum(A,2),3);

semilogy((1:num_images)',timebins,'b') 
[a maxBins]=max(timebins);
maxBins
time=maxBins/256*12.5



figure(2)
hold on
plot((1:num_images)',timebins,'b')  
%threshold
timebins (timebins<0.01*max(timebins))=0;
COM=sum((1:num_images)'.*timebins)/sum(timebins);

%FWHM
FWHM_find=find(abs(.5*max(timebins)-timebins)<30000);
FWHM_diff=diff(FWHM_find);
FWHM_max_diff=find(FWHM_diff==max(FWHM_diff));
FWHM=FWHM_find(FWHM_max_diff+1)-FWHM_find(FWHM_max_diff)

%peak
peak=find(timebins==max(timebins));

%mark peak
plot([peak,peak],[0,max(timebins)],'Color','r','LineWidth',1)
%mark COM
plot([COM,COM],[0,max(timebins)],'Color','g','LineWidth',1)
%mark FWHM
plot([FWHM_find(FWHM_max_diff+1),FWHM_find(FWHM_max_diff)],[.5*max(timebins),.5*max(timebins)],'Color','k','LineWidth',1)
