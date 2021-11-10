function DR_Dpsi = create_DR_Dpsi(phi, theta, psi)
% R=createRfromAngles(phi, theta, psi);
% eulerAngles=extractEulerAngles_old(R);
% phi=eulerAngles(1);
% theta=eulerAngles(2);
% psi=eulerAngles(3);


Rphi   = [ 1 , 0         , 0        ; 
           0 , cos(phi)  , sin(phi) ;
           0 , -sin(phi) , cos(phi) ];
        
Rtheta =  [ cos(theta) , 0 , -sin(theta) ;
            0          , 1 , 0           ;
            sin(theta) , 0 , cos(theta)  ];
       
DRpsi_Dpsi   = [ -sin(psi) , cos(psi)  , 0 ;
                 -cos(psi) , -sin(psi) , 0 ;
                 0         , 0         , 0 ];

DR_Dpsi = Rphi * Rtheta * DRpsi_Dpsi ;

return;