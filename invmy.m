function Tinv=invmy(T)
Tinv = [ T(1:3,1:3)' , -T(1:3,1:3)'*T(1:3,4) ; [0 0 0 1] ];
return