function [phiTetaPsi_t1 , t_t1 , phiTetaPsi_t2 , t_t2, sigmaF] = ...
    calcFrameCouplePoses( phiTetaPsi_0_t1, t_0_t1, phiTetaPsi_0_t2, t_0_t2, ...
    beforeMovment_q_Cam, afterMovment_q_Cam,sigmaI,sigmaH,P_plus,DeltaGraund,indk,...
    minIterations,maxIterations,minDeltaT,minDeltaR,normsVecT,normsVecR,maxIterationNum,minError,MaxFunEvalsval,max_procent_val)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Block 1 s %%%%%%%%%%%%%%%%%%%%%%%%%
%%% definition input%%%%%%%%%%%%%%%%
global DTM
% deltaTmp=DTM.delta;
% DTM.delta=1;
t_0_t1=t_0_t1/DTM.delta;
t_0_t2=t_0_t2/DTM.delta;
sigmaH=sigmaH/DTM.delta;
DeltaGraund=DeltaGraund/DTM.delta;

P_plus_new=sqrt(diag(P_plus));
P_plusXYZFI(1:3)=P_plus_new(1:3)/DTM.delta;
P_plusXYZFI(4:6)=P_plus_new(7:9);

P_plus=P_plus/DTM.delta^2;

R1 = createRfromAngles(phiTetaPsi_0_t1(1), phiTetaPsi_0_t1(2), phiTetaPsi_0_t1(3) );
t1 = t_0_t1;
T1 = [R1, t1 ; [0 0 0 1] ];
R2 = createRfromAngles(phiTetaPsi_0_t2(1), phiTetaPsi_0_t2(2), phiTetaPsi_0_t2(3) );
t2 = t_0_t2;
T2inv = [R2', -R2'*t2 ; [0 0 0 1] ];

T12 = T2inv*T1;

phiTetaPsi_0_12 = extractEulerAngles(T12(1:3,1:3));
phiTetaPsi_0_12(3)=yawprog(phiTetaPsi_0_12(3),0);
phiTetaPsi_0_12(1)=yawprog(phiTetaPsi_0_12(1),0);

t_0_12 = T12(1:3,4);

qs_C_t1 = beforeMovment_q_Cam;
qs_C_t2 = afterMovment_q_Cam;
ss_C_t1 = zeros(size(qs_C_t1)) ;
ss_C_t2 = zeros(size(qs_C_t2)) ;
%%%%%%%%%%%%%%%%%%%%%% Block 1 f %%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Block 2 s %%%%%%%%%%%%%%%%%%%%%%
[ phiTetaPsi_t1 , t_t1 , phiTetaPsi_12 , t_12, sigmaF ] = estimatePoses_LabExp( phiTetaPsi_0_t1, t_0_t1, ...
    phiTetaPsi_0_12, t_0_12, ...
    ss_C_t1, qs_C_t1, ...
    ss_C_t2, qs_C_t2 , ...
    'Geman-McClure',sigmaI,sigmaH,P_plusXYZFI,DeltaGraund,indk,minIterations,maxIterations,minDeltaT,minDeltaR,normsVecT,normsVecR,maxIterationNum,minError,MaxFunEvalsval,max_procent_val);
%%%%%%%%%%%%%%%%%%%%%% Block 2 f %%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Block 3 s %%%%%%%%%%%%%%%%%%%%%%
%%% definition output%%%%%%%%%%%%%%%%
R1 = createRfromAngles(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3) );
t1 = t_t1;
T1 = [R1, t1 ; [0 0 0 1] ];
R12 = createRfromAngles(phiTetaPsi_12(1), phiTetaPsi_12(2), phiTetaPsi_12(3) );
t12 = t_12;
T12inv = [R12', -R12'*t12 ; [0 0 0 1] ];

T2 = T1*T12inv;
phiTetaPsi_t2 = extractEulerAngles(T2(1:3,1:3));
phiTetaPsi_t2(3)=yawprog(phiTetaPsi_t2(3),phiTetaPsi_0_t2(3));
phiTetaPsi_t2(1)=yawprog(phiTetaPsi_t2(1),phiTetaPsi_0_t2(1));
t_t2 = T2(1:3,4);
t_t1=t_t1*DTM.delta;
t_t2=t_t2*DTM.delta;

if(sigmaF~=inf)
    sigmaF(1:3,1:3)=sigmaF(1:3,1:3)*DTM.delta^2;
    sigmaF(1:3,4:6)=sigmaF(1:3,4:6)*DTM.delta;
    sigmaF(4:6,1:3)=sigmaF(4:6,1:3)*DTM.delta;
end
%%%%%%%%%%%%%%%%%%%%%% Block 3 f %%%%%%%%%%%%%%%%%%%%%%
% DTM.delta=deltaTmp;
return;






