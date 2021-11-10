function [D, Mask, finf]=picture_from_position_for_integration(Ts_Base_to_Cam,X,Y,Z,lightVec,Nresx,Nresy,umax,vmax)

% tIn=cputime;
% t=cputime;
%ground grid points on photo (UV) + distance (dist)+light intensity (Light)

if isempty(X)
    D=zeros(Nresy,Nresx);
    Mask=D;
    finf=false;
    return;
end
CC(1,:)=X(:)';
CC(2,:)=Y(:)';%-Ts_DTM_to_Cam(2,4);
CC(3,:)=Z(:)';%-Ts_DTM_to_Cam(3,4);
CC(4,:)=ones(1,length(Z));
Light=lightVec(:)';

% poitns of the orthophoto (height and light) in the camera system
CC=Ts_Base_to_Cam*CC;
%disp(['local time 1 = ', num2str(cputime-t,6)]);
dist=sqrt(CC(1,:).^2+CC(2,:).^2+CC(3,:).^2);
fpos=(CC(3,:)>0); % points in front of camera NB could be problem if fpos is empty
if sum(fpos)<1
    D=zeros(Nresy,Nresx);
    Mask=D;
    finf=false;
    return;
end
CC=CC(:,fpos);
dist=dist(fpos);
Light=Light(fpos);
clear fpos
UV=[CC(1,:) ; CC(2,:)]./[CC(3,:); CC(3,:)]; % projection on photo plane
UV(3,:)=ones(1,size(UV,2));
clear CCAM
futuresnum=((abs(UV(2,:))<vmax/2)&(abs(UV(1,:))<umax/2));  %Indicator:   points inside  the sensor
if sum(futuresnum)<1
    D=zeros(Nresy,Nresx);
    Mask=D;
    finf=false;
    return;
end
UV=UV(:,futuresnum);
dist=dist(futuresnum); %dist from camera to the point on the ground
Light=Light(futuresnum);
clear futuresnum
%disp(['local time 2 = ', num2str(cputime-t,6)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%transform from coordinates u v to pixels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TT=[1 0 umax/2;0 1 vmax/2; 0 0 1];
UVZ=TT*UV; % to replace matrix multiplication by vector shift
du=umax/Nresx;
dv=vmax/Nresy;
UVN(1,:)=floor(UVZ(1,:)/du)+1;
UVN(2,:)=floor(UVZ(2,:)/dv)+1;
clear UVZ

Bdist(1:Nresy,1:Nresx)=inf;
Bi(1:Nresy,1:Nresx)=0;
Nsze=size(UVN,2);

%t=cputime;
for ig=1:Nsze
    atek=Bdist(UVN(2,ig),UVN(1,ig));
    if( dist(ig) < atek ) % raytracing solution - point, closest to the sensor 
        Bdist(UVN(2,ig),UVN(1,ig))=dist(ig);
        Bi(UVN(2,ig),UVN(1,ig))=ig;
    end
end
%disp(['local time 3, for loop = ', num2str(cputime-t,16)]);
clear  Bdist

Mask=zeros(size(Bi));
Bi=Bi(:);
ffBi=(Bi>0);
Bi=Bi(ffBi);
Mask(ffBi)=1;
% place to calculate mask
clear ffBi

clear UVN
AUV1=UV(1,Bi);
AUV2=UV(2,Bi);
ALight=Light(Bi);
clear UVF UV Light
clear fff
clear  UV Light Bi

%grid of pixels formation
Nbigx=Nresx;
Nbigy=Nresy;
Nx2=(Nbigx+1)/2;
Ny2=(Nbigy+1)/2;
du1=umax/Nbigx;
dv1=vmax/Nbigy;

%pixel coordinates
[X,Y]=meshgrid(1:Nbigx,1:Nbigy);
beforeMovment_Cam_uv(1,:)=(X(:).'-Nx2)*du1;
beforeMovment_Cam_uv(2,:)=(Y(:).'-Ny2)*dv1;
clear X Y

% light intensity in grid pixels by  LINEAR INTERPOLATION
%t=cputime;
Le_W = griddata(AUV1(:)',AUV2(:)',ALight(:)',beforeMovment_Cam_uv(1,:),beforeMovment_Cam_uv(2,:));

%disp(['local time 3,  griddata = ', num2str(cputime-t,6)]);
clear AUV1 AUV2 ALight beforeMovment_Cam_uv

%intensity of light in all pixels
D=reshape(Le_W,Nbigy,Nbigx);
%D=D.*Mask;
%NaN intensity value pixels
finf=isnan(D);
D(finf)=0;
finf=~finf;
%finf=~(D<0|D>=0);
%disp(['local time 4 = ', num2str(cputime-t,16)]);
%disp(['total time in = ', num2str(cputime-tIn,6)]);
return