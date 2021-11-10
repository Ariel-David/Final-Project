
graphFF=zeros(1,length(FrameFF));
for jtek=1:length(FrameFF)
    if SigmaFF{jtek}~=inf
graphFF(jtek)=SigmaFF{jtek}(1,1);
    else
        graphFF(jtek)=0;
    end
end

figure
subplot (2,3,1)
plot(tt,abs(bx_constructedPath-bx_true), 'b')
hold on
plot(time(FrameFF),sqrt(graphFF),'r')
title('Error x Vision-based nav: theoretical(linear)(r) vs calculated(b)')
xlabel('time (c)')
ylabel('Error x (m)')
grid


for jtek=1:length(FrameFF)
    if SigmaFF{jtek}~=inf
graphFF(jtek)=SigmaFF{jtek}(2,2);
    else
        graphFF(jtek)=0;
    end
end

subplot (2,3,2)
plot(tt,abs(by_constructedPath-by_true), 'b')
hold on
plot(time(FrameFF),sqrt(graphFF),'r')
title('Error y Vision-based nav: theoretical(linear)(r) vs calculated(b)')
xlabel('time (c)')
ylabel('Error y (m)')
grid



for jtek=1:length(FrameFF)
    if SigmaFF{jtek}~=inf
graphFF(jtek)=SigmaFF{jtek}(3,3);
    else
        graphFF(jtek)=0;
    end
end

subplot (2,3,3)
plot(tt,abs(bz_constructedPath-bz_true), 'b')
hold on
plot(time(FrameFF),sqrt(graphFF),'r')
title('Error z Vision-based nav: theoretical(linear)(r) vs calculated(b)')
xlabel('time (c)')
ylabel('Error z (m)')
grid



for jtek=1:length(FrameFF)
    if SigmaFF{jtek}~=inf
graphFF(jtek)=SigmaFF{jtek}(4,4);
    else
        graphFF(jtek)=0;
    end
end

subplot (2,3,4)
plot(tt(1:length(Droll_constructedPath)),abs(Droll_constructedPath)/grad2rad, 'b')
hold on
plot(time(FrameFF),sqrt(graphFF)/pi*180,'r')
title('Error roll Vision-based nav: theoretical(linear)(r) vs calculated(b)')
xlabel('time (c)')
ylabel('Error roll (Phi) (grad)')
grid



for jtek=1:length(FrameFF)
    if SigmaFF{jtek}~=inf
graphFF(jtek)=SigmaFF{jtek}(5,5);
    else
        graphFF(jtek)=0;
    end
end

subplot (2,3,5)
plot(tt(1:length(Dpitch_constructedPath)),abs(Dpitch_constructedPath)/grad2rad, 'b')
hold on
plot(time(FrameFF),sqrt(graphFF)/pi*180,'r')
title('Error pitch Vision-based nav: theoretical(linear)(r) vs calculated(b)')
xlabel('timec)')
ylabel('Error pitch (Theta) (grad)')
grid



for jtek=1:length(FrameFF)
    if SigmaFF{jtek}~=inf
graphFF(jtek)=SigmaFF{jtek}(6,6);
    else
        graphFF(jtek)=0;
    end
end

subplot (2,3,6)
plot(tt(1:length(Dyaw_constructedPath)),abs(Dyaw_constructedPath)/grad2rad, 'b')
hold on
plot(time(FrameFF),sqrt(graphFF)/pi*180,'r')
title('Error yaw Vision-based nav: theoretical(linear)(r) vs calculated(b)')
xlabel('time (c)')
ylabel('Error yaw (Psi) (grad)')
grid

