rng(1);
matty1 = randn(1000,1000);
matty2 = randn(1000,1000);
matty3 = randn(1000,1000);
matty4 = randn(1000,1000);

tic
for i=1:10000
    matty_match = matty1 | matty2 | matty3 | matty4;
end
toc
tic
for i=1:10000
    matty_match = (matty1 + matty2 + matty3 + matty4)==true;
end
toc