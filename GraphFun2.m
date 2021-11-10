%GraphFun2: final graphs: 
disp( 'GraphFun2: final graphs..........');
grad2rad=pi/180;
C = [0 1 0; 1 0 0; 0 0 -1];
lengthTs=length(Ts_EE_to_Base_constructedPath);

tt=zeros(1,lengthTs);
bx_true=zeros(1,lengthTs);
by_true=zeros(1,lengthTs);
bz_true=zeros(1,lengthTs);

  
phi_frame_true=zeros(1,lengthTs);    
Teta_frame_true=zeros(1,lengthTs);    
Psi_frame_true=zeros(1,lengthTs);      
bx_constructedPath=zeros(1,lengthTs);
by_constructedPath=zeros(1,lengthTs);
bz_constructedPath=zeros(1,lengthTs);

phi_frame_constructedPath=zeros(1,lengthTs);
Teta_frame_constructedPath=zeros(1,lengthTs);
Psi_frame_constructedPath=zeros(1,lengthTs);

bx_drifted=zeros(1,lengthTs);
by_drifted=zeros(1,lengthTs);
bz_drifted=zeros(1,lengthTs);

phi_frame_drifted=zeros(1,lengthTs);
Teta_frame_drifted=zeros(1,lengthTs);
Psi_frame_drifted=zeros(1,lengthTs);

for ii=1:lengthTs
    
    tt(ii)=time(ii);
    
    
    bx_true(ii)=Ts_EE_to_Base_true{ii}(1,4);
    by_true(ii)=Ts_EE_to_Base_true{ii}(2,4); 
    bz_true(ii)=Ts_EE_to_Base_true{ii}(3,4);
    
    
    phiTetaPsi_frame_true = extractEulerAngles(C*Ts_EE_to_Base_true{ii}(1:3,1:3)); 
    

    if ii>1
    phi_frame_true(ii)=yawprog(phiTetaPsi_frame_true(1),phi_frame_true(ii-1));
    else
    phi_frame_true(ii)=phiTetaPsi_frame_true(1);
    end 
    
    if ii>1
    Teta_frame_true(ii)=yawprog(phiTetaPsi_frame_true(2),Teta_frame_true(ii-1));
    else
    Teta_frame_true(ii)=phiTetaPsi_frame_true(2);
    end 
    
    if ii>1
    Psi_frame_true(ii)=yawprog(phiTetaPsi_frame_true(3),Psi_frame_true(ii-1));
    else
    Psi_frame_true(ii)=phiTetaPsi_frame_true(3);
    end 
    
    bx_constructedPath(ii)=Ts_EE_to_Base_constructedPath{ii}(1,4);
    by_constructedPath(ii)=Ts_EE_to_Base_constructedPath{ii}(2,4); 
    bz_constructedPath(ii)=Ts_EE_to_Base_constructedPath{ii}(3,4);
    
    
    
    phiTetaPsi_frame_constructedPath = extractEulerAngles(C*Ts_EE_to_Base_constructedPath{ii}(1:3,1:3)); 
    

     if ii>1
    phi_frame_constructedPath(ii)=yawprog(phiTetaPsi_frame_constructedPath(1),phi_frame_constructedPath(ii-1));
    else
    phi_frame_constructedPath(ii)=yawprog(phiTetaPsi_frame_constructedPath(1),phiTetaPsi_frame_true(1));
    end 
    
    if ii>1
    Teta_frame_constructedPath(ii)=yawprog(phiTetaPsi_frame_constructedPath(2),Teta_frame_constructedPath(ii-1));
    else
    Teta_frame_constructedPath(ii)=yawprog(phiTetaPsi_frame_constructedPath(2),phiTetaPsi_frame_true(2));
    end 
    
    if ii>1
    Psi_frame_constructedPath(ii)=yawprog(phiTetaPsi_frame_constructedPath(3),Psi_frame_constructedPath(ii-1));
    else
    Psi_frame_constructedPath(ii)=yawprog(phiTetaPsi_frame_constructedPath(3),phiTetaPsi_frame_true(3));
    end 

    
    
    

    
    bx_drifted(ii)=Ts_EE_to_Base_drifted{ii}(1,4);
    by_drifted(ii)=Ts_EE_to_Base_drifted{ii}(2,4); 
    bz_drifted(ii)=Ts_EE_to_Base_drifted{ii}(3,4);
    
    
  
    
    
    phiTetaPsi_frame_drifted = extractEulerAngles(C*Ts_EE_to_Base_drifted{ii}(1:3,1:3)); 
    

    if ii>1
    phi_frame_drifted(ii)=yawprog(phiTetaPsi_frame_drifted(1),phi_frame_drifted(ii-1));
    else
    phi_frame_drifted(ii)=yawprog(phiTetaPsi_frame_drifted(1),phiTetaPsi_frame_true(1));
    end 
    
    if ii>1
    Teta_frame_drifted(ii)=yawprog(phiTetaPsi_frame_drifted(2),Teta_frame_drifted(ii-1));
    else
    Teta_frame_drifted(ii)=yawprog(phiTetaPsi_frame_drifted(2),phiTetaPsi_frame_true(2));
    end 
    
    if ii>1
    Psi_frame_drifted(ii)=yawprog(phiTetaPsi_frame_drifted(3),Psi_frame_drifted(ii-1));
    else
    Psi_frame_drifted(ii)=yawprog(phiTetaPsi_frame_drifted(3),phiTetaPsi_frame_true(3));
    end 
    

    
    

   
    
    
    
   
