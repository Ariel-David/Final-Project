function m = kPa2m(kPa)

kPa2Mtable = [101.32 0;
              100.13 100;
              98.94 200;
              97.77 300;
              96.61 400;
              95.46 500;
              89.87 1000;
              79.48 2000;
              70.09 3000;
              61.62 4000;
              53.99 5000;
              47.15 6000;
              41.03 7000;
              35.57 8000;
              30.71 9000;
              26.41 10000;
              22.60 11000;
              19.20 12000];
          
[~, ind] = sort(kPa2Mtable(:, 1));
kPa2Mtable = kPa2Mtable(ind, :);
     
dTable = kPa2Mtable(2:end, :) - kPa2Mtable(1:end-1, :);

k = dTable(:, 2)./dTable(:, 1);

c = (k(2:end)-k(1:end-1))/2;
a = (k(1)+k(end))/2;

kPa1 = kPa2Mtable(2, 1);
m1 = kPa2Mtable(2, 2);

b = m1-(a*kPa1+sum(c.*abs(kPa1-kPa2Mtable(2:end-1, 1))));

m = a*kPa + b + sum(c.*abs(kPa-kPa2Mtable(2:end-1, 1)));

end

