function weightsVec = calcMestimatorWeights(resNorms, M_estimator)

%calculate the normalized residual for each point, using MAD(Median
%of Absolute Deviations) as a normalizing factor
MAD = median(resNorms);
Nres = resNorms/MAD;

weightsVec = [];
if(strcmpi(M_estimator,'Huber')==1)
    k = 1.345;
    weightsVec = (Nres <= k)*1 + (Nres > k).*(k./Nres);
    
elseif(strcmpi(M_estimator,'Geman-McClure')==1)
    weightsVec = 1 ./ ( 1+Nres.^2 ).^2;
    
elseif(strcmpi(M_estimator,'Welsch')==1)   
    k = 1.5;
    weightsVec = exp( -(Nres./k).^2 );
    
elseif(strcmpi(M_estimator,'Tukey')==1)
    k = 1.3;
    weightsVec = (Nres <= k) .* ( 1-(Nres./k).^2 ).^2 ;
else
    weightsVec = ones(size(Nres));
end

return;