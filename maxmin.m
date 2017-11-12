
function y=maxmin(data)
%This function calcualates the rise time for a given decay
data1=data(20:end);

plot(data1)

% [m n ]=max(data1) 
% Data=data1;
% 
% [Maxima,MaxIdx] = findpeaks(Data);
% 
% hold on
% plot(MaxIdx, Maxima,'ro')
e=exp(1);

[maxVal maxIndex]=max(data1);
minVal=maxVal/e;

indHi=min(find(minVal<data1));
indLo=indHi-1;

diff1=data1(indHi)-data1(indLo);
diff2=minVal-data1(indLo);

ratio=diff2/diff1;
minValIndex=indLo+ratio;

riseTime=maxIndex-minValIndex
hold on
plot(indLo,data1(indLo),'ro')
plot(maxIndex,data1(maxIndex),'ro')

y=riseTime;


