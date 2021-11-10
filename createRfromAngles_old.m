function R = createRfromAngles_old(phi, theta, psi)

if(nargin==1)
    theta = phi(2);
    psi = phi(3);
    phi = phi(1);
end

Rphi   = [  1 , 0         , 0        ; 
            0 , cos(phi)  , sin(phi) ;
            0 , -sin(phi) , cos(phi) ];
        
Rtheta =  [ cos(theta) , 0 , -sin(theta) ;
            0          , 1 , 0           ;
            sin(theta) , 0 , cos(theta)  ];
       
Rpsi   = [  cos(psi)  , sin(psi) , 0 ;
            -sin(psi) , cos(psi) , 0 ;
            0         , 0        , 1 ];

R = Rphi * Rtheta * Rpsi ;
% R=R.';
return;