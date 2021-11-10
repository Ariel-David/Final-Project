function [ phiTetaPsi_t1_est , t_t1_est , phiTetaPsi_12_est , t_12_est, sigmaF,normsVecT_new, normsVecR_new ] = ...
    iterate( phiTetaPsi_t1_0, t_t1_0, phiTetaPsi_12_0, t_12_0, ...
    ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2 ,...
    minIterations, maxIterations, minDeltaT, minDeltaR, ...
    M_estimator, sigmaI,sigmaH,normsVecT, normsVecR,P_plusXYZFI,DeltaGraund,indk,maxIterationNum,minError,MaxFunEvalsval,max_procent_val)

%the init guess of the params:
phiTetaPsi_t1_i = phiTetaPsi_t1_0;
t_t1_i = t_t1_0;
phiTetaPsi_12_i = phiTetaPsi_12_0;
t_12_i = t_12_0;

lastParamsT = [ t_t1_i ;  t_12_i];
lastParamsR = [ phiTetaPsi_t1_i ; phiTetaPsi_12_i ];
iterationNum=1;
                                               
[SSX SSY valeps1 procent_val1] = Checking_prog( phiTetaPsi_t1_i, t_t1_i, phiTetaPsi_12_i, t_12_i, ...
    ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2,sigmaI );

sigmaI
valeps1
procent_val1

while (  (iterationNum <= maxIterations) & ...
        ( ( iterationNum <= minIterations ) | ...
        ( norm(lastParamsT-[t_t1_i;t_12_i]) > minDeltaT) | ...
        ( norm(lastParamsR-[phiTetaPsi_t1_i;phiTetaPsi_12_i]) > minDeltaR ) ...
        )  )
    
    lastParamsT = [ t_t1_i ;  t_12_i];
    lastParamsR = [ phiTetaPsi_t1_i ; phiTetaPsi_12_i ];
    
    [ phiTetaPsi_t1_i , t_t1_i , phiTetaPsi_12_i , t_12_i, sigmaF, sigmaF12 ] = posesEstimationIteration_LabExp_Matlab( phiTetaPsi_t1_i, t_t1_i, ...
        phiTetaPsi_12_i, t_12_i, ...
        ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2 ,...
        M_estimator,sigmaI,sigmaH,maxIterationNum,minError,MaxFunEvalsval);
    

    if(phiTetaPsi_t1_i(1)==inf)
        disp('The algorithm does not converge at all!!!');
        break;
    end
        
    iterationNum = iterationNum+1;
end

[SSX SSY valeps procent_val] = Checking_prog( phiTetaPsi_t1_i, t_t1_i, phiTetaPsi_12_i, t_12_i, ...
    ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2,sigmaI );
sigmaI
procent_val
valeps

if(phiTetaPsi_t1_i(1)~=inf)
    [SSX SSY valeps procent_val] = Checking_prog( phiTetaPsi_t1_i, t_t1_i, phiTetaPsi_12_i, t_12_i, ...
        ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2,sigmaI );
% % %     valeps
% % %     procent_val

%    if (valeps==0)
     if (procent_val<max_procent_val)
        disp('The algorithm does not converge correctly (0)!!!');
        disp(['procent_val = ',num2str(procent_val)]);
        disp(['max_procent_val = ',num2str(max_procent_val)]);
% % %         valeps
% % %         procent_val
% % %         procent_val1
        phiTetaPsi_t1_i(1)=inf;
    end
end

if indk==1
    if(phiTetaPsi_t1_i(1)~=inf)
        
        DeltaSigma=3*sigmaI*t_t1_i(3);
        
        diagSigma=diag(sigmaF);
        deltaXYZ=sqrt(diagSigma(1:3))/DeltaSigma;
        numXYZ=length(find(deltaXYZ<=100));
        
        if (numXYZ<3)
            disp('The algorithm does not converge correctly (1)!!!');
            phiTetaPsi_t1_i(1)=inf;
        end
    end
    
    if(phiTetaPsi_t1_i(1)~=inf)
        
        DeltaSigma=3*sigmaI;
        
        diagSigma=diag(sigmaF);
        deltaXYZ=sqrt(diagSigma(4:6))/DeltaSigma;
        numXYZ=length(find(deltaXYZ<=100));
        
        if (numXYZ<3)
            disp('The algorithm does not converge correctly (2)!!!');
            phiTetaPsi_t1_i(1)=inf;
        end
    end
    
    if(phiTetaPsi_t1_i(1)~=inf)
        
        diagSigma=diag(sigmaF12);
        deltaXYZ=sqrt(diagSigma(10:12));
        numXYZ=length(find(deltaXYZ<=0.1*norm(t_12_i)));
        
        if (numXYZ<3)
            disp('The algorithm does not converge correctly (3)!!!');
            phiTetaPsi_t1_i(1)=inf;
        end
    end
    
    if(phiTetaPsi_t1_i(1)~=inf)
        
        diagSigma=diag(sigmaF12);
        deltaXYZ=sqrt(diagSigma(7:9));
        numXYZ=length(find(deltaXYZ<=0.1*norm(t_12_i)/t_t1_i(3)));
        
        if (numXYZ<3)
            disp('The algorithm does not converge correctly (4)!!!');
            phiTetaPsi_t1_i(1)=inf;
        end
    end
    
    if(phiTetaPsi_t1_i(1)~=inf)

        diagSigma=diag(sigmaF);
        deltaXYZ=sqrt(diagSigma(1:3));
        numXYZ=length(find(deltaXYZ<=DeltaGraund));
        
        if (numXYZ<3)
            disp('The algorithm does not converge correctly (5)!!!');
            phiTetaPsi_t1_i(1)=inf;
        end
    end
    
    if(phiTetaPsi_t1_i(1)~=inf)

        diagSigma=diag(sigmaF);
        deltaXYZ=sqrt(diagSigma(4:6));
        numXYZ=length(find(deltaXYZ<=DeltaGraund/t_t1_i(3)));
        if (numXYZ<3)
            disp('The algorithm does not converge correctly (6)!!!');
            phiTetaPsi_t1_i(1)=inf;
        end
    end
    
    phiTetaPsi_t1_est(1)=yawprog(phiTetaPsi_t1_i(1),phiTetaPsi_t1_0(1));
    phiTetaPsi_t1_est(2)=yawprog(phiTetaPsi_t1_i(2),phiTetaPsi_t1_0(2));
    phiTetaPsi_t1_est(3)=yawprog(phiTetaPsi_t1_i(3),phiTetaPsi_t1_0(3));
    phiTetaPsi_t1_d=abs(phiTetaPsi_t1_0  - phiTetaPsi_t1_est');
    
    t_t1_d=abs(t_t1_0 - t_t1_i);
    
    phiTetaPsi_12_est(1)=yawprog(phiTetaPsi_12_i(1),phiTetaPsi_12_0(1));
    phiTetaPsi_12_est(2)=yawprog(phiTetaPsi_12_i(2),phiTetaPsi_12_0(2));
    phiTetaPsi_12_est(3)=yawprog(phiTetaPsi_12_i(3),phiTetaPsi_12_0(3));
    phiTetaPsi_12_d=abs(phiTetaPsi_12_0 - phiTetaPsi_12_est');
    
    t_12_d=abs(t_12_0 - t_12_i);
    
    if(phiTetaPsi_t1_i(1)~=inf)
        
        
        
        diagSigma=diag(sigmaF);
        deltaXYZ=sqrt(diagSigma(1:3));
        numXYZ=length(find(3*(P_plusXYZFI(1:3)'+deltaXYZ)>t_t1_d));
        if (numXYZ<3)
            P_plusXYZFI(1:3)
% % %             t_t1_d
% % %             t_t1_0
% % %             t_t1_i
            disp('The algorithm does not converge correctly (7)!!!');
            phiTetaPsi_t1_i(1)=inf;
        end
    end
    
    if(phiTetaPsi_t1_i(1)~=inf)
        
        diagSigma=diag(sigmaF);
        deltaFi=sqrt(diagSigma(4:6));
        numXYZ=length(find(3*(P_plusXYZFI(4:6)'+ deltaFi)>phiTetaPsi_t1_d));
        if (numXYZ<3)
            disp('The algorithm does not converge correctly (8)!!!');
            phiTetaPsi_t1_i(1)=inf;
        end
    end
    
    if(phiTetaPsi_t1_i(1)~=inf)
        numXYZ=length(find(t_12_d<=0.1*norm(t_12_i)));
        
        if (numXYZ<3)
            disp('The algorithm does not converge correctly (9)!!!');
            phiTetaPsi_t1_i(1)=inf;
        end
    end
    
    
    
    if(phiTetaPsi_t1_i(1)~=inf) 
        diagSigma=diag(sigmaF12);
        deltaXYZ=sqrt(diagSigma(7:9));
        numXYZ=length(find(phiTetaPsi_12_d<=0.1*norm(t_12_i)/t_t1_i(3)));
        if (numXYZ<3)
            disp('The algorithm does not converge correctly (10)!!!');
            phiTetaPsi_t1_i(1)=inf;
        end
    end
end


%final results:
phiTetaPsi_t1_est = phiTetaPsi_t1_i;
t_t1_est = t_t1_i;
phiTetaPsi_12_est = phiTetaPsi_12_i;
t_12_est = t_12_i;

normsVecT_new = normsVecT;
normsVecR_new = normsVecR;

return;