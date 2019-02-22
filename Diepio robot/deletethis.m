c=imread('grey.png');
image(c)
axis image
i = c(3:100, 120:100, 3);
imshow (i,'InitialMagnification','fit');
bi=(i<50);
imagesc(bi)
colormap gray
axis image
[N,R]= boxcount(bi,'slope');
df= -diff(log(N))./diff(log(R));
disp(['Fractal dimension, Df=' num2str(mean(df(4:8))) '+/-' num2str(std(df(4:8)))]);