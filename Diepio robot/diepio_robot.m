%% Initialisation
close all
clear all

import java.awt.Robot;
import java.awt.event.*;
tools= java.awt.Toolkit.getDefaultToolkit();
robo = java.awt.Robot;

%% create initialized variables
greyinfront = false;
MoveDirection = 'North';
TakeAction = true;

%% Create static variables
x=2;
y=1;
red = 1;
green=2;
blue=3;
scaler = 4;
FPSprintrate = 50;

rectangle = java.awt.Rectangle(tools.getScreenSize()); 
screen_size = [  rectangle.height , rectangle.width ];
datavisionview_size = [  floor(screen_size(y)/scaler), floor(screen_size(x)/scaler) ]; %Go to floor so different sized-screens can be shrunken down

 %% ROI Definitions---------------------------------------------------------
sensor = [ 0.10 , 0.5622*0.10 ];
gap    = [ 0.16 , 0.5622*0.16 ];

tank =      [ ceil(0.47*datavisionview_size(y)),ceil(0.48*datavisionview_size(x));...
             floor(0.535*datavisionview_size(y)),floor(0.525*datavisionview_size(x))];

northeastroi = [  ceil((0.47-sensor(y)-gap(y))*datavisionview_size(y)) ,  ceil((0.525+gap(x))*datavisionview_size(x));...
                floor((0.47-gap(y))*datavisionview_size(y)) , floor((0.525+gap(x)+sensor(x))*datavisionview_size(x)) ];
southeastroi = [  ceil((0.535+gap(y))*datavisionview_size(y)) ,  ceil((0.525+gap(x))*datavisionview_size(x));...
                floor((0.535+sensor(y)+gap(y))*datavisionview_size(y)) , floor((0.525+gap(x)+sensor(x))*datavisionview_size(x)) ];        
southwestroi = [  ceil((0.535+gap(y))*datavisionview_size(y)) ,  ceil((0.48-sensor(x)-gap(x))*datavisionview_size(x));...
                floor((0.535+sensor(y)+gap(y))*datavisionview_size(y)) , floor((0.48-gap(x))*datavisionview_size(x)) ];
northwestroi = [  ceil((0.47-sensor(y)-gap(y))*datavisionview_size(y)) ,  ceil((0.48-sensor(x)-gap(x))*datavisionview_size(x));...
                floor((0.47-gap(y))*datavisionview_size(y)) , floor((0.48-gap(x))*datavisionview_size(x)) ];
            
eastroi    =[  ceil((0.47+sensor(y)/2)*datavisionview_size(y)) ,  ceil((0.525+gap(x))*datavisionview_size(x));...
                floor((0.47+sensor(y))*datavisionview_size(y)) , floor((0.525+gap(x)+sensor(x)/2)*datavisionview_size(x)) ];

southroi = [  ceil((0.535+gap(y))*datavisionview_size(y)) ,  ceil((0.48+sensor(x)/2)*datavisionview_size(x));...
                floor((0.535+sensor(y)/2+gap(y))*datavisionview_size(y)) , floor((0.48+sensor(x))*datavisionview_size(x)) ];

westroi = [  ceil((0.47+sensor(y)/2)*datavisionview_size(y)) ,   floor((0.48-gap(x)-sensor(x)/2)*datavisionview_size(x)) ;...
                floor((0.47+sensor(y))*datavisionview_size(y)) , ceil((0.48-gap(x))*datavisionview_size(x))];

northroi = [  ceil((0.47-gap(y)-sensor(y)/2)*datavisionview_size(y)) ,  ceil((0.48+sensor(x)/2)*datavisionview_size(x));...
                floor((0.47-gap(y))*datavisionview_size(y)) , floor((0.48+sensor(x))*datavisionview_size(x)) ];

points_screen = zeros(datavisionview_size(y), datavisionview_size(x));  %CoM of objects
masked_screen = zeros(datavisionview_size(y), datavisionview_size(x));  %Color-thresholded binary mask of objects.
%homezone_screen=zeros(datavisionview_size(y), datavisionview_size(x));


