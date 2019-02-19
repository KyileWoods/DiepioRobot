function [ blue_sieve, red_sieve, yellow_sieve ] = shape_shadows(gamescreen )
% Returns three binary maps of where pixels exist which are the colours of
% each farmable diep.io shape.
%   Detailed explanation goes here

yellow_redMin = 254.000;
yellow_redMax = 255.000;
yellow_greenMin = 229.000;
yellow_greenMax = 236.000;
yellow_blueMin = 103.000;
yellow_blueMax = 130.000;
yellow_sieve = (gamescreen(:,:,1) >= yellow_redMin ) & (gamescreen(:,:,1) <= yellow_redMax) & ...
    (gamescreen(:,:,2) >= yellow_greenMin ) & (gamescreen(:,:,2) <=yellow_greenMax) & ...
    (gamescreen(:,:,3) >= yellow_blueMin ) & (gamescreen(:,:,3) <= yellow_blueMax);

red_redMin = 243.000;
red_redMax = 253.000;
red_greenMin = 117.000;
red_greenMax = 125.000;
red_blueMin = 117.000;
red_blueMax = 120.000;
red_sieve = (gamescreen(:,:,1) >=red_redMin ) & (gamescreen(:,:,1) <=red_redMax) & ...
    (gamescreen(:,:,2) >=red_greenMin ) & (gamescreen(:,:,2) <=red_greenMax) & ...
    (gamescreen(:,:,3) >=red_blueMin ) & (gamescreen(:,:,3) <=red_blueMax);


channel1Min = 109.000;
channel1Max = 120.000;
channel2Min = 124.000;
channel2Max = 144.000;
channel3Min = 250.000;
channel3Max = 255.000;

blue_redMin = 109;
blue_redMax = 120.000;
blue_greenMin = 124.000;
blue_greenMax = 144.000;
blue_blueMin = 250.000;
blue_blueMax = 255.000;
blue_sieve = (gamescreen(:,:,1) >= blue_redMin ) & (gamescreen(:,:,1) <= blue_redMax) & ...
    (gamescreen(:,:,2) >= blue_greenMin ) & (gamescreen(:,:,2) <= blue_greenMax) & ...
    (gamescreen(:,:,3) >=blue_blueMin ) & (gamescreen(:,:,3) <= blue_blueMax);

end

