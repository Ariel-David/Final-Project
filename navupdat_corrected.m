function [DCMel, DCM_ll_E] = navupdat_corrected(omega1_el_L,omega2_el_L,td12,DCMel,procflg)
%NAVUPDAT      Update the direction cosine matrix relating the 
%              local-level frame relative to the earth frame
%
%	[DCMel, DCM_ll_E] = navupdat(omega1_el_L,omega2_el_L,td12,DCMel,procflg)
%
%   INPUTS
%       omega2_el_L = craft-rate vector at current time
%       omega1_el_L = craft-rate vector at previous position update
%       td12 = time difference (in seconds) between time indices 1 and 2
%              (this is a positive number; i.e., td12 = time2 - time1)
%       DCMel = 3x3 direction cosine matrix providing the
%             transformation from the earth frame
%             to the local-level (ENU) frame
%       procflg = processing flag; 0=first order approximation; 1=exact solution
%
%   OUTPUTS
%       DCMel = updated earth-to-local-level direction cosine matrix
%       DCM_ll_E = direction cosine matrix relating the local-level frame
%                  at the end of the update interval to the local-level
%                  frame at the beginning of the update interval
%                  (relative to the earth frame)
%

%	M. & S. Braasch 6-98
%	Copyright (c) 1998 by GPSoft LLC
%	All Rights Reserved.
%

if nargin<5,error('insufficient number of input arguments'),end
C = [0 1 0; 1 0 0; 0 0 -1];    % conversion between NED and ENU

omega_avg = 0.5*( omega1_el_L + omega2_el_L );
ang_vect = omega_avg*td12;
DCM_ll_E=eulr2dcm(ang_vect); % 23 Septemebr 2020 exact transform instead of approximation

DCMel = DCM_ll_E*DCMel;