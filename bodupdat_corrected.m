function [DCMbn_new,DCMbb] = bodupdat(DCMbn_old,ang_vect)
%BODUPDAT		Update the direction cosine matrix
%              for body motion (relative to inertial space).
%              The function is thus acting upon the strapdown
%              gyro outputs.
%
%	DCMbn_new = bodupdat(DCMbn_old,ang_vect)
%     or
%  [DCMbn_new,DCMbb] = bodupdat(DCMbn_old,ang_vect)
%
%   INPUTS
%       DCMbn_old  = current direction cosine matrix providing the
%                    transformation from body to nav coordinates
%
%       ang_vect = incremental integral of body angular
%                  rate vector; in the absence of coning
%                  (i.e., angular rate vector is constant
%                  over the integration interval), this
%                  is the output of the rate-integrating
%                  gyros.
%          ang_vect(1) = x-component (roll);
%          ang_vect(2) = y-component (pitch);
%          ang_vect(3) = z-component (yaw);
%
%   OUTPUTS
%       DCMbn_new = updated direction cosine matrix relating the
%                   current body-frame to the previous
%                   navigation-frame.  Note that the update of
%                   the navigation frame (which is related to
%                   the local-level frame) is accomplished in
%                   function LCLEVUPD
%
%       DCMbb = direction cosine matrix providing the
%               transformation from the body coordinates at
%               time k+1 to the body coordinates at time k
%

%	M. & S. Braasch 4-98
%	Copyright (c) 1997-98 by GPSoft LLC
%	All Rights Reserved.
%

if nargin<2,error('insufficient number of input arguments'),end
%       S = [   0      -sigma_z  sigma_y;
%             sigma_z     0     -sigma_x;
%            -sigma_y  sigma_x    0     ]
% S = skewsymm(ang_vect); 
% magn = norm(ang_vect);
DCMbb=eulr2dcm(ang_vect); % 22 Septemebr 2020 exact transform instead of approximation
DCMbb=DCMbb';
% if magn == 0,
%     DCMbb = eye(3);
% else,
%     DCMbb = eye(3) + (sin(magn)/magn)*S + ( (1-cos(magn))/magn^2 )*S*S;
%     %DCMbb = eye(3) + S;
% end

DCMbn_new = DCMbn_old*DCMbb;
return;
%  del_PSI = dcmnb1 * dcmnb2' - eye(3);
%   deltapsi(k-1,1) = del_PSI(2,1);
%   deltathe(k-1,1) = del_PSI(1,3);
%   deltaphi(k-1,1) = del_PSI(3,2);
del_PSI=eye(3);
del_PSI(3,2)=ang_vect(1);
del_PSI(2,3)=-del_PSI(3,2);
del_PSI(1,3)=ang_vect(2);
del_PSI(3,1)=-del_PSI(1,3);
del_PSI(2,1)=ang_vect(3);
del_PSI(1,2)=-del_PSI(2,1);
DCMbn_new=DCMbn_old*del_PSI;
