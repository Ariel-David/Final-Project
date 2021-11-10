function xyz = enu2xyz_corrected(enu,orgxyz)
%ENU2XYZ	Convert from rectangular local-level-tangent 
%               ('East'-'North'-Up) coordinates to WGS-84 
%               ECEF cartesian coordinates.
%
%	xyz = ENU2XYZ(enu,orgxyz)	
%
%	enu(1) = 'East'-coordinate relative to local origin (meters)
%	enu(2) = 'North'-coordinate relative to local origin (meters)
%	enu(3) = Up-coordinate relative to local origin (meters)
%
%	orgxyz(1) = ECEF x-coordinate of local origin in meters
%	orgxyz(2) = ECEF y-coordinate of local origin in meters
%	orgxyz(3) = ECEF z-coordinate of local origin in meters
%
%	xyz(1,1) = ECEF x-coordinate in meters
%	xyz(2,1) = ECEF y-coordinate in meters
%	xyz(3,1) = ECEF z-coordinate in meters

%	Reference: Alfred Leick, GPS Satellite Surveying, 2nd ed.,
%	           Wiley-Interscience, John Wiley & Sons, 
%	           New York, 1995.
%
%	M. & S. Braasch 10-96
%	Copyright (c) 1996 by GPSoft
%	All Rights Reserved.

if nargin<2,error('insufficient number of input arguments'),end
[m,n]=size(enu);if m<n,tmpenu=enu';else,tmpenu=enu;end
[m,n]=size(orgxyz);if m<n,tmpxyz=orgxyz';else,tmpxyz=orgxyz;end
orgllh = xyz2llh(tmpxyz);
phi = orgllh(1);
lam = orgllh(2);
sinphi = sin(phi);
cosphi = cos(phi);
sinlam = sin(lam);
coslam = cos(lam);
% R= [ -sin(lambda)          cos(lambda)         0     ; ...
%       -sin(xi)*cos(lambda)  -sin(xi)*sin(lambda)  cos(xi); ...
%        cos(xi)*cos(lambda)   cos(xi)*sin(lambda)  sin(xi)];
% Rinv = [ -sin(lambda), -cos(lambda)*sin(xi), cos(lambda)*cos(xi);...
% cos(lambda), -sin(lambda)*sin(xi), cos(xi)*sin(lambda);...
% 0,    cos(xi), sin(xi)];
% R = [ -sinlam          coslam         0     ; ...
%       -sinphi*coslam  -sinphi*sinlam  cosphi; ...
%        cosphi*coslam   cosphi*sinlam  sinphi];
Rinv=[-sinlam  -sinphi*coslam cosphi*coslam;... % Corrected 23 September 2020
    coslam -sinphi*sinlam cosphi*sinlam;...
    0 cosphi sinphi];   
%difxyz = inv(R)*tmpenu;
difxyz = Rinv*tmpenu;
xyz = tmpxyz + difxyz;
