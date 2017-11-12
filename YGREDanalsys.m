clear
close all
clc


load timebinsYG
load timebinsRED

timebinsYG=timebinsYG/max(timebinsYG);
timebinsRED=timebinsRED/max(timebinsRED);

plot(timebinsYG,'g');
hold on
plot(timebinsRED,'r')




[val I]=max(timebinsYG)
[val I]=max(timebinsRED)