% this program runs the program twice and asks to draw ROI
% And the decay for two run will be plotted side by side
% Specifically for fiber project to see two decay

clear all
close all

count=2;
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
    load A A

end
num_images=256;




%Draw ROI and create mask
s=squeeze(sum(A,1));
maxS=max(max(s));
i=1;
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
title('30m 62.5um core fiber');

difference_in_peak=(delayarray(1)-delayarray(2))*12.5/256