end

% zz1=[lat lon hint];  %initial position    
% 
% lonlath(1,1:3)=[zz1(2) zz1(1) hint];
% xyz1=llh2xyz(zz1);
% for ii = 2:size(bx_constructedPath,2)
% deltaenu=[bx_constructedPath(ii)-bx_constructedPath(ii-1) by_constructedPath(ii)-by_constructedPath(ii-1) bz_constructedPath(ii)-bz_constructedPath(ii-1)];
% xyz=enu2xyz(deltaenu,xyz1);
% llh=xyz2llh(xyz);
% xyz1=xyz;
% lonlath(ii,1:3)=[llh(2) llh(1) llh(3)];
% end
% 
% lonlath(:,1:2)=lonlath(:,1:2)/grad2rad;

% exact coordinate picture
lonlath=lonlath_func(bx_true,by_true,bz_true,lat, lon, hint);
figure
subplot(3,2,1)
plot3(lonlath(:,1),lonlath(:,2),lonlath(:,3),'b','LineWidth',2)
title('Flight Path from exact navigation')
xlabel('east(longitude) (grad)')
ylabel('north(latitude) (grad)')
zlabel('up (meters)')
grid


subplot(3,2,2)
plot(tt,phi_frame_true(:)/grad2rad, 'r')
hold on
plot(tt,Teta_frame_true(:)/grad2rad,'g')
hold on
plot(tt,Psi_frame_true(:)/grad2rad, 'b')
%axis equal
title('  Euler Angles from exact navigation')
xlabel('time (s)')
ylabel('roll(r) pitch(g) yaw(b) (grad)')
grid

% drifted coordinate picture
lonlath=lonlath_func(bx_drifted,by_drifted,bz_drifted,lat, lon, hint);

subplot(3,2,3)
plot3(lonlath(:,1),lonlath(:,2),lonlath(:,3),'b','LineWidth',2)
title('Flight Path from inertial navigation')
xlabel('east(longitude) (grad)')
ylabel('north(latitude) (grad)')
zlabel('up (meters)')
grid


subplot(3,2,4)
plot(tt,phi_frame_drifted(:)/grad2rad, 'r')
hold on
plot(tt,Teta_frame_drifted(:)/grad2rad,'g')
hold on
plot(tt,Psi_frame_drifted(:)/grad2rad, 'b')
%axis equal
title('  Euler Angles from inertial navigation')
xlabel('time (s)')
ylabel('roll(r) pitch(g) yaw(b) (grad)')
grid



% Visual base navigation picture
lonlath=lonlath_func(bx_constructedPath,by_constructedPath,bz_constructedPath,lat, lon, hint);

subplot(3,2,5)
plot3(lonlath(:,1),lonlath(:,2),lonlath(:,3),'b','LineWidth',2)
title('Flight Path from vision-based navigation')
xlabel('east(longitude) (grad)')
ylabel('north(latitude) (grad)')
zlabel('up (meters)')
grid


subplot(3,2,6)
plot(tt,phi_frame_constructedPath(:)/grad2rad, 'r')
hold on
plot(tt,Teta_frame_constructedPath(:)/grad2rad,'g')
hold on
plot(tt,Psi_frame_constructedPath(:)/grad2rad, 'b')
%axis equal
title('  Euler Angles from vision-based navigation')
xlabel('time (s)')
ylabel('roll(r) pitch(g) yaw(b) (grad)')
grid



figure
subplot(2,3,1)
plot(tt,bx_constructedPath-bx_true, 'b')
hold on
plot(tt,bx_drifted-bx_true,'r')
title('Error x: Inertial nav(r) vs Vision-based nav(b)')
xlabel('time (c)')
ylabel('error x (m)')
grid

subplot(2,3,2)
plot(tt,by_constructedPath-by_true, 'b')
hold on
plot(tt,by_drifted-by_true,'r')
title('Error y: Inertial nav(r) vs Vision-based nav(b)')
xlabel('time (c)')
ylabel('Error y (m)')
grid



subplot(2,3,3)
plot(tt,bz_constructedPath-bz_true, 'b')
hold on
plot(tt,bz_drifted-bz_true,'r')
title('Error z: Inertial nav(r) vs Vision-based nav(b)')
xlabel('time (c)')
ylabel('Error z (m)')
grid

Droll_constructedPath=yawprog(phi_frame_constructedPath-phi_frame_true,0);
Droll_drifted=yawprog(phi_frame_drifted-phi_frame_true,0);


subplot(2,3,4)
plot(tt(1:length(Droll_constructedPath)),Droll_constructedPath/grad2rad, 'b')
hold on
plot(tt(1:length(Droll_drifted)),Droll_drifted/grad2rad,'r')
title('Error roll: Inertial nav(r) vs Vision-based nav(b)')
xlabel('time (s)')
ylabel('Error roll (grad)')
grid




Dpitch_constructedPath=yawprog(Teta_frame_constructedPath-Teta_frame_true,0);
Dpitch_drifted=yawprog(Teta_frame_drifted-Teta_frame_true,0);


subplot(2,3,5)
plot(tt(1:length(Dpitch_constructedPath)),Dpitch_constructedPath/grad2rad, 'b')
hold on
plot(tt(1:length(Dpitch_drifted)),Dpitch_drifted/grad2rad,'r')
title('Error pitch: Inertial nav(r) vs Vision-based nav(b)')
xlabel('time (s)')
ylabel('Error pitch (grad)')
grid




Dyaw_constructedPath=yawprog(Psi_frame_constructedPath-Psi_frame_true,0);
Dyaw_drifted=yawprog(Psi_frame_drifted-Psi_frame_true,0);


subplot(2,3,6)
plot(tt(1:length(Dyaw_constructedPath)),Dyaw_constructedPath/grad2rad, 'b')
hold on
plot(tt(1:length(Dyaw_drifted)),Dyaw_drifted/grad2rad,'r')
title('Error yaw: Inertial nav(r) vs Vision-based nav(b)')
xlabel('time (s)')
ylabel('Error yaw (grad)')
grid