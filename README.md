# DiepioRobot
A matlab robot to farm shapes in diep.io

This is a little robot which uses java.awt to press buttons and point and click the mouse in order to shoot/farm objects on the screen. If diep.io is not the thing on the screen, these actions are not helpful. The java.awt tools are not able to read the input from a keyboard uless matlab is the window in focus, for this reason the shutdown procedure for the robot, instead of being a keystroke, is to stop diep.io being fullscreen. It detects this with a color threshold and so the diep.io window must be maximized
