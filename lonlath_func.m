function lonlath=lonlath_func(bx, by, bz, lon, lat, hint)
    grad2rad=pi/180;
    zz1=[lat lon hint];  %initial position    

    lonlath(1,1:3)=[zz1(2) zz1(1) hint];
    xyz1=llh2xyz(zz1);
    for ii = 2:size(bx,2)
        deltaenu=[bx(ii)-bx(ii-1) by(ii)-by(ii-1) bz(ii)-bz(ii-1)];
        xyz=enu2xyz_corrected(deltaenu,xyz1);
        llh=xyz2llh(xyz);
        xyz1=xyz;
        lonlath(ii,1:3)=[llh(2) llh(1) llh(3)];
    end

    lonlath(:,1:2)=lonlath(:,1:2)/grad2rad;
end