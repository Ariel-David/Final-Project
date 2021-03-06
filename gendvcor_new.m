function dvcor = gendvcor_new(lat_prof,totvel_prof,totvelz_prof,tc_prof,height_prof,time,...
    DCMnb_prof,DCMel_prof,earthflg)
%GENDVCOR      Function to generate the component of delta-V
%              associated with Coriolis and gravity.  North-pointing
%              mechanization assumed.
%
%	dvcor = gendvcor(lat_prof,totvel_prof,tc_prof,height_prof,time,...
%                          DCMnb_prof,DCMel_prof,earthflg)
%
%   INPUTS
%       lat_prof = profile of latitude (radians) of the flight path
%       totvel_prof = profile of total velocity (m/s) over the flight path
%       tc_prof = profile of true course (radians) of the vehicle
%       height_prof = vehicle height profile over the flight path (meters)
%       time = sequential time vector over the flight path (seconds)
%       DCMnb_prof = profile of direction cosine elements over time
%                    relating nav-frame to body-frame
%          DCMnb_prof(i,1:9) = elements of the i-th direction cosine matrix
%                            (DCM) for vehicle attitude (navigation-to-
%                            body); 1 = DCM(1,1),
%                            2 = DCM(1,2), 3 = DCM(1,3),
%                            4 = DCM(2,1), et cetera
%       DCMel_prof = profile of direction cosine elements over time
%                    relating earth-frame to local-level-frame
%          DCMel_prof(i,1:9) = elements of the i-th direction cosine matrix
%                            (DCM) for vehicle position; 1 = DCM(1,1),
%                            2 = DCM(1,2), 3 = DCM(1,3),
%                            4 = DCM(2,1), et cetera
%       earthflg = earth shape flag
%                  0 = spherical earth; 1 = WGS-84 ellipsoid (see CRAFRATE)
%
%   OUTPUTS
%       dvcor = profile of delta-V (Coriolis and gravity only)
%               in body frame (nose-rt.wing-down)
%

%	M. & S. Braasch 6-98
%	Copyright (c) 1998 by GPSoft
%	All Rights Reserved.
%

if nargin<8,error('insufficient number of input arguments'),end
if (earthflg ~= 0) & (earthflg ~= 1), error('EARTHFLG not specified correctly'),end

C = [0 1 0; 1 0 0; 0 0 -1];      % Conversion between ENU and NED
vertmech = 0;
nT=max(size(lat_prof));
dvcor=zeros(nT-1,3);
for i = 2:nT
    
    totvel1mps = totvel_prof(i-1)*1.6878*0.3048;
    vx1 = totvel1mps*sin(tc_prof(i-1));
    vy1 = totvel1mps*cos(tc_prof(i-1));
    vz1 = totvelz_prof(i-1)*1.6878*0.3048;
    totvel2mps = totvel_prof(i)*1.6878*0.3048;
    vx2 = totvel2mps*sin(tc_prof(i));
    vy2 = totvel2mps*cos(tc_prof(i));
    vz2 = totvelz_prof(i)*1.6878*0.3048;
    
    td12 = time(i) - time(i-1);
    %tdin = 0.5*td12;
    % v_in = v1 + ( (v2 - v1)/td12 )*tdin; - interpol.m +> for tdin = 0.5*td12
    % v_in=.5*(v1+v2); corrected 23 September 2020
    %lat_in = interpol(lat_prof(i-1),lat_prof(i),td12,tdin);
    %    vx_in = interpol(vx1,vx2,td12,tdin);
    %    vy_in = interpol(vy1,vy2,td12,tdin);
    %    vz_in = interpol(vz1,vz2,td12,tdin);
    lat_in = .5*(lat_prof(i-1)+lat_prof(i));
    vx_in = .5*(vx1+vx2);
    vy_in = .5*(vy1+vy2);
    vz_in = .5*(vz1+vz2);
    vel_in = [vx_in vy_in vz_in];
    % height_in = interpol(height_prof(i-1),height_prof(i),td12,tdin);
    height_in = .5*(height_prof(i-1)+height_prof(i));
    
    DCMnb2=[DCMnb_prof(i,1:3); DCMnb_prof(i,4:6); DCMnb_prof(i,7:9)];
    DCMnb1=[DCMnb_prof(i-1,1:3); DCMnb_prof(i-1,4:6); DCMnb_prof(i-1,7:9)];
    DCMnbavg = 0.5*( DCMnb2 + DCMnb1 );
    DCMbnavg = DCMnbavg';
    DCMel2=[DCMel_prof(i,1:3); DCMel_prof(i,4:6); DCMel_prof(i,7:9)];
    DCMel1=[DCMel_prof(i-1,1:3); DCMel_prof(i-1,4:6); DCMel_prof(i-1,7:9)];
    DCMelavg = 0.5*( DCMel2 + DCMel1 );
    
    omega_el_L = crafrate(lat_in,vx_in,vy_in,height_in,DCMelavg,earthflg,vertmech);
    omega_en_n = C*omega_el_L;
    
    vel_cor_b = coriolis(vel_in,omega_en_n,DCMbnavg,DCMelavg,1,td12);
    
    g_tru = gravity(lat_in,height_in);
    g_vect_n = [0 0 -g_tru]';
    vel_g_n = g_vect_n*td12;
    %%  vel_g_b = DCMbnavg*vel_g_n
    vel_g_b = DCMnbavg*vel_g_n;
    
    dvcor(i-1,1:3) = (-vel_cor_b + vel_g_b)';
end

