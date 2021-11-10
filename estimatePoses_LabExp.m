function [ phiTetaPsi_t1_est , t_t1_est , phiTetaPsi_12_est , t_12_est, sigmaF ] = estimatePoses_LabExp( phiTetaPsi_t1_0, t_t1_0, ...
    phiTetaPsi_12_0, t_12_0, ...
    ss_C_t1, qs_C_t1, ...
    ss_C_t2, qs_C_t2 , ...
    M_estimator,sigmaI,sigmaH,P_plusXYZFI,DeltaGraund,indk,minIterations,maxIterations,minDeltaT,minDeltaR,normsVecT,normsVecR,maxIterationNum,minError,MaxFunEvalsval,max_procent_val)

DeltaSigmaXYZ=P_plusXYZFI(1:3);
DeltaSigmaFi=P_plusXYZFI(4:6);

if indk==1
    if( 3*max(DeltaSigmaXYZ)>DeltaGraund)
        phiTetaPsi_t1_0(1)=inf;
        phiTetaPsi_t1_est = phiTetaPsi_t1_0;
        t_t1_est = t_t1_0;
        phiTetaPsi_12_est = phiTetaPsi_12_0;
        t_12_est = t_12_0;
        sigmaF=inf;
        disp('The algorithm can not converge correctly (00)!!!');
    elseif ( 3*max(DeltaSigmaFi)>DeltaGraund/t_t1_0(3))
        phiTetaPsi_t1_0(1)=inf;
        phiTetaPsi_t1_est = phiTetaPsi_t1_0;
        t_t1_est = t_t1_0;
        phiTetaPsi_12_est = phiTetaPsi_12_0;
        t_12_est = t_12_0;
        sigmaF=inf;
        disp('The algorithm can not converge correctly (11)!!!');
    else
%         normsVecT = 0;
%         normsVecR = 0;
        disp(' ');
%         minIterations = 6; %5;  %3;
%         maxIterations = 6; %10; %6;
%         minDeltaT = 0.01;
%         minDeltaR = 0.001;
        [ phiTetaPsi_t1_est , t_t1_est , phiTetaPsi_12_est , t_12_est, sigmaF, normsVecT, normsVecR ] = ...
            iterate( phiTetaPsi_t1_0, t_t1_0, phiTetaPsi_12_0, t_12_0, ...
            ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2 , ...
            minIterations, maxIterations, minDeltaT, minDeltaR, ...
            M_estimator, sigmaI,sigmaH,normsVecT, normsVecR,P_plusXYZFI,DeltaGraund,indk,maxIterationNum,minError,MaxFunEvalsval,max_procent_val);
        
    end
else
%     normsVecT = 0;
%     normsVecR = 0;
    disp(' ');
%     minIterations = 6; %5;  %3;
%     maxIterations = 6; %10; %6;
%     minDeltaT = 0.01;
%     minDeltaR = 0.001;
    [ phiTetaPsi_t1_est , t_t1_est , phiTetaPsi_12_est , t_12_est, sigmaF, normsVecT, normsVecR ] = ...
        iterate( phiTetaPsi_t1_0, t_t1_0, phiTetaPsi_12_0, t_12_0, ...
        ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2 , ...
        minIterations, maxIterations, minDeltaT, minDeltaR, ...
        M_estimator, sigmaI,sigmaH,normsVecT, normsVecR,P_plusXYZFI,DeltaGraund,indk,maxIterationNum,minError,MaxFunEvalsval,max_procent_val);
end
return;