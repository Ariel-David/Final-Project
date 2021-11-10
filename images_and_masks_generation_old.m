function images_and_masks_generation(Ts_EE_to_Base_in,CameraMatStruct,NpX,NpY,umax,vmax,DTM_fileName,DTMdelta,DTMsize,nImage,smooth1,smooth2)
%%%DTM definition and smoothing
global DTM;
global smoothDTM;

% DTM data files source
stri=num2str(DTMsize);
if DTMsize<10
    imname=['0',stri];
else
    imname=stri;
end
DTMmy=['..\..\experimentData\calibration\DTMdata\DTMdata',imname,imname,'.mat'];
as1 = exist(DTMmy,'file');
DTMmy=['..\..\experimentData\calibration\DTMdata\DTMdatasmooth',imname,imname,'.mat'];
as2 = exist(DTMmy,'file');
imname=[];
stri=num2str(nImage(end));
if nImage(end)<10
    imname=['0000',stri];
elseif nImage(end)<100
    imname=['000',stri];
elseif nImage(end)<1000
    imname=['00',stri];
elseif nImage(end)<10000
    imname=['0',stri];
elseif nImage(end)<100000
    imname=stri;
end
imageFileName=['..\..\experimentData\photos\image_',imname,'.bmp'];
as4 = exist(imageFileName,'file');

if as1==0
    makeDTM;
end

% DTM parameters
initDTM_for_integration(DTM_fileName,DTMdelta,DTMsize);

smoothDTM = DTM;
smoothDTM.DTM_fileName=[DTM.DTM_fileName,'smooth'];
DTM_fileNamemy=[smoothDTM.DTM_fileName,'01','01'];

if as2==0 || as1==0 %??? as1==0
    %%%DTM  smoothing
    smooth_DTM(smooth1,smooth2,DTMsize);
end

tmp=load(DTM_fileNamemy);
DTMdata=tmp.DTMdata;
smoothDTM.data = DTMdata;

if as4==0   
    T_DTM_to_Base = CameraMatStruct.T_W_to_B; % shift of DTM system relative to ENU system
    T_Base_to_DTM = invmy(T_DTM_to_Base);
    
    %%%%%%%%%%% Blok 3 f %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%% Camera parameters
    cameraAp=[umax, vmax]; %
    threshVal=.1;
    thetaThreshX=angleThreshold(threshVal,umax,NpX);
    thetaThreshY=angleThreshold(threshVal,vmax,NpY);
    thetaThresh=max(thetaThreshX,thetaThreshY);
    
    T_EE_to_Cam=CameraMatStruct.T_EE_to_Cam; %camera orientation relative to body

    T_Cam_to_EE = invmy(T_EE_to_Cam); % should be unit matrix
    
    deltaX=DTM.delta;
    deltaY=DTM.delta;

    for i=1:length(nImage)
        T_Cam_to_Base=Ts_EE_to_Base_in{nImage(i)}*T_Cam_to_EE;
        Ts_Base_to_Cam=invmy(T_Cam_to_Base);
        cameraPos=T_Cam_to_Base(1:3,4);
        cameraRot=T_Cam_to_Base(1:3,1:3);
        % cameraPos, corners, center - all in the Base system (meters)
        % cameraRot - in Base system
        [corners, center, numOfRegCorners]=planeProjection_for_integration(cameraAp,cameraPos,cameraRot);
        center=[];
        [X, Y, Z, lightOut]=matCrop_for_integration(corners,numOfRegCorners,T_Base_to_DTM,deltaX,deltaY,cameraPos,thetaThresh,center);
        [D, ~, finf]=picture_from_position_for_integration(Ts_Base_to_Cam,X,Y,Z,lightOut,NpX,NpY,umax,vmax);
        
        strTmp=num2str(nImage(i));
        L=length(strTmp);
        if L<5
            L0='00000';
            L0=L0(1:(5-L));
            L=[L0 strTmp];
        end
        filename=['..\..\experimentData\photos\image_',L, '.bmp'];
        D_uint8 = uint8(255 * (D));
        imwrite(D_uint8, filename);
        if ~isempty(center)
            figure; imshow(D);
        end
        filename=['..\..\experimentData\photos\masks\mask_',L, '.bmp'];
        D_uint8 = uint8(255 * (finf));
        imwrite(D_uint8, filename);
    end
end
return




