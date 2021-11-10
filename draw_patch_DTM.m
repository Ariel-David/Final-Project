%global T_W_to_B;
T_DTM_to_Base = CameraMatStruct.T_W_to_B;
T_Base_to_DTM=invmy(T_DTM_to_Base);
load('..\..\experimentData\calibration\DTMdata\DTMdata.mat')
[ll_1, ll_2]=size(DTMdata);
 global DTM
 DTMmy=DTM;
lengthTs=length(Ts_EE_to_Base_true)-1;
for ii=1:lengthTs
    TTT1=T_Base_to_DTM*Ts_EE_to_Base_true{ii};
    TTT2=T_Base_to_DTM*Ts_EE_to_Base_drifted{ii};
vv1x(ii)=TTT1(1,4);
vv2x(ii)=TTT2(1,4);
vv1y(ii)=TTT1(2,4);
vv2y(ii)=TTT2(2,4);
vv1z(ii)=TTT1(3,4);
vv2z(ii)=TTT2(3,4);
end


% maxv=max(DTMdata(:))
% minv=min(DTMdata(:))
global xxs;
xxs = figure('Position',[40 4 2000 800]);
subplot(1,2,1)
for i=1:1
    for j=1:1
        m=(i-1)*size(DTMdata,2);
        n=(j-1)*size(DTMdata,1);
        hold on
        [X,Y] = meshgrid([m+1:m+size(DTMdata,2)],[n+1:n+size(DTMdata,1)]);
        mesh((X-1)*DTMdelta,(Y-1)*DTMdelta,DTMdata)
        
        %         drawnow
        %         pause
    end
end
%axis([0 10000 0 13000 0 1500])
view(3)
grid

clear DTMdata
subplot(1,2,2)
for ii=1:DTMsize
    for jj=1:DTMsize
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        stri=num2str(ii);
        if ii<10
            imname=['0',stri];
        else
            imname=stri;
        end
        
        strj=num2str(jj);
        if jj<10
            jmname=['0',strj];
        else
            jmname=strj;
        end
        
        DTM_fileNamemy=[DTMmy.DTM_fileName,imname,jmname];
        load(DTM_fileNamemy)
        [Xq,Yq] = meshgrid([1:(size(DTMdata,2)-1)/9:size(DTMdata,2)+eps],[1:(size(DTMdata,1)-1)/9:size(DTMdata,1)+eps]);
        DTMdata1 = interp2(DTMdata,Xq,Yq);
        
        clear DTMdata
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        mm=(ii-1)*size(DTMdata1,2);
        nn=(jj-1)*size(DTMdata1,1);
        DTMdata2(mm+1:mm+size(DTMdata1,2),nn+1:nn+size(DTMdata1,1))=DTMdata1;
        
        
        %         drawnow
        %         pause
    end
end

hold on
[X1,Y1] = meshgrid(1:size(DTMdata2,2),1:size(DTMdata2,1));
mesh((X1-1)*DTMdelta*ll_2/10,(Y1-1)*DTMdelta*ll_1/10,DTMdata2)
xmin=min(vv1x(:))-abs(min(vv1x(:)))*0.02;
xmax=max(vv1x(:))+abs(max(vv1x(:)))*0.02;
ymin=min(vv1y(:))-abs(min(vv1y(:)))*0.02;
ymax=max(vv1y(:))+abs(max(vv1y(:)))*0.02;
zmax=abs(max(vv1z(:)))*1.2;
axis([xmin xmax ymin ymax 0  zmax])
view(3)
grid