import java.awt.Robot;
import java.awt.event.*;
t = java.awt.Toolkit.getDefaultToolkit();
robo = java.awt.Robot;

%Move the mouse diagonally across the screen, from the origin
robo.mouseMove(0, 0);
screenSize = get(0, 'screensize');
for i = 1: screenSize(4)
    robo.mouseMove(i, i);
    pause(0.0001);
end


rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
% imageview('screencapture.jpg');