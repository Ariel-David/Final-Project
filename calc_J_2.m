function J2 = calc_J_2(phiTetaPsi_t1, p1, phiTetaPsi_12, p12 )

R1 = createRfromAngles_old(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3));
DR1_Dphi = create_DR_Dphi(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3));
DR1_Dteta = create_DR_Dtheta(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3));
DR1_Dpsi = create_DR_Dpsi(phiTetaPsi_t1(1), phiTetaPsi_t1(2), phiTetaPsi_t1(3));

R12 = createRfromAngles_old(phiTetaPsi_12(1), phiTetaPsi_12(2), phiTetaPsi_12(3));
DR12_Dphi = create_DR_Dphi(phiTetaPsi_12(1), phiTetaPsi_12(2), phiTetaPsi_12(3));
DR12_Dteta = create_DR_Dtheta(phiTetaPsi_12(1), phiTetaPsi_12(2), phiTetaPsi_12(3));
DR12_Dpsi = create_DR_Dpsi(phiTetaPsi_12(1), phiTetaPsi_12(2), phiTetaPsi_12(3));

R2=R1*R12.';
DR2_Dphi =DR1_Dphi *R12.'; 
DR2_Dteta =DR1_Dteta *R12.';
DR2_Dpsi =DR1_Dpsi *R12.';
DR2_Dphi12 =R1*DR12_Dphi.'; 
DR2_Dteta12 =R1*DR12_Dteta.';
DR2_Dpsi12 =R1*DR12_Dpsi.';

J2=zeros(6,12);

J2(1:3,4:6)=eye(3);

J2(1:3,1)=-(DR1_Dphi*R12.')*p12;
J2(1:3,2)=-(DR1_Dteta*R12.')*p12;
J2(1:3,3)=-(DR1_Dpsi*R12.')*p12;

J2(1:3,10:12)=-R1*R12.';

J2(1:3,7)=-(R1*DR12_Dphi.')*p12;
J(1:3,8)=-(R1*DR12_Dteta.')*p12;
J(1:3,9)=-(R1*DR12_Dpsi.')*p12;


J2(4,1)=1/(1+(R2(2,3)/R2(3,3))^2)*(DR2_Dphi(2,3)*R2(3,3)-R2(2,3)*DR2_Dphi(3,3))/R2(3,3)^2;
J2(4,2)=1/(1+(R2(2,3)/R2(3,3))^2)*(DR2_Dteta(2,3)*R2(3,3)-R2(2,3)*DR2_Dteta(3,3))/R2(3,3)^2;
J2(4,3)=1/(1+(R2(2,3)/R2(3,3))^2)*(DR2_Dpsi(2,3)*R2(3,3)-R2(2,3)*DR2_Dpsi(3,3))/R2(3,3)^2;
J2(5,1)=1/sqrt(1-R2(1,3)^2)*(-DR2_Dphi(1,3));
J2(5,2)=1/sqrt(1-R2(1,3)^2)*(-DR2_Dteta(1,3));
J2(5,3)=1/sqrt(1-R2(1,3)^2)*(-DR2_Dpsi(1,3));
J2(6,1)=1/(1+(R2(1,2)/R2(1,1))^2)*(DR2_Dphi(1,2)*R2(1,1)-R2(1,2)*DR2_Dphi(1,1))/R2(1,1)^2;
J2(6,2)=1/(1+(R2(1,2)/R2(1,1))^2)*(DR2_Dteta(1,2)*R2(1,1)-R2(1,2)*DR2_Dteta(1,1))/R2(1,1)^2;
J2(6,3)=1/(1+(R2(1,2)/R2(1,1))^2)*(DR2_Dpsi(1,2)*R2(1,1)-R2(1,2)*DR2_Dpsi(1,1))/R2(1,1)^2;


J2(4,7)=1/(1+(R2(2,3)/R2(3,3))^2)*(DR2_Dphi12(2,3)*R2(3,3)-R2(2,3)*DR2_Dphi12(3,3))/R2(3,3)^2;
J2(4,8)=1/(1+(R2(2,3)/R2(3,3))^2)*(DR2_Dteta12(2,3)*R2(3,3)-R2(2,3)*DR2_Dteta12(3,3))/R2(3,3)^2;
J2(4,9)=1/(1+(R2(2,3)/R2(3,3))^2)*(DR2_Dpsi12(2,3)*R2(3,3)-R2(2,3)*DR2_Dpsi12(3,3))/R2(3,3)^2;
J2(5,7)=1/sqrt(1-R2(1,3)^2)*(-DR2_Dphi12(1,3));
J2(5,8)=1/sqrt(1-R2(1,3)^2)*(-DR2_Dteta12(1,3));
J2(5,9)=1/sqrt(1-R2(1,3)^2)*(-DR2_Dpsi12(1,3));
J2(6,7)=1/(1+(R2(1,2)/R2(1,1))^2)*(DR2_Dphi12(1,2)*R2(1,1)-R2(1,2)*DR2_Dphi12(1,1))/R2(1,1)^2;
J2(6,8)=1/(1+(R2(1,2)/R2(1,1))^2)*(DR2_Dteta12(1,2)*R2(1,1)-R2(1,2)*DR2_Dteta12(1,1))/R2(1,1)^2;
J2(6,9)=1/(1+(R2(1,2)/R2(1,1))^2)*(DR2_Dpsi12(1,2)*R2(1,1)-R2(1,2)*DR2_Dpsi12(1,1))/R2(1,1)^2;


                         
                           
return;






