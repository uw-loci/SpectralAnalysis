clear all
close all

load g
[maxVal loc]=max(g);


h=fwhm(1:length(g),g);