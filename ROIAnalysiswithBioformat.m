
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

M=256;
N=256;
P=256;
A=zeros(M,N,P);
noOfBin=256;


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

bin=2;
tic


[M, N, P]=size(A);
%matrix size 2*bin+1 x 2*bin+1

margin=bin+1; %from where data collection will actually start
im=zeros(N-margin*2,P-margin*2); 
decayIM=zeros(N-margin*2,P-margin*2,noOfBin);
DelayMatrix=double(zeros(N-margin*2,P-margin*2)); %matrix with delay of decay in every pixel


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
        DelayMatrix(i-bin,j-bin)=double(loc)*12.5/noOfBin;
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
figure, imshow(flip(DelayMatrix))
% figure, imshow(indexedImage)
colormap(jet(100))
caxis('auto')
colorbar

maxValue=max(max(DelayMatrix));
minValue=min(min(DelayMatrix));
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%delay to wavelength conversion%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DelayMatrix(find(DelayMatrix<5))=0;
% DelayMatrix(find(DelayMatrix>8))=0;
% waveMap=DelaytoWavelength30mCorning(minValue,DelayMatrix);

waveMap=DelaytoWavelength30mFujikura(minValue,DelayMatrix);

% waveMap=DelayMatrix-minValue;
waveMap(find(waveMap<0))=0;
figure, 
figg=imshow((waveMap));
% figure, imshow(indexedImage)
colormap(jet(100))
caxis('auto')
% caxis([0 100])
colorbar
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%histogram calcualtion%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% range=linspace(min(min(DelayMatrix)),max(max(DelayMatrix)),20);
% gg=histc(DelayMatrix(:),range);
% figure,semilogy(range,gg)

range=linspace(min(min(DelayMatrix)),max(max(DelayMatrix)),256);
range=linspace(0,12.5,256);
gg=histc(DelayMatrix(:),range);
figure,semilogy(range,gg)
