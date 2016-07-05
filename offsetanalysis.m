% Load the offset files exported from SPCImage

m=dlmread('ascAnalysis/FDCFIber30_HI_RED_swell_PC91_980nm_20x_zoom4_shift.asc');

%shift gives us best result
m=m(1:200,:);
m=m-min(min(m));
mm=m/max(max(m));
imshow(mm);
colormap(parula(5))
figure, imshow(mm)
