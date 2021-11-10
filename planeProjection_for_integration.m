%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function calculates projection of camera matrix. Focus distance
% assumed to be 1. Apertures given by 2 angles in x and y directions.
% Input arguments:
% 1. cameraAp:aperture angles
% 2. cameraPos: position of opticl center in ENU (DTM?) coordinate system
% 3. cameraRot: rotation matrix from camera system to NED
% Output arguments:
% 1. corners: x,y coordinates of projections of 4 camera matrix corners
% matrix 2x4 (matrix assumed to have rectangular shape)
% 2. center: x,y coordinates of projection of camera center
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [corners, center, numOfRegCorners]=planeProjection_for_integration(cameraAp,cameraPos,cameraRot)
center=[0; 0]; % initialization
corners=zeros(2,4);% initialization

% unit direction vectors from center to corners
% nPP=[tan(phiX);tan(phiY);1];
nPP=[.5*cameraAp(1);.5*cameraAp(2);1];

nNP=[-nPP(1);nPP(2);1];
nNN=[-nPP(1);-nPP(2);1];
nPN=[nPP(1);-nPP(2);1];

nCenter=[0; 0; 1]; % unit direction vector to matrix center
nCenter=cameraRot*nCenter;
% Projection of center
alpha=-cameraPos(3)/nCenter(3);
center(1)=cameraPos(1)+alpha*nCenter(1);
center(2)=cameraPos(2)+alpha*nCenter(2);

% Projection of corners
nPP=cameraRot*nPP;
nNP=cameraRot*nNP;
nNN=cameraRot*nNN;
nPN=cameraRot*nPN;

matDirections=[nPP, nNP, nNN, nPN];
zDirections=matDirections(3,:);

isNeg=find(zDirections<0);
if isempty(isNeg) % no regular points
    center=[];
    corners=[];
    numOfRegCorners=0;
    return
end
numOfRegCorners=length(isNeg);
if numOfRegCorners==4
    
    alpha=-cameraPos(3)/nPP(3);
    corners(1,1)=cameraPos(1)+alpha*nPP(1);
    corners(2,1)=cameraPos(2)+alpha*nPP(2);
    
    alpha=-cameraPos(3)/nNP(3);
    corners(1,2)=cameraPos(1)+alpha*nNP(1);
    corners(2,2)=cameraPos(2)+alpha*nNP(2);
    
    alpha=-cameraPos(3)/nNN(3);
    corners(1,3)=cameraPos(1)+alpha*nNN(1);
    corners(2,3)=cameraPos(2)+alpha*nNN(2);
    
    alpha=-cameraPos(3)/nPN(3);
    corners(1,4)=cameraPos(1)+alpha*nPN(1);
    corners(2,4)=cameraPos(2)+alpha*nPN(2);
    return
end
if numOfRegCorners==1
    corners=zeros(2,3);% initialization
    nCurrent=isNeg;
    alpha=-cameraPos(3)/zDirections(isNeg);
    corners(1,1)=cameraPos(1)+alpha*matDirections(1,isNeg);
    corners(2,1)=cameraPos(2)+alpha*matDirections(2,isNeg);
    nPrev=nCurrent-1;
    if nPrev<1
        nPrev=4;
    end
    nNext=nCurrent+1;
    if nNext==5
        nNext=1;
    end
    
    % Neighborhood points
    % First point
    aNext=1-matDirections(3,nNext)/(matDirections(3,nNext)-matDirections(3,isNeg));
    pNext=aNext*matDirections(:,nNext)+(1-aNext)*matDirections(:,isNeg);
    corners(1,2)=pNext(1);
    corners(2,2)=pNext(2);
    % Second point
    aPrev=1-matDirections(3,nPrev)/(matDirections(3,nPrev)-matDirections(3,isNeg));
    pPrev=aPrev*matDirections(:,nPrev)+(1-aPrev)*matDirections(:,isNeg);
    corners(1,3)=pPrev(1);
    corners(2,3)=pPrev(2);
    return
end
if numOfRegCorners==2
    % First regular point
    nCurrent1=isNeg(1);
    alpha=-cameraPos(3)/zDirections(nCurrent1);
    corners(1,1)=cameraPos(1)+alpha*matDirections(1,nCurrent1);
    corners(2,1)=cameraPos(2)+alpha*matDirections(2,nCurrent1);
    % Second regular point
    nCurrent2=isNeg(2);
    alpha=-cameraPos(3)/zDirections(nCurrent2);
    corners(1,2)=cameraPos(1)+alpha*matDirections(1,nCurrent2);
    corners(2,2)=cameraPos(2)+alpha*matDirections(2,nCurrent2);
    % Neighborh of the first regular point
    nClose=nCurrent1-1;
    if nClose<1
        nClose=4;
    end
    if nClose==nCurrent2
        nClose=nCurrent1+1;
        if nClose==5
            nClose=1;
        end
    end
    aClose=1-matDirections(3,nClose)/(matDirections(3,nClose)-matDirections(3,nCurrent1));
    pClose=aClose*matDirections(:,nClose)+(1-aClose)*matDirections(:,nCurrent1);
    corners(1,3)=pClose(1);
    corners(2,3)=pClose(2);
    % Neighborh of the second regular point
    nClose=nCurrent2-1;
    if nClose<1
        nClose=4;
    end
    if nClose==nCurrent1
        nClose=nCurrent2+1;
        if nClose==5
            nClose=1;
        end
    end
    aClose=1-matDirections(3,nClose)/(matDirections(3,nClose)-matDirections(3,nCurrent2));
    pClose=aClose*matDirections(:,nClose)+(1-aClose)*matDirections(:,nCurrent2);
    corners(1,4)=pClose(1);
    corners(2,4)=pClose(2);
    return
end
% 3 regular points
corners=zeros(2,5);% initialization
isPos=find(zDirections>=0); % index
nPrev=isPos-1;
if nPrev<1
    nPrev=4;
end
nNext=isPos+1;
if nNext==5
    nNext=1;
end

% Neighborhood points
% First point
aNext=1-matDirections(3,nNext)/(matDirections(3,nNext)-matDirections(3,isPos));
pNext=(1-aNext)*matDirections(:,nNext)+aNext*matDirections(:,isPos);
corners(1,4)=pNext(1);
corners(2,4)=pNext(2);
% Second point
aPrev=1-matDirections(3,nPrev)/(matDirections(3,nPrev)-matDirections(3,isPos));
pPrev=(1-aPrev)*matDirections(:,nPrev)+aPrev*matDirections(:,isPos);
corners(1,5)=pPrev(1);
corners(2,5)=pPrev(2);

% Regular corners
alpha=-cameraPos(3)/zDirections(nNeg(1));
corners(:,1)=cameraPos(1)+alpha*matDirections(:,nNeg(1));

alpha=-cameraPos(3)/zDirections(nNeg(2));
corners(:,2)=cameraPos(1)+alpha*matDirections(:,nNeg(2));

alpha=-cameraPos(3)/zDirections(nNeg(3));
corners(:,3)=cameraPos(1)+alpha*matDirections(:,nNeg(3));
