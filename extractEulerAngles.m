function eulerAngles = extractEulerAngles(R)
R=R.';
eulerAngles = [ atan2(R(2,3),R(3,3)) ; 
                asin(-R(1,3))        ; 
                atan2(R(1,2),R(1,1)) ];
            
return;