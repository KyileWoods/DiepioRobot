close all
clear all

import java.awt.Robot;
import java.awt.event.*;
tools= java.awt.Toolkit.getDefaultToolkit();
robo = java.awt.Robot;

%Create static variables
x=2;
y=1;
scaler = 2;
FPSprintrate = 50;
MoveDirection = "North";
TakeAction = true;

rectangle = java.awt.Rectangle(tools.getScreenSize()); 
screen_size = [  rectangle.height , rectangle.width ];
datavisionview_size = screen_size;% [  floor(screen_size(y)/scaler), floor(screen_size(x)/scaler) ]; %Go to floor so different sized-screens can be shrunken down


sensor = [ 0.05 , 0.5622*0.05 ];
gap    = [ 0.08 , 0.5622*0.08 ];

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

            
figure
bwblob = imshow(zeros(screen_size),'InitialMagnification', 100);
title('Sillhouettes of farmable shape objects')




smallgamescreen=zeros(screen_size);
smallgamescreen(tank(1,y):tank(2,y) , tank(1,x):tank(2,x),1:3) =1;
smallgamescreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),1:3) =1;
smallgamescreen(southeastroi(1,y):southeastroi(2,y) , southeastroi(1,x):southeastroi(2,x),1:3) = 1;
smallgamescreen(southwestroi(1,y):southwestroi(2,y) , southwestroi(1,x):southwestroi(2,x),1:3) =1;
smallgamescreen(northwestroi(1,y):northwestroi(2,y) , northwestroi(1,x):northwestroi(2,x),1:3) = 1;

smallgamescreen(eastroi(1,y):eastroi(2,y) , eastroi(1,x):eastroi(2,x),1:3) = 1;
smallgamescreen(southroi(1,y):southroi(2,y) , southroi(1,x):southroi(2,x),1:3) = 1;
smallgamescreen(westroi(1,y):westroi(2,y) , westroi(1,x):westroi(2,x),1:3) = 1;
smallgamescreen(northroi(1,y):northroi(2,y) , northroi(1,x):northroi(2,x),1:3) = 1;

smallgamescreen = smallgamescreen ==1;
bwblob.CData = smallgamescreen;

smallgamescreen(northeastroi(1,y):northeastroi(2,y) , northeastroi(1,x):northeastroi(2,x),1:3) = 0;







