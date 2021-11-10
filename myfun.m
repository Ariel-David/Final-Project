function [F,J]  = myfun(x)
global ss_C_t1g 
global qs_C_t1g 
global ss_C_t2g 
global qs_C_t2g  
global Nsg 
global Qes_Wg 
global M_estimatorg

[Jp,F] = calc_J_and_f_new( x(1:3), x(4:6), x(7:9), x(10:12), ss_C_t1g, qs_C_t1g, ss_C_t2g, qs_C_t2g , Nsg, Qes_Wg );
%weights calculation using M-estimator: 
    residuals = -F;
    resNorms = sqrt( residuals(1:3:end).^2 + residuals(2:3:end).^2 + residuals(3:3:end).^2 );
	weightsVec = calcMestimatorWeights(resNorms, M_estimatorg);
    fullWeightsVec(1:3:3*length(weightsVec)) = weightsVec;
    fullWeightsVec(2:3:3*length(weightsVec)) = weightsVec;
    fullWeightsVec(3:3:3*length(weightsVec)) = weightsVec;
    W = diag(fullWeightsVec);
F=W*F;
if nargout > 1   % Two output arguments
J=W*Jp;
end
return