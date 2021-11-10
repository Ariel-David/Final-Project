function deltheta = gendthet_corrected(DCMnb_prof)
%GENDTHET      Delta-theta generator.  Local-level components
%              only.  Earth-rate and craft-rate components
%              not calculated (see EARTHROT and CRAFRATE)
%       
%	deltheta = gendthet(DCMnb_prof)
%
%   INPUTS
%       DCMnb_prof = profile of direction cosine elements over time
%                    relating nav-frame to the body-frame
%          DCMnb_prof(i,1:9) = elements of the i-th direction cosine matrix
%                            (DCM) for vehicle attitude; 1 = DCM(1,1),
%                            2 = DCM(1,2), 3 = DCM(1,3),
%                            4 = DCM(2,1), et cetera
%
%
%   OUTPUTS
%       deltheta = profile of three orthogonal gyro outputs (body
%                  motion only) over time; for the i-th flight path
%                  segment, deltheta(i,1) = x-gyro output (nose positive),
%                  deltheta(i,2) = y-gyro output (right wing positive),
%                  deltheta(i,3) = z-gyro output (down positive)
%

%   REFERENCE:  Titterton, D. and J. Weston, STRAPDOWN
%               INERTIAL NAVIGATION TECHNOLOGY, Peter
%               Peregrinus Ltd. on behalf of the Institution
%               of Electrical Engineers, London, 1997, pp. 42-43.
%
%	M. & S. Braasch 1-98
%	Copyright (c) 1997-98 by GPSoft
%	All Rights Reserved.
%

if nargin<1,error('insufficient number of input arguments'),end
nT=size(DCMnb_prof,1)-1;
deltathe=zeros(nT,1);
deltapsi=zeros(nT,1);
deltaphi=zeros(nT,1);
for k = 2:nT
  dcmnb2=[DCMnb_prof(k,1:3); DCMnb_prof(k,4:6); DCMnb_prof(k,7:9)];
  dcmnb1=[DCMnb_prof(k-1,1:3); DCMnb_prof(k-1,4:6); DCMnb_prof(k-1,7:9)];
  del_PSI = dcmnb1 * dcmnb2';% - eye(3); % 22 Septemebr 2020 exact transform instead of approximation
  eulvec=dcm2eulr(del_PSI);
  deltapsi(k-1,1) = yawprog(eulvec(3),del_PSI(2,1));
  deltathe(k-1,1) = yawprog(eulvec(2),del_PSI(1,3));
  deltaphi(k-1,1) = yawprog(eulvec(1),del_PSI(3,2));
end
deltheta = [deltaphi deltathe deltapsi];