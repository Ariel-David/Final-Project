function dtherr = gentherr_step(deltath,tdvec,errparam)
%GENTHERR		Delta-theta error generator. 
%       
%	dtherr = gentherr(deltath,time,errparam,dthseed)
%
%   INPUTS
%       deltath = profile of ideal rate-integrating gyro 
%                 outputs over time
%         deltath(i,1:3) = for the i-th flight path segment,
%                          deltath(i,1) is the x gyro data
%                          (nose positive); deltath(i,2) is the y
%                          gyro data (right wing positive);
%                          deltath(i,3) is the z gyro data
%                          (down is positive)
%
%      
%       errparam = error parameter matrix
%                  errparam(1,1) = x gyro bias (in rad per sec)
%                  errparam(1,2) = y gyro bias (in rad per sec)
%                  errparam(1,3) = z gyro bias (in rad per sec)
%                  errparam(2,1) = x gyro scale factor error (in percent)
%                  errparam(2,2) = y gyro scale factor error (in percent)
%                  errparam(2,3) = z gyro scale factor error (in percent)
%                  
%
%       
%
%   OUTPUTS
%       dtherr = profile of delta-theta errors 
%                (in body frame: Nose-Rt.Wing-Down)
%

%	M. & S. Braasch 7-98
%	Copyright (c) 1998 by GPSoft
%	All Rights Reserved.
%

dph2rps = (pi/180)/3600;   % conversion constant from deg/hr to rad/sec

dprh2rprs = (pi/180)/sqrt(3600);  % conversion factor going from
%                                 % degrees-per-root-hour to
%                                 % radians-per-root-second




xbias = tdvec*errparam(1,1);
ybias = tdvec*errparam(1,2);
zbias = tdvec*errparam(1,3);
xsferr = deltath(:,1)*errparam(2,1)*0.01;
ysferr = deltath(:,2)*errparam(2,2)*0.01;
zsferr = deltath(:,3)*errparam(2,3)*0.01;


dtherr = [xbias+xsferr ybias+ysferr zbias+zsferr];
