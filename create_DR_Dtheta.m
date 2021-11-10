function DR_Dtheta = create_DR_Dtheta(phi, theta, psi)
% R=createRfromAngles(phi, theta, psi);
% eulerAngles=extractEulerAngles_old(R);
% phi=eulerAngles(1);
% theta=eulerAngles(2);
% psi=eulerAngles(3);

Rphi = [ 1 , 0         , 0        ; 
         0 , cos(phi)  , sin(phi) ;
         0 , -sin(phi) , cos(phi) ];
        
DRtheta_Dtheta =  [ -sin(theta) , 0 , -cos(theta) ;
                     0          , 0 , 0           ;
                     cos(theta) , 0 , -sin(theta) ];
       
Rpsi = [ cos(psi)  , sin(psi) , 0 ;
         -sin(psi) , cos(psi) , 0 ;
         0         , 0        , 1 ];

DR_Dtheta = Rphi * DRtheta_Dtheta * Rpsi ;

return;