%% Initialisation
close all
clear all

import java.awt.Robot;
import java.awt.event.*;
tools= java.awt.Toolkit.getDefaultToolkit();
robo = java.awt.Robot;

%% create initialized variables
greyinfront = false;
FaceDirection = 4;
warnings = 0;

%% Create static variables
debugging = false;
x=2;
y=1;
red = 1;
green=2;
blue=3;
scaler = 4;
FPSprintrate = 50;

north = 1;
south = 2;
east= 3;
west = 4;

gowest = 37;
goeast = 39;
gonorth = 38;
gosouth = 40;



rectangle = java.awt.Rectangle(tools.getScreenSize()); 
screen_size = [  rectangle.height , rectangle.width ];
datavisionview_size = [  floor(screen_size(y)/scaler), floor(screen_size(x)/scaler) ]; %Go to floor so different sized-screens can be shrunken down

 %% ROI Definitions---------------------------------------------------------
sensor = [ 0.10 , 0.5622*0.10 ];
gap    = [ 0.16 , 0.5622*0.16 ];

tank =      [ ceil(0.47*datavisionview_size(y)),ceil(0.48*datavisionview_size(x));...
             floor(0.535*datavisionview_size(y)),floor(0.525*datavisionview_size(x))];

northeastroi = [  ceil((0.47-sensor(y)-gap(y))*datavisionview_size(y)) ,  ceil((0.525+gap(x))*datavisionview_size(x));...
                 floor((0.47-gap(y))*datavisionview_size(y))           , floor((0.525+gap(x)+sensor(x))*datavisionview_size(x)) ];
southeastroi = [  ceil((0.535+gap(y))*datavisionview_size(y))          ,  ceil((0.525+gap(x))*datavisionview_size(x));...
                floor((0.535+sensor(y)+gap(y))*datavisionview_size(y)) , floor((0.525+gap(x)+sensor(x))*datavisionview_size(x)) ];        
southwestroi = [  ceil((0.535+gap(y))*datavisionview_size(y))          ,  ceil((0.48-sensor(x)-gap(x))*datavisionview_size(x));...
                floor((0.535+sensor(y)+gap(y))*datavisionview_size(y)) , floor((0.48-gap(x))*datavisionview_size(x)) ];
northwestroi = [  ceil((0.47-sensor(y)-gap(y))*datavisionview_size(y)) ,  ceil((0.48-sensor(x)-gap(x))*datavisionview_size(x));...
                floor((0.47-gap(y))*datavisionview_size(y))            , floor((0.48-gap(x))*datavisionview_size(x)) ];
eastroi    =[  ceil((0.47+sensor(y)/2)*datavisionview_size(y))         ,  ceil((0.525+gap(x))*datavisionview_size(x));...
                floor((0.47+sensor(y))*datavisionview_size(y))         , floor((0.525+gap(x)+sensor(x)/2)*datavisionview_size(x)) ];

southroi = [  ceil((0.535+gap(y))*datavisionview_size(y)) ,  ceil((0.48+sensor(x)/2)*datavisionview_size(x));...
                floor((0.535+sensor(y)/2+gap(y))*datavisionview_size(y)) , floor((0.48+sensor(x))*datavisionview_size(x)) ];

westroi = [  ceil((0.47+sensor(y)/2)*datavisionview_size(y)) ,   floor((0.48-gap(x)-sensor(x)/2)*datavisionview_size(x)) ;...
                floor((0.47+sensor(y))*datavisionview_size(y)) , ceil((0.48-gap(x))*datavisionview_size(x))];

northroi = [  ceil((0.47-gap(y)-sensor(y)/2)*datavisionview_size(y)) ,  ceil((0.48+sensor(x)/2)*datavisionview_size(x));...
                floor((0.47-gap(y))*datavisionview_size(y)) , floor((0.48+sensor(x))*datavisionview_size(x)) ];


%% Create Figures

figure
showinformationscreen = imshow(masked_screen, 'InitialMagnification',100);
title('The gamefield with detection patches')

pause(4);
% Switch to the diepio screen

%Begin playing the game

%% THE GAME LOOP-----------------------------------------------------------------------------------------------------
%%Initializations
i=0; %Loop iterations
playgame = true;

%%
while  playgame == true
    i=i+1;
    if i>150    %For safety, ensure the robo shuts down eventually.
        playgame=false;
    end    
    
    %% Screenshot the field
    
    javagamescreen = robo.createScreenCapture(rectangle);    % 58.3-percent of the time is spent here, perhaps find a way to grab only ervery [scaler]th pixel.
    % repackage as a 3D array (MATLAB image format)
    pixelsData = reshape(typecast(javagamescreen.getData.getDataStorage, 'uint8'), 4, screen_size(x), screen_size(y)); % 17.1-percent of the time is spent here
    smallgamescreen = cat(3, ...
                transpose(reshape(pixelsData(3, scaler:scaler:end, scaler:scaler:end), datavisionview_size(x) , datavisionview_size(y))), ...
                transpose(reshape(pixelsData(2, scaler:scaler:end, scaler:scaler:end), datavisionview_size(x) , datavisionview_size(y))), ...
                transpose(reshape(pixelsData(1, scaler:scaler:end, scaler:scaler:end), datavisionview_size(x) , datavisionview_size(y))));
    
    %% Silhouette objects on the field
    [blue_sieve, red_sieve, yellow_sieve] = shape_shadows(smallgamescreen);
    masked_screen = (blue_sieve + red_sieve + yellow_sieve)==true;  % Faster than | 'or'-ing them all.
        
    %% Paint the detection regions of the gamescreen
    informationscreen = smallgamescreen;
    informationscreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),2) =255;
    informationscreen(southeastroi(1,y):southeastroi(2,y) , southeastroi(1,x):southeastroi(2,x),2) = 255;
    informationscreen(southwestroi(1,y):southwestroi(2,y) , southwestroi(1,x):southwestroi(2,x),2) =255;
    informationscreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),2) = 255;
    
    informationscreen(northroi(1,y):northroi(2,y) , northroi(1,x):northroi(2,x),3) = 255;
    informationscreen(eastroi(1,y):eastroi(2,y) , eastroi(1,x):eastroi(2,x),3) = 255;
    informationscreen(southroi(1,y):southroi(2,y) , southroi(1,x):southroi(2,x),3) =255;
    informationscreen(westroi(1,y):westroi(2,y) , westroi(1,x):westroi(2,x),3) = 255;
    
    %% Determine the locations of each object
    
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

    %% Shoot at the best nearest candidate shape!
    shapes_info = [squares_info; triangles_info;pentagons_info];
    shapes_info2 = sortrows(shapes_info,3);

    if any(any(shapes_info)) 
        robo.mouseMove(shapes_info2(1,2)*scaler, shapes_info2(1,1)*scaler);
        robo.mousePress(InputEvent.BUTTON1_MASK);
    end

    %% FIELD NAVIGATION
    
	%Release all keys, in preparation for new commands
    robo.keyRelease(KeyEvent.VK_UP);
    robo.keyRelease(KeyEvent.VK_DOWN);
    robo.keyRelease(KeyEvent.VK_LEFT);
    robo.keyRelease(KeyEvent.VK_RIGHT); 
    
    %% Change the relative directions into specific ones (i.e. Forward-V-north)
    if FaceDirection == 1 %North
        rightsensor = smallgamescreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),:);
        leftsensor = smallgamescreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),:);
        frontsensor = smallgamescreen(northroi(1,y):northroi(2,y) , northroi(1,x):northroi(2,x),:);
        
        backleftsensor = smallgamescreen(southwestroi(1,y):southwestroi(2,y) , southwestroi(1,x):southwestroi(2,x),:);
        backrightsensor = smallgamescreen(southeastroi(1,y):southeastroi(2,y) , southeastroi(1,x):southeastroi(2,x),:);
        
        goforward = gonorth;
        goback = gosouth;
        goleft = gowest;
        goright = goeast;
        
        left = west;
        right = east;
        reverse = south;
        
    elseif FaceDirection == 2 %South
        rightsensor = smallgamescreen(southwestroi(1,y):southwestroi(2,y) , southwestroi(1,x):southwestroi(2,x),:);
        leftsensor = smallgamescreen(southeastroi(1,y):southeastroi(2,y) , southeastroi(1,x):southeastroi(2,x),:);
        frontsensor = smallgamescreen(southroi(1,y):southroi(2,y) , southroi(1,x):southroi(2,x),:);
        
        backleftsensor = smallgamescreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),:);
        backrightsensor = smallgamescreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),:);
        
        goforward = gosouth;
        goback = gonorth;
        goleft = goeast;
        goright = gowest;
        
        left = east;
        right = west;
        reverse = north;
        
    elseif FaceDirection == 3 %east
        rightsensor = smallgamescreen(southeastroi(1,y):southeastroi(2,y) , southeastroi(1,x):southeastroi(2,x),:);
        leftsensor = smallgamescreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),:);
        frontsensor = smallgamescreen(eastroi(1,y):eastroi(2,y) , eastroi(1,x):eastroi(2,x),:);
        
        backleftsensor = smallgamescreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),:);
        backrightsensor = smallgamescreen(southwestroi(1,y):southwestroi(2,y) , southwestroi(1,x):southwestroi(2,x),:);
        
        goforward = goeast;
        goback = gowest;
        goleft = gonorth;
        goright = gosouth;
        
        left = north;
        right = south;
        reverse = west;
        
    elseif FaceDirection == 4 %west
        
        rightsensor = smallgamescreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),:);
        leftsensor = smallgamescreen(southwestroi(1,y):southwestroi(2,y) , southwestroi(1,x):southwestroi(2,x),:);
        frontsensor = smallgamescreen(westroi(1,y):westroi(2,y) , westroi(1,x):westroi(2,x),:);
        
        backleftsensor = smallgamescreen(southeastroi(1,y):southeastroi(2,y) , southeastroi(1,x):southeastroi(2,x),:);
        backrightsensor = smallgamescreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),:);
        
        goforward = gowest;
        goback = goeast;
        goleft = gosouth;
        goright = gonorth;    
        
        left = south;
        right = north;
        reverse = east;
        
    end
    robo.keyPress(goforward)
    
    %% Determine the best direction to travel in, and new directions
    if mean(mean(GreyFieldFinder(leftsensor))) > 0.8        %If the left is in greyfield...
        if mean(mean(GreyFieldFinder(rightsensor))) < 0.2   %...And the right sensor is not
            if mean(mean(GreyFieldFinder(frontsensor))) > 0.8 %The robot is toward the grey area
                robo.keyPress(goright);
                informationscreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),1:2) =255;
            elseif mean(mean(GreyFieldFinder(frontsensor))) < 0.2 %The robot is toward homezone
                robo.keyPress(goleft);
                informationscreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),1:2) =255;
            else  %Something unexpected has happened
                robo.keyRelease(goleft);
                robo.keyRelease(goright);
            end
        elseif mean(mean(GreyFieldFinder(rightsensor))) > 0.8   %There is only greyfield in front
            robo.keyRelease(goleft);
            robo.keyRelease(goright);
            if mean(mean(GreyFieldFinder(backleftsensor))) < 0.2 %Tank preferentially turns left
                FaceDirection = left;
            elseif mean(mean(GreyFieldFinder(backrightsensor))) < 0.2
                FaceDirection = right;
            else %Something unexpected has happened
                error('Heading %d, The right sensor was in grey, as was the left, but neither rear sensor was in homezone ', FaceDirection)
            end
        else
            warnings = warnings +1;
            warning('Heading %d, the left sensor was in grey, the right sensor was in partial grey ', FaceDirection)
        end
    elseif mean(mean(GreyFieldFinder(rightsensor))) > 0.8   %The right is in greyfield...
        if mean(mean(GreyFieldFinder(leftsensor))) < 0.2    %...And the left sensor is not
            if mean(mean(GreyFieldFinder(frontsensor))) > 0.8 %The robot is toward the grey area
                robo.keyPress(goleft);
                informationscreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),2:3) =255;
            elseif mean(mean(GreyFieldFinder(frontsensor))) < 0.2 %The robot is toward homezone
                robo.keyPress(goright);
                informationscreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),2:3) =255;
            else %Something unexpected has happened
                robo.keyRelease(goleft);
                robo.keyRelease(goright);
            end
        elseif mean(mean(GreyFieldFinder(leftsensor))) > 0.8   %The left is in greyfield
            robo.keyRelease(goleft);
            robo.keyRelease(goright);
            if mean(mean(GreyFieldFinder(backleftsensor))) < 0.2
                FaceDirection = left;
            elseif mean(mean(GreyFieldFinder(backrightsensor))) < 0.2
                FaceDirection = right;
            else %Something unexpected has happened
                error('Heading %d, The right sensor was in grey, as was the left, but neither rear sensor was in homezone ', FaceDirection)
            end    
            
        else    %Something unexpected has happened
            warnings = warnings +1;
            warning('Heading %d, the right sensor was in grey, the left sensor was in partial grey ', FaceDirection)
        end
    else    %Robo must be in homezone or OutBounds
        if mean(mean(OutFieldFinder(leftsensor))) > 0.8 %If OutofBounds is in front...
            FaceDirection = reverse;
        elseif mean(mean(GreyFieldFinder(backrightsensor))) < 0.2 %If the homezone area is in front
            %The bot is in the green zone, no context, no preference
            %for movement direction.
            robo.keyPress(goforward)
        else %Something unexpected has happened
            warning('Heading %d, the front was not in outerbounds or grey, and backright was not in green. Perhaps this is some edge-case glitch', FaceDirection)
        end  
    end
    
    showinformationscreen.CData = informationscreen;
end


warnings