function plotRect_for_integration(corners,center,nInts,im)
if isempty(nInts)
    nInts=100;
end
n=0:(nInts-1);
n=n'/(nInts-1);
cornersNum=size(corners,2);
xC=center(1);
yC=center(2);
figure;
if nargin>2
    imshow(im);
end
x1=corners(1,1)+(corners(1,2)-corners(1,1))*n;
y1=corners(2,1)+(corners(2,2)-corners(2,1))*n;

x2=corners(1,2)+(corners(1,3)-corners(1,2))*n;
y2=corners(2,2)+(corners(2,3)-corners(2,2))*n;
line('XData',x1,'YData',y1,'Color','blue');
line('XData',x2,'YData',y2,'Color','red');
line('XData',xC,'YData',yC,'Color','blue','LineWidth',2,'Marker','.');
grid on;
if cornersNum<4
    x3=corners(1,1)+(corners(1,3)-corners(1,1))*n;
    y3=corners(2,1)+(corners(2,3)-corners(2,1))*n;
    line('XData',x3,'YData',y3,'Color','bluse');
    return;
end
x3=corners(1,3)+(corners(1,4)-corners(1,3))*n;
y3=corners(2,3)+(corners(2,4)-corners(2,3))*n;

x4=corners(1,4)+(corners(1,1)-corners(1,4))*n;
y4=corners(2,4)+(corners(2,1)-corners(2,4))*n;



line('XData',x3,'YData',y3,'Color','blue');
line('XData',x4,'YData',y4,'Color','blue');
