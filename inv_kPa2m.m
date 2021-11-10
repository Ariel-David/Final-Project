function m = inv_kPa2m(kPa)

kPa2Mtable = [0     101.32;
              100   100.13;
              200   98.94;
              300   97.77;
              400   96.61;
              500   95.46;
              1000  89.87;
              2000  79.48;
              3000  70.09;
              4000  61.62;
              5000  53.99;
              6000  47.15;
              7000  41.03;
              8000  35.57;
              9000  30.71;
              10000 26.41;
              11000 22.60;
              12000 19.20];
          
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

