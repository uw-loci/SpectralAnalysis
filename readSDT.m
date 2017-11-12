
% Reads SDT FLIM files with BIOformats
% Author: Md Abdul Kader Sagar(msagar@wisc.edu)
% LOCI, UW Madison
%
% Will prompt the user to either generate new file or use old file(reading
% new file will automatically be saved in a .mat file). It is helpful when same data is run several times
% bioformat path should be added to MATLAB, direction available in BF
% website

close all
clear all

% bin=3;

noOfBin=256;%This is 256 most of the times for regular data

M=256; 
N=256;
P=256;
A=zeros(M,N,P);
% noOfBin=256;

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