function DR_Dphi = create_DR_Dphi(phi, theta, psi)
% R=createRfromAngles(phi, theta, psi);
% eulerAngles=extractEulerAngles_old(R);
% phi=eulerAngles(1);
% theta=eulerAngles(2);
% psi=eulerAngles(3);

DRphi_Dphi = [ 0 , 0         , 0         ; 
               0 , -sin(phi) , cos(phi)  ;
               0 , -cos(phi) , -sin(phi) ];
        
Rtheta =  [ cos(theta) , 0 , -sin(theta) ;
            0          , 1 , 0           ;
            sin(theta) , 0 , cos(theta)  ];
       
Rpsi = [ cos(psi)  , sin(psi) , 0 ;
         -sin(psi) , cos(psi) , 0 ;
         0         , 0        , 1 ];

DR_Dphi = DRphi_Dphi * Rtheta * Rpsi ;

return;