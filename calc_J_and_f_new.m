function [J,f] = calc_J_and_f_new(phiTetaPsi_t1, p1, phiTetaPsi_12, p12, ss_C_t1, qs_C_t1, ss_C_t2, qs_C_t2, Ns, Ges_W )

R1 = createRfromAngles_old(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3));
DR1_Dphi = create_DR_Dphi(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3));
DR1_Dteta = create_DR_Dtheta(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3));
DR1_Dpsi = create_DR_Dpsi(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3));

R12 = createRfromAngles_old(phiTetaPsi_12(1), phiTetaPsi_12(2), phiTetaPsi_12(3));
DR12_Dphi = create_DR_Dphi(phiTetaPsi_12(1), phiTetaPsi_12(2), phiTetaPsi_12(3));
DR12_Dteta = create_DR_Dtheta(phiTetaPsi_12(1), phiTetaPsi_12(2), phiTetaPsi_12(3));
DR12_Dpsi = create_DR_Dpsi(phiTetaPsi_12(1), phiTetaPsi_12(2), phiTetaPsi_12(3));
                                               
J = [];
f = [];
dist=[];
for i=1:size(Ges_W,2)
        
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
    
    Df_Dphi1  = -P_q2_q2 *NP_G_G* R12 * L * DR1_Dphi  * ( L*(Ge-R1*s1-p1) + s1 );
    Df_Dteta1 = -P_q2_q2 *NP_G_G* R12 * L * DR1_Dteta * ( L*(Ge-R1*s1-p1) + s1 );
    Df_Dpsi1  = -P_q2_q2 *NP_G_G* R12 * L * DR1_Dpsi  * ( L*(Ge-R1*s1-p1) + s1 );
    
    Df_Dp1 = -P_q2_q2*NP_G_G * R12 * L;
    
    Df_Dphi12  = P_q2_q2 *NP_G_G* DR12_Dphi  * ( L*(Ge-R1*s1-p1) + s1 );
    Df_Dteta12 = P_q2_q2 *NP_G_G* DR12_Dteta * ( L*(Ge-R1*s1-p1) + s1 );
    Df_Dpsi12  = P_q2_q2 *NP_G_G* DR12_Dpsi  * ( L*(Ge-R1*s1-p1) + s1 );
    
    Df_Dp12 = P_q2_q2*NP_G_G;
    
    Jfi = [Df_Dphi1, Df_Dteta1, Df_Dpsi1, Df_Dp1, Df_Dphi12, Df_Dteta12, Df_Dpsi12, Df_Dp12];
    
    J = [ J ; Jfi ];
    
    fi = P_q2_q2 * GC2/NG ;
    f = [ f ; fi ];
    
    
end                          
                           
return;




function Pmat = P(u,s)

Pmat = eye(3) - (u*s')/(s'*u);

return;


