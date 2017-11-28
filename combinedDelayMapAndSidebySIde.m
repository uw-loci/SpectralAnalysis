
%%
%This code bins the decay matrix as 3x3(given bin=2)
% Ask the user to choose a SDT file

%calculates the delay of peak in each pixel and creates another...
%matrix with the delay value(maxMatris). The value of maxMatrix is..
%supposed to show us the spectral distribution

%output is color labelled image of each spectral component
%BioFormat should be added to path
%%
close all
clear all

bin=2;
M=256;
N=256;
P=256;
A=zeros(M,N,P);
noOfBin=256;

% 1, prompts the user for new data
% 0, run based on last data, this is faster
% Construct a questdlg with three options

choice = questdlg('Would you like to load new data?', ...
	'choice','Yes, new data','use saved data','default');
% Handle response
switch choice
    case 'Yes, new data'
        generateData = 1;
    case 'use saved data'
        generateData = 0;
    case 'default'
        return;
end




if(generateData==1)
    cellData=bfopen %Requires bioformat path to be added
    data3D=cellData{1,1}(:,1);%taking the 3d array with decay
    
    for k = 1:noOfBin
        A(k,:,:) = data3D{k};
    end
    save A
else
    load A

end

[M, N, P]=size(A);
%matrix size 2*bin+1 x 2*bin+1

margin=bin+1; %from where data collection will actually start
im=zeros(N-margin*2,P-margin*2); 
decayIM=zeros(N-margin*2,P-margin*2,noOfBin);
maxMatrix=double(zeros(N-margin*2,P-margin*2)); %matrix with delay of decay in every pixel


for i=margin:N-margin
    for j=margin:P-margin
%         g=... 
%         A(:,i-1,j-1)+A(:,i,j-1)+A(:,i+1,j)+...
%         A(:,i,j)+A(:,i-1,j)+A(:,i+1,j)+...
%         A(:,i-1,j+1)+A(:,i,j+1)+A(:,i+1,j+1);
    
        
        g=A(:,i-bin:i+bin,j-bin:j+bin);
        g=sum(sum(g,2),3);

        pixVal=squeeze(g);
        [ maxVal loc]=max(g);%finding the location of the peak
        maxMatrix(i-bin,j-bin)=double(loc)*12.5/noOfBin;
        im(i-bin,j-bin)=sum(pixVal);
        decayIM(i-bin,j-bin,:)=g;
    end
    
;
end

% imshow(im/max(max(im)))
% figure, imshow(maxMatrix/max(max(maxMatrix)))
% figure, imshow(uint8(maxMatrix*256/12.5))

%  maxMatrix(maxMatrix>4.5)=0;
% 
% indexedImage = gray2ind(maxMatrix, 10);
figure, imshow(flip(maxMatrix))% flips to match spcimage
% figure, imshow(indexedImage)
colormap(jet(100))
caxis('auto')
colorbar

% figure, hist(maxMatrix,10)

range=linspace(min(min(maxMatrix)),max(max(maxMatrix)),20);
gg=histc(maxMatrix(:),range);
figure,semilogy(range,gg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%plot side-by-side and peak difference%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except A
num_images=256;

%Draw ROI and create mask
s=squeeze(sum(A,1));
maxS=max(max(s));
i=1;
count =2;
while(count>0)

    figure,h_im=imshow(uint8(s/maxS*255));%shows the image with intensity 
    e = imfreehand;%prompts to ask ROI
    
    BW = createMask(e,h_im);
    imshow(BW)%shows the ROI mask
    
    for k = 1:num_images
        
        B(k,:,:)= squeeze(A(k,:,:)).*double(BW);
    end
    
    %sum over x,y pixel and calculate the delay
    timebins=sum(sum(B,2),3);
    [m delay]=max(timebins);
    delayarray(i)=delay;
    delayinTime=delay*12.5/256
%     riseTime=maxmin(timebins);
    timebinsPlotter(i,:)=timebins;
    i=i+1;
%     figure, semilogy((1:num_images)',timebins,'b')
    count=count-1;
end

x_time=1:256;
x_time=x_time/256*12.5;

plot(x_time,timebinsPlotter(1,:)/max(timebinsPlotter(1,:)),'g');
hold on
plot(x_time,timebinsPlotter(2,:)/max(timebinsPlotter(2,:)),'y');
title('30m 800um core fiber');

difference_in_peak=(delayarray(1)-delayarray(2))*12.5/256