%% Create Figures
figure
COMpoints = imshow(points_screen, 'InitialMagnification', 100);
title('Centre Of Mass of farmable shape objects')
figure
bwblob = imshow(masked_screen, 'InitialMagnification', 100);
title('Sillhouettes of farmable shape objects')
figure
showinformationscreen = imshow(masked_screen, 'InitialMagnification',100);
title('The gamefield with detection patches')

pause(4);
% Switch to the diepio screen

%Begin playing the game

%% THE GAME LOOP-----------------------------------------------------------------------------------------------------
i=0; %Loop iterations
playgame = true;
mousedown = false;

timer = tic;i2=0;%For finding frame-rate data.

while  playgame == true
    i=i+1;
    if i>1500    %For prototyping, ensure the robo shuts down eventually.
        playgame=false;
    end
    if i-i2 >FPSprintrate %Intermittently display the mean framerate of the last few loops
        elapsed_time = toc(timer);
        FPSprintrate/elapsed_time % ; Leave unsuppressed for FPS readings.
        timer = tic;
        i2=i;
    end



    %% Screenshot the field%-----------------------------------------------------------------------------------------------------

    
    fullgamescreen = robo.createScreenCapture(rectangle);    % 58.3-percent of the time is spent here, perhaps find a way to grab only ervery [scaler]th pixel.
    % repackage as a 3D array (MATLAB image format)
    pixelsData = reshape(typecast(fullgamescreen.getData.getDataStorage, 'uint8'), 4, screen_size(x), screen_size(y)); % 17.1-percent of the time is spent here
    smallgamescreen = cat(3, ...
                transpose(reshape(pixelsData(3, scaler:scaler:end, scaler:scaler:end), datavisionview_size(x) , datavisionview_size(y))), ...
                transpose(reshape(pixelsData(2, scaler:scaler:end, scaler:scaler:end), datavisionview_size(x) , datavisionview_size(y))), ...
                transpose(reshape(pixelsData(1, scaler:scaler:end, scaler:scaler:end), datavisionview_size(x) , datavisionview_size(y))));

    %    gamescreen = imread('test.png'); % protoyping
    

    %% Silhouette objects on the field%-----------------------------------------------------------------------------------------------------
    [blue_sieve, red_sieve, yellow_sieve] = shape_shadows(smallgamescreen);
    masked_screen = (blue_sieve + red_sieve + yellow_sieve)==true;  % Faster than | 'or'-ing them all.
    bwblob.CData = masked_screen;

    %% Determine the locations of each object%-----------------------------------------------------------------------------------------------
    %This region used to have A huge amount of time being spent. It is now optimized
    %well
    [triangles_x, triangles_y,triangles_range] = shape_points(red_sieve, datavisionview_size); % Approx. 3-percent of the time is spent on the blue-red-yellow of this line
    triangles_info =transpose( [triangles_y; triangles_x; triangles_range]);
    triangles_ind = sub2ind(datavisionview_size ,triangles_y,triangles_x);  %Have an "index"-format copy, for .Cdata

    [pentagons_x, pentagons_y, pentagons_range] = shape_points(blue_sieve, datavisionview_size); 
    pentagons_info =transpose( [pentagons_y; pentagons_x; pentagons_range]);
    pentagons_ind = sub2ind(datavisionview_size,pentagons_y,pentagons_x);

    [squares_x, squares_y, squares_range] =shape_points(yellow_sieve, datavisionview_size);  
    squares_info =transpose( [squares_y; squares_x; squares_range]);
    squares_ind = sub2ind(datavisionview_size,squares_y,squares_x);

    points_screen = zeros(datavisionview_size(y), datavisionview_size(x));
    points_screen([squares_ind, triangles_ind, pentagons_ind])=1;

    COMpoints.CData = points_screen;

    %% Shoot at the best nearest candidate shape! -----
    shapes_info = [squares_info; triangles_info;pentagons_info];
    shapes_info2 = sortrows(shapes_info,3);

    if any(any(shapes_info)) 
        robo.mouseMove(shapes_info2(1,2)*scaler, shapes_info2(1,1)*scaler);
        robo.mousePress(InputEvent.BUTTON1_MASK);
    end

    %% FIELD NAVIGATION
    informationscreen = smallgamescreen;
    informationscreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),2) =255;
    informationscreen(southeastroi(1,y):southeastroi(2,y) , southeastroi(1,x):southeastroi(2,x),2) = 255;
    informationscreen(southwestroi(1,y):southwestroi(2,y) , southwestroi(1,x):southwestroi(2,x),2) =255;
    informationscreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),2) = 255;
    
    informationscreen(northroi(1,y):northroi(2,y) , northroi(1,x):northroi(2,x),3) = 255;
    informationscreen(eastroi(1,y):eastroi(2,y) , eastroi(1,x):eastroi(2,x),3) = 255;
    informationscreen(southroi(1,y):southroi(2,y) , southroi(1,x):southroi(2,x),3) =255;
    informationscreen(westroi(1,y):westroi(2,y) , westroi(1,x):westroi(2,x),3) = 255;

        
    robo.keyRelease(KeyEvent.VK_UP);
    robo.keyRelease(KeyEvent.VK_DOWN);
    robo.keyRelease(KeyEvent.VK_LEFT);
    robo.keyRelease(KeyEvent.VK_RIGHT); 
    
    
    if MoveDirection == 'North'
        rightsensor = smallgamescreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),:);
        leftsensor = smallgamescreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),:);
        frontsensor = smallgamescreen(northroi(1,y):northroi(2,y) , northroi(1,x):northroi(2,x),:);
        
        backleftsensor = smallgamescreen(southwestroi(1,y):southwestroi(2,y) , southwestroi(1,x):southwestroi(2,x),:);
        backrightsensor = smallgamescreen(southeastroi(1,y):southeastroi(2,y) , southeastroi(1,x):southeastroi(2,x),:);
        if mean(mean(GreyFieldFinder(leftsensor))) > 0.8        %If the left is in greyfield
            if mean(mean(GreyFieldFinder(rightsensor))) < 0.2   %...And the right sensor is in homebase
                if mean(mean(GreyFieldFinder(frontsensor))) > 0.8 %The robot is toward the grey area
                    robo.keyPress(KeyEvent.VK_RIGHT);
                    informationscreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),1:2) =255;
                elseif mean(mean(GreyFieldFinder(frontsensor))) < 0.2
                    robo.keyPress(KeyEvent.VK_LEFT);
                    informationscreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),1:2) =255;
                else
                    robo.keyRelease(KeyEvent.VK_LEFT);
                    robo.keyRelease(KeyEvent.VK_RIGHT);
                end
            else    %There is only greyfield in front
                greyinfront = true;                    
            end
        elseif mean(mean(GreyFieldFinder(rightsensor))) > 0.8   %The right is in greyfield
            if mean(mean(GreyFieldFinder(leftsensor))) < 0.2    %...And the left sensor is in homebase
                if mean(mean(GreyFieldFinder(frontsensor))) > 0.8 %The robot is toward the grey area
                    robo.keyPress(KeyEvent.VK_LEFT);
                    informationscreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),2:3) =255;
                elseif mean(mean(GreyFieldFinder(frontsensor))) < 0.2
                    robo.keyPress(KeyEvent.VK_RIGHT);
                    informationscreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),2:3) =255;
                else
                    robo.keyRelease(KeyEvent.VK_LEFT);
                    robo.keyRelease(KeyEvent.VK_RIGHT);
                end
            else    %There is only greyfield in front
                greyinfront = true; %This should not actually be reached, really.
            end
        else             %Robo is in homezone or OutBounds
            if mean(mean(OutFieldFinder(leftsensor))) < 0.8 %If OutofBounds is in front...
                %MoveDirection = 'East';
            elseif mean(mean(GreyFieldFinder(backrightsensor))) < 0.2 %If the homezone area is in front
                %The bot is in the green zone, no context, no preference
                %for movement direction.
                robo.keyPress(KeyEvent.VK_UP)
            end
        end
        if greyinfront == true
            if mean(mean(GreyFieldFinder(backleftsensor))) > 0.8
                %MoveDirection = 'East';
            elseif mean(mean(GreyFieldFinder(backrightsensor))) > 0.8
                %MoveDirection = 'West';
            else
                5+5%Some kind of error has occurred
            end
        else

        end    
    end
    
    
    
    showinformationscreen.CData = informationscreen;
    drawnow
end