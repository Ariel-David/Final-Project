function sigmaB=sigmaBig_new(phiTetaPsi_t1, p1, phiTetaPsi_12, p12, ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2, Ns, Ges_W,sigmaI,sigmaH)
R1 = createRfromAngles(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3));

sizem=size(qs_C_t2,2);
                                               
sigmaB=zeros(6*sizem,6*sizem);
for i=1:sizem

    q1 = qs_C_t1(:,i);
    N = Ns(:,i)/Ns(3,i);
    
    sigmaB(3*(i-1)+1,3*(i-1)+1)=(sigmaI)^2;
    sigmaB(3*(i-1)+2,3*(i-1)+2)=(sigmaI)^2;
    
    sigmaB(3*sizem+3*(i-1)+1:3*sizem+3*i,3*sizem+3*(i-1)+1:3*sizem+3*i)=sigmaH^2*R1*q1*q1.'*R1.'/(N.'*R1*q1)^2;

end                          
                           
return;
