function [BW,maskedRGBImage] = OutFieldFinder(gamescreen)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder App. The colorspace and
%  minimum/maximum values for each channel of the colorspace were set in the
%  App and result in a binary mask BW and a composite image maskedRGBImage,
%  which shows the original RGB image values under the mask BW.

% Auto-generated by colorThresholder app on 14-Feb-2019
%------------------------------------------------------

channel1Min = 170.000;
channel1Max = 185.000;
greenMin = 175.000;
greenMax = 185.000;
blueMin = 175.000;
blueMax = 185.000;

% Create mask based on chosen histogram thresholds
sliderBW = (gamescreen(:,:,1) >= channel1Min ) & (gamescreen(:,:,1) <= channel1Max) & ...
    (gamescreen(:,:,2) >= greenMin ) & (gamescreen(:,:,2) <= greenMax) & ...
    (gamescreen(:,:,3) >= blueMin ) & (gamescreen(:,:,3) <= blueMax);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = gamescreen;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end
