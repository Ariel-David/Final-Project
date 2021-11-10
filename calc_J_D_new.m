function JD = calc_J_D_new(phiTetaPsi_t1, p1, phiTetaPsi_12, p12, ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2, Ns, Ges_W )
R1 = createRfromAngles_old(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3));

R12 = createRfromAngles_old(phiTetaPsi_12(1), phiTetaPsi_12(2), phiTetaPsi_12(3));
sizem=size(qs_C_t2,2);
                                               
J = zeros(6*sizem,6*sizem);

for i=1:sizem
        
    Ge = Ges_W(:,i);
    s1 = ss_C_t1(:,i);
    q1 = qs_C_t1(:,i);
    s2 = ss_C_t2(:,i);
    q2 = qs_C_t2(:,i);
    N = Ns(:,i);
    
    
    L = (1/(N'*R1*q1)) * q1*N';
   
    GC2=p12+R12*( L*(Ge-R1*s1-p1) + s1 )- s2;
    
    P_q2_q2 = P(q2,q2);
    P_G_G=P(GC2,GC2);
    NG=norm(GC2);
    NP_G_G=P_G_G/NG;
    
   Jq2=-1/norm(q2)^2*(q2.'*GC2*eye(3)+q2*GC2.')*P_q2_q2/NG;
   JGE = P_q2_q2*NP_G_G*R12*L;
   
   JD(3*(i-1)+1:3*i,3*(i-1)+1:3*i)=Jq2;
   JD(3*(i-1)+1:3*i,3*sizem+3*(i-1)+1:3*sizem+3*i)=JGE;
    
    
end                          
                           
return;

function Pmat = P(u,s)

Pmat = eye(3) - (u*s')/(s'*u);

return;