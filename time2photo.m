function [nOut, tOut]=time2photo(time,timeStep)
tIn=time(1); tF=time(end);
Nmax=ceil((tF-tIn)/timeStep);
nOut=(1:Nmax)';
tOut=nOut;
nT=length(time);
nCurrent=1;
tCurrent=tIn;
for i=1:Nmax
    for j=nCurrent:(nT-1)
        if time(j)<=tCurrent && time(j+1)>tCurrent
            break;
        end
    end
    nOut(i)=j;
    tOut(i)=tCurrent;
    tCurrent=tCurrent+timeStep;
    nCurrent=j;
    if j>(nT-1)
        break;
    end
end
nOut=nOut(1:i);
tOut=tOut(1:i);
if (tOut(end)+timeStep)<=(time(end)+eps)
    tOut=[tOut; time(end)];
    nOut=[nOut; nT];
end