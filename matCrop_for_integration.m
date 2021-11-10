%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function cropes ROI (both heights and illumination) for convex
% quadrangle.
% Input arguments:
% 1. corners: x,y coordinates of quadrangle vertices
% 2. lightIn: illumination matrix
% 3. heightIn: heights matrix
% 4.
% 5.
% 6. center: coordinates of camera center in DTM system
% 7. centerProjection: projection of camera center in direction of opitcal axis
% Output arguments:
% 1.  X,Y,Z - coordinates of points on surface inside quadrangle
% 2. lightOut: corresponding values of illumination
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X, Y, Z, lightOut]=matCrop_for_integration(corners,numOfRegCorners,T_Base_to_DTM,deltaX,deltaY,cameraPos,thetaThresh,center)
global DTM
R1_DTM=invmy(T_Base_to_DTM)*[0; 0; 0; 1];
xTotMin=R1_DTM(1);
yTotMin=R1_DTM(2);
Nx=DTM.size(2);
Ny=DTM.size(1);
xTotMax=xTotMin+Nx*deltaX;
yTotMax=yTotMin+Ny*deltaY;
% To check consistency ENU and DTM x-y coordinates.

if numOfRegCorners==0
    X=[];Y=[];Z=[];lightOut=[];
    return;
end
cornersForPlot=corners;
if numOfRegCorners==1
    corners(:,2:3)=inf*corners(:,2:3);
elseif numOfRegCorners==2
    corners(:,3:4)=inf*corners(:,3:4);
elseif numOfRegCorners==3
    corners(:,4:5)=inf*corners(:,4:5);
end

xMin=min(corners(1,:));
xMax=max(corners(1,:));
yMin=min(corners(2,:));
yMax=max(corners(2,:));

if ~isempty(thetaThresh)
    xMinTh=cameraPos(1)-cameraPos(3)*tan(thetaThresh);
    xMaxTh=cameraPos(1)+cameraPos(3)*tan(thetaThresh);
    yMinTh=cameraPos(2)-cameraPos(3)*tan(thetaThresh);
    yMaxTh=cameraPos(2)+cameraPos(3)*tan(thetaThresh);
else
    xMinTh=-Inf;
    xMaxTh=Inf;
    yMinTh=-Inf;
    yMaxTh=Inf;
end

xMinF=max([xTotMin,xMin,xMinTh]);
xMaxF=min([xTotMax,xMax,xMaxTh]);
yMinF=max([yTotMin,yMin,yMinTh]);
yMaxF=min([yTotMax,yMax,yMaxTh]);

if xMaxF<=xMin || yMaxF<=yMin
    X=[];Y=[];Z=[];lightOut=[];
    return
end

% DTM coordinates (pixels) of camera projection rectangle
R_minF_DTM=T_Base_to_DTM*[xMinF; yMinF; 0; 1];
R_maxF_DTM=T_Base_to_DTM*[xMaxF; yMaxF; 0; 1];
%[nXtmp, nYtmp]=rectangleIndices_for_integration(R1_DTM,deltaX,deltaY,[xMinF,xMaxF],[yMinF,yMaxF]);
[nXtmp, nYtmp]=rectangleIndices_for_integration(deltaX,deltaY,R_minF_DTM,R_maxF_DTM);
nYmin=nYtmp(1);
nXmin=nXtmp(1);
nYmax=nYtmp(2);
nXmax=nXtmp(2);

% xCoords=xMinF+((0:(nXmax-nXmin))+.5)*deltaX; % coordinates in Base system (meters)
% yCoords=yMinF+((0:(nYmax-nYmin))+.5)*deltaY;


ism=0; % 0 for not smooth data; 1 for smooth data, 
[lightIn, heightIn, arrayX0, arrayY0]=getArrayL_for_integration(nYmin,nXmin,nYmax,nXmax,ism);
% arrayX0, arrayY0 - coordinates of the left upper corners of the matrix
% lightIn in DTM coordinates system (in pixels)
lightOut=lightIn((nYmin:nYmax)-arrayY0,(nXmin:nXmax)-arrayX0);

xCoords=R_minF_DTM(1)+((0:(nXmax-nXmin))+.5)*deltaX; % coordinates in DTM system (meters)
yCoords=R_minF_DTM(2)+((0:(nYmax-nYmin))+.5)*deltaY;
[X,Y]=meshgrid(xCoords,yCoords);
X=X(:);
Y=Y(:);
Z=heightIn((nYmin:nYmax)-arrayY0,(nXmin:nXmax)-arrayX0);
Z=Z(:);
R_Base=invmy(T_Base_to_DTM)*[X'; Y'; Z'; ones(1,length(X))];
X=R_Base(1,:)';
Y=R_Base(2,:)';
Z=R_Base(3,:)';
lightOutTmp=lightOut; % for plot for testing
lightOut=lightOut(:);


if ~isempty(center) % plot for testing
    cornersForPlot(3,:)=zeros(1,size(cornersForPlot,2));
    cornersForPlot(4,:)=ones(1,size(cornersForPlot,2));
    cornersForPlot=T_Base_to_DTM*cornersForPlot;
    cornersForPlot(1,:)=cornersForPlot(1,:)/deltaX;
    cornersForPlot(2,:)=cornersForPlot(2,:)/deltaY; 
    
    center(3)=0;
    center(4)=1;
    center=T_Base_to_DTM*center;
    center(1)=center(1)/deltaX;
    center(2)=center(2)/deltaY;
    %
    cornersForPlot(1,:)=cornersForPlot(1,:)-arrayX0;
    cornersForPlot(2,:)=cornersForPlot(2,:)-arrayY0;
    center(1)=center(1)-arrayX0;
    center(2)=center(2)-arrayY0;
    plotRect_for_integration(cornersForPlot,center,[],lightIn)
    figure;imshow(lightOutTmp);
    %plotRect_for_integration(cornersForPlot,center,[],heightIn/max(heightIn(:)))
    %figure;imshow(lightOutTmp);
end

return;
