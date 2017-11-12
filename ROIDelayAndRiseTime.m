% This program allows the user to draw ROI and calculate delay and rise time of that
% sepcific region

clear all
close all

count=4;
generateData=1; 
% 1, prompts the user for new data
% 0, run based on last data, this is faster

if(generateData==1)
    cellData=bfopen %Requires bioformat path to be added
    data3D=cellData{1,1}(:,1);%taking the 3d array with decay
    
    for k = 1:256
        A(k,:,:) = data3D{k};
    end


    save A
else
    load A

end
num_images=256;




%Draw ROI and create mask
s=squeeze(sum(A,1));
maxS=max(max(s));

while(count>0)

    figure,h_im=imshow(uint8(s/maxS*255));%shows the image with intensity 
    e = imfreehand;%prompts to ask ROI
    
    BW = createMask(e,h_im);
    imshow(BW)%shows the ROI mask
    
    
    for k = 1:num_images
        
        B(k,:,:)= squeeze(A(k,:,:)).*uint16(BW);
    end
    
    %sum over x,y pixel and calculate the delay
    timebins=sum(sum(B,2),3);
    [m delay]=max(timebins);
    delay
    delayinTime=delay*12.5/256
    riseTime=maxmin(timebins);
    figure, semilogy((1:num_images)',timebins,'b')
    count=count-1;
end