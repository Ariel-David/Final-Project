function yaw=yawprog(yaw2,yaw1)
   Ndelta=fix((yaw2-yaw1)/(2*pi));
   yaw = yaw2-Ndelta*2*pi;    
   yaw11=yaw+2*pi;
   yaw22=yaw-2*pi;
   bol1=abs(yaw-yaw1)>abs(yaw11-yaw1);
       yaw(bol1) = yaw11(bol1);
   bol2=abs(yaw-yaw1)>abs(yaw22-yaw1);
       yaw(bol2) = yaw22(bol2);
return