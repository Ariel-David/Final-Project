function [ phiTetaPsi_t1_est , t_t1_est , phiTetaPsi_12_est , t_12_est, sigmaF,sigmaF12] = posesEstimationIteration_LabExp_Matlab( phiTetaPsi_t1_0, t_t1_0, ...
    phiTetaPsi_12_0, t_12_0, ...
    ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2 ,...
    M_estimator,sigmaI,sigmaH,maxIterationNum,minError,MaxFunEvalsval)
% maxIterationNum = 60;
% minError = 10^-10;
% MaxFunEvalsval=10000;
[ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2, Ns, Qes_W] = intersect_qs_with_smoothDTM(phiTetaPsi_t1_0, t_t1_0, phiTetaPsi_12_0, t_12_0, ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2);
global ss_C_t1g
global qs_C_t1g
global ss_C_t2g
global qs_C_t2g
global Nsg
global Qes_Wg
global M_estimatorg
global DTM
Ndef=size(qs_C_t1,2);

M_estimatorg=M_estimator;
ss_C_t1g=ss_C_t1;
qs_C_t1g=qs_C_t1;
ss_C_t2g=ss_C_t2;
qs_C_t2g=qs_C_t2;
Nsg=Ns;
Qes_Wg=Qes_W;
thcond=eps;

disp( strcat('# of actual used grid-points: ', num2str(size(qs_C_t1, 2)) ) );

if(size(qs_C_t1,2)<7)%not enough rays intersect with the DTM
    phiTetaPsi_t1_est = [inf;inf;inf];
    t_t1_est = [inf;inf;inf];
    phiTetaPsi_12_est = [inf;inf;inf];
    t_12_est = [inf;inf;inf];
    sigmaF=inf;
    sigmaF12=inf;
    return;
end

%calc the true f: v^
V = zeros(3*size(qs_C_t2,2), 1);

%init guess:
phiTetaPsi_t1 = phiTetaPsi_t1_0;
t_t1 = t_t1_0;
phiTetaPsi_12 = phiTetaPsi_12_0;
t_12 = t_12_0;

R=createRfromAngles(phiTetaPsi_t1(1),phiTetaPsi_t1(2),phiTetaPsi_t1(3));
phiTetaPsi_t1_1=extractEulerAngles_old(R);
R=createRfromAngles(phiTetaPsi_12(1),phiTetaPsi_12(2),phiTetaPsi_12(3));
phiTetaPsi_12_1=extractEulerAngles_old(R);
phiTetaPsi_12_1(3)=yawprog(phiTetaPsi_12_1(3),0);
phiTetaPsi_12_1(1)=yawprog(phiTetaPsi_12_1(1),0);
%stoping conditions:
% maxIterationNum = 60;
% minError = 10^-10;
% MaxFunEvalsval=10000;

error = minError+1;

%Newton-iterations:
iterationsNum = 0;
x0=[phiTetaPsi_t1_1; t_t1; phiTetaPsi_12_1; t_12];
lb(1:12)=-inf;
ub(1:12)=inf;
options = optimset('Display','off','Diagnostics','off','MaxIter',maxIterationNum,'MaxFunEvals',MaxFunEvalsval,'TolX',minError,'TolFun',minError,'Jacobian', 'on');
resnorm0=norm(myfun(x0))/Ndef;
Fbegin=norm(myfun(x0));
[delta,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(@myfun,x0,lb,ub,options);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
exitflag;
output.algorithm;
output.iterations;
options.MaxIter;
output.funcCount;
options.MaxFunEvals;
Fend=norm(myfun(delta));
resnorm1=sqrt(resnorm)/Ndef;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phiTetaPsi_t1_1 =  delta(1:3);
t_t1 = delta(4:6);
phiTetaPsi_12_1 =  delta(7:9);
t_12 =  delta(10:12);

JD = calc_J_D_new(phiTetaPsi_t1_1, t_t1, phiTetaPsi_12_1, t_12, ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2 , Ns, Qes_W  );
sigmaB=sigmaBig(phiTetaPsi_t1_1, t_t1, phiTetaPsi_12_1, t_12, ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2 , Ns, Qes_W ,sigmaI,sigmaH);
[J,F] = calc_J_and_f_new( delta(1:3), delta(4:6), delta(7:9), delta(10:12), ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2 , Ns, Qes_W );
residuals = -F;
resNorms = sqrt( residuals(1:3:end).^2 + residuals(2:3:end).^2 + residuals(3:3:end).^2 );
weightsVec = calcMestimatorWeights(resNorms, M_estimator);
fullWeightsVec(1:3:3*length(weightsVec)) = weightsVec;
fullWeightsVec(2:3:3*length(weightsVec)) = weightsVec;
fullWeightsVec(3:3:3*length(weightsVec)) = weightsVec;
W = diag(fullWeightsVec);
JT=inv(J'*W*J) * (J'*W);
rcondd=rcond(J'*W*J);
if rcondd<thcond
    % % %         rcondd
    phiTetaPsi_t1_est = [inf;inf;inf];
    t_t1_est = [inf;inf;inf];
    phiTetaPsi_12_est = [inf;inf;inf];
    t_12_est = [inf;inf;inf];
    sigmaF=inf;
    sigmaF12=inf;
    return;
end
J2 = calc_J_2(phiTetaPsi_t1_1, t_t1, phiTetaPsi_12_1, t_12 );
DJD=JD*sigmaB*JD.';
sigmaF=J2*JT*DJD*JT.'*J2.';

%final results:
R=createRfromAngles_old(phiTetaPsi_12_1(1),phiTetaPsi_12_1(2),phiTetaPsi_12_1(3));
phiTetaPsi_12=extractEulerAngles(R);
R=createRfromAngles_old(phiTetaPsi_t1_1(1),phiTetaPsi_t1_1(2),phiTetaPsi_t1_1(3));
phiTetaPsi_t1=extractEulerAngles(R);

phiTetaPsi_t1_est = phiTetaPsi_t1;
t_t1_est = t_t1;
phiTetaPsi_12_est = phiTetaPsi_12;
t_12_est = t_12;

phiTetaPsi_t1_est(3)=yawprog(phiTetaPsi_t1_est(3),phiTetaPsi_t1_0(3));
phiTetaPsi_12_est(3)=yawprog(phiTetaPsi_12_est(3),phiTetaPsi_12_0(3));
phiTetaPsi_t1_est(1)=yawprog(phiTetaPsi_t1_est(1),phiTetaPsi_t1_0(1));
phiTetaPsi_12_est(1)=yawprog(phiTetaPsi_12_est(1),phiTetaPsi_12_0(1));

% % % phiTetaPsi_t1_est
t_t1_est_full=t_t1_est*DTM.delta;
% % % phiTetaPsi_12_est
t_12_est_full=t_12_est*DTM.delta;

[SSX SSY valeps procent_val] = Checking_prog( phiTetaPsi_t1, t_t1, phiTetaPsi_12, t_12, ...
    ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2 ,sigmaI );
% SSX=0;
% SSY=0;
% sigmaH=0;
sigmaB=sigmaBig_new(phiTetaPsi_t1, t_t1, phiTetaPsi_12, t_12, ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2 , Ns, Qes_W ,max(SSX,SSY),sigmaH);
DJD=JD*sigmaB*JD.';
sigmaF12=JT*DJD*JT.';
sigmaF=J2*sigmaF12*J2.';

return;

