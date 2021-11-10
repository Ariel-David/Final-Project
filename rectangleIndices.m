%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coordinates of pixels centers on the DTM
% xPix_n=X1+deltaX*(n-1/2); 1<=n<=Nx, where Nx is number of pixels in
% x-direction.
% For n=Nx xPix_n=X2-deltaX/2.
% Therefore deltaX=(X2-X1)/Nx.
% For y-direction the same is true:
% yPix_n=Y1+deltaY*(n-1/2); deltaY=(Y2-Y1)/Ny
% The point (x,y) corresponds to pixel (nX, nY):
% nX=(x-X1)/deltaX-1/2
% Input:
% R1: [X1, Y1] upper left corner of the rectangle
% R2: [X2, Y2] lower right corner of the rectangle
% x,y - coordintes of the point
% Nx, Ny - numbers of pixels (matrix size)
% Output:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nX, nY]=rectangleIndices(R1,deltaX,deltaY,x,y)

X1=R1(1);  Y1=R1(2); 
nX(1)=ceil((x(1)-X1)/deltaX+1/2);
nX(2)=floor((x(2)-X1)/deltaX+1/2);
nY(1)=ceil((y(1)-Y1)/deltaY+1/2);
nY(2)=floor((y(2)-Y1)/deltaY+1/2);

