%%
%This code bins the decay matrix as 3x3 
% Ask the user to choose a SDT file

%calculates the delay of peak in each pixel and creates another...
%matrix with the delay value(maxMatris). The value of maxMatrix is..
%supposed to show us the spectral distribution

%%
close all
clear all

generateData=1; 
% 1, prompts the user for new data
% 0, run based on last data, this is faster

if(generateData==1)
    cellData=bfopen %Requires bioformat path to be added
    data3D=cellData{1,1}(:,1);%taking the 3d array with decay
    
    for k = 1:256
        A(k,:,:) = data3D{k};
    end
    %
%     the following code block creates the A matrix if needed
%     fname = 'mix321_980nm_no_filter_PC_232_20x_zoom5_withoutND_30m_fiber.tif';
%    
% %     old code from ImageJ
% %     fname = 'mix321_980nm_no_filter_PC_261_20x_zoom5_withoutND_30m_fiber_60s.tif';
%     
%     info = imfinfo(fname);
%     num_images = numel(info);
%     for k = 1:num_images
%         A(k,:,:) = imread(fname, k, 'Info', info);
%     end
    save A
else
    load A

%
%     B(1:256)=col(1:256);
%     ff=cell2mat(B);
%     A=reshape(ff,[256 256 256]);
end

[M, N, P]=size(A);

%matrix size 2*bin+1 x 2*bin+1
bin=1;
margin=bin+1; %from where data collection will actually start
im=zeros(N-margin*2,P-margin*2); 
decayIM=zeros(N-margin*2,P-margin*2,256);
maxMatrix=double(zeros(N-margin*2,P-margin*2)); %matrix with delay of decay in every pixel
%%
%This code bins the decay matrix as 3x3 
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
generateData=1; 
% 1, prompts the user for new data
% 0, run based on last data, this is faster

if(generateData==1)
    cellData=bfopen %Requires bioformat path to be added
    data3D=cellData{1,1}(:,1);%taking the 3d array with decay
    
    for k = 1:256
        A(k,:,:) = data3D{k};
    end
    %
%     the following code block creates the A matrix if needed
%     fname = 'mix321_980nm_no_filter_PC_232_20x_zoom5_withoutND_30m_fiber.tif';
%    
% %     old code from ImageJ
% %     fname = 'mix321_980nm_no_filter_PC_261_20x_zoom5_withoutND_30m_fiber_60s.tif';
%     
%     info = imfinfo(fname);
%     num_images = numel(info);
%     for k = 1:num_images
%         A(k,:,:) = imread(fname, k, 'Info', info);
%     end
    save A
else
    load A

%
%     B(1:256)=col(1:256);
%     ff=cell2mat(B);
%     A=reshape(ff,[256 256 256]);
end

[M, N, P]=size(A);

%matrix size 2*bin+1 x 2*bin+1

margin=bin+1; %from where data collection will actually start
im=zeros(N-margin*2,P-margin*2); 
decayIM=zeros(N-margin*2,P-margin*2,256);
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
        [loc maxVal]=max(g);%finding the location of the peak
        maxMatrix(i-bin,j-bin)=double(loc)*12.5/256;
        im(i-bin,j-bin)=sum(pixVal);
        decayIM(i-bin,j-bin,:)=g;
    end
    
;
end

imshow(im/max(max(im)))
figure, imshow(maxMatrix/max(max(maxMatrix)))
% figure, imshow(maxMatrix)
colormap(parula(5))




for i=margin:N-margin
    for j=margin:P-margin
%         g=... 
%         A(:,i-1,j-1)+A(:,i,j-1)+A(:,i+1,j)+...
%         A(:,i,j)+A(:,i-1,j)+A(:,i+1,j)+...
%         A(:,i-1,j+1)+A(:,i,j+1)+A(:,i+1,j+1);
    
        
        g=A(:,i-bin:i+bin,j-bin:j+bin);
        g=sum(sum(g,2),3);
        
        if(i==32 && j==41)
            hhh=9;
        end
        pixVal=squeeze(g);
        [loc maxVal]=max(g);%finding the location of the peak
        maxMatrix(i-bin,j-bin)=double(loc)*12.5/256;
        im(i-bin,j-bin)=sum(pixVal);
        decayIM(i-bin,j-bin,:)=g;
    end
    
;
end

imshow(im/max(max(im)))
figure, imshow(maxMatrix/max(max(maxMatrix)))
% figure, imshow(maxMatrix)
colormap(parula(5))


