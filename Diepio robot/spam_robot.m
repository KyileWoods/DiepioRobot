function spam_robot
% Demo to use java robot to push buttons on the Mathworks spam quarantine web page
% Have Firefox be full screen with no toolbars.
clc;
import java.awt.Robot
import java.awt.event.*
mouse = Robot;
CallUpSpamURL(mouse);
ResetZoom(mouse);
% Reset the zoom so that the links will be at the same place every time.

% Close the Firefox bookmark panel if it's open.
y = 158; % Position of the "x" close icon.
for x = 160 : 2 : 335
	mouse.mouseMove(x, y);
	mouse.mousePress(InputEvent.BUTTON1_MASK);
	mouse.mouseRelease(InputEvent.BUTTON1_MASK);
end
% Use urlread to look for '1 - 0 of 0' which means it's done.
for k = 1 : 42
	CallUpSpamURL(mouse);

	% Press a push button on the page.
	% Move to pixel (330, 455) on the computer screen.
	% It's the location of the first spam subject line.
	if workWideScreen
		mouse.mouseMove(600, 425); % First message.
	else
		mouse.mouseMove(800, 450); % First message.
	end
	mouse.mousePress(InputEvent.BUTTON1_MASK);
	mouse.mouseRelease(InputEvent.BUTTON1_MASK);
	pause(5); % Give time for page to refresh.

	% To perform right click (BUTTON3) and get the menu(works fine)
	% If the subject line is a single line.
	% Move the cursor over the "This is spam" button.
	for row = 500 : 5 : 580
		if workWideScreen
			mouse.mouseMove(590, row);
		else
			mouse.mouseMove(635, row);
		end
		mouse.mousePress(InputEvent.BUTTON1_MASK);
		mouse.mouseRelease(InputEvent.BUTTON1_MASK);
		
		% If the subject line is two lines.
		% 	mouse.mouseMove(800, 670);
		% 	mouse.mousePress(InputEvent.BUTTON1_MASK);
		% 	mouse.mouseRelease(InputEvent.BUTTON1_MASK);
	end
	pause(12);
	CallUpSpamURL(mouse);
end

% % Move cursor to the "Back" button on the Firefox toolbar.
% robot.mouseMove(20, 70);
% robot.mousePress(InputEvent.BUTTON1_MASK);
% robot.mouseRelease(InputEvent.BUTTON1_MASK);
% pause(1);
% robot.mousePress(InputEvent.BUTTON1_MASK);
% robot.mouseRelease(InputEvent.BUTTON1_MASK);

% % Click next page button.
% pause(2); % Give time for page to refresh.
% robot.mouseMove(940, 422); % Next page.
% robot.mousePress(InputEvent.BUTTON1_MASK);
% robot.mouseRelease(InputEvent.BUTTON1_MASK);

% Put mouse over MATLAB run button.
% robot.mouseMove(1520, 74);
fprintf('Done.\n');
msgboxw('Done deleting spam!');

% Browse to http://www.mathworks.com/matlabcentral/answers/manage-spam
function CallUpSpamURL(robot)
import java.awt.Robot
import java.awt.event.*
robot.mouseMove(95, 70)
robot.mousePress(InputEvent.BUTTON1_MASK);
robot.mouseRelease(InputEvent.BUTTON1_MASK);
pause(0.2);
robot.keyPress(KeyEvent.VK_DELETE);
% robot.keyPress(KeyEvent.VK_SEPARATOR);
% robot.keyPress(KeyEvent.VK_SEPARATOR);
clipboard('copy', 'http://www.mathworks.com/matlabcentral/answers/manage-spam')
robot.keyPress(KeyEvent.VK_CONTROL);
robot.keyPress(KeyEvent.VK_V);
robot.keyRelease(KeyEvent.VK_V);
robot.keyRelease(KeyEvent.VK_CONTROL);
pause(0.2);
% Simulate Enter key event
robot.keyPress(KeyEvent.VK_ENTER);
robot.keyRelease(KeyEvent.VK_ENTER);
pause(5);

% robot.keyPress(KeyEvent.VK_W);
% robot.keyPress(KeyEvent.VK_W);
% robot.keyPress(KeyEvent.VK_W);
% robot.keyPress(KeyEvent.VK_PERIOD);
% robot.keyPress(KeyEvent.VK_M);
% robot.keyPress(KeyEvent.VK_A);
% robot.keyPress(KeyEvent.VK_T);
% robot.keyPress(KeyEvent.VK_H);
% robot.keyPress(KeyEvent.VK_W);
% robot.keyPress(KeyEvent.VK_O);
% robot.keyPress(KeyEvent.VK_R);
% robot.keyPress(KeyEvent.VK_K);
% robot.keyPress(KeyEvent.VK_S);
% robot.keyPress(KeyEvent.VK_PERIOD);
% robot.keyPress(KeyEvent.VK_C);
% robot.keyPress(KeyEvent.VK_O);
% robot.keyPress(KeyEvent.VK_M);
% robot.keyPress(KeyEvent.VK_SEPARATOR);
% robot.keyPress(KeyEvent.VK_M);
% robot.keyPress(KeyEvent.VK_A);
% robot.keyPress(KeyEvent.VK_T);
% robot.keyPress(KeyEvent.VK_L);
% robot.keyPress(KeyEvent.VK_A);
% robot.keyPress(KeyEvent.VK_B);
% robot.keyPress(KeyEvent.VK_C);
% robot.keyPress(KeyEvent.VK_E);
% robot.keyPress(KeyEvent.VK_N);
% robot.keyPress(KeyEvent.VK_T);
% robot.keyPress(KeyEvent.VK_R);
% robot.keyPress(KeyEvent.VK_A);
% robot.keyPress(KeyEvent.VK_L);
% robot.keyPress(KeyEvent.VK_SEPARATOR);
% robot.keyPress(KeyEvent.VK_A);
% robot.keyPress(KeyEvent.VK_N);
% robot.keyPress(KeyEvent.VK_S);
% robot.keyPress(KeyEvent.VK_W);
% robot.keyPress(KeyEvent.VK_E);
% robot.keyPress(KeyEvent.VK_R);
% robot.keyPress(KeyEvent.VK_S);
% robot.keyPress(KeyEvent.VK_SEPARATOR);
% robot.keyPress(KeyEvent.VK_M);
% robot.keyPress(KeyEvent.VK_A);
% robot.keyPress(KeyEvent.VK_N);
% robot.keyPress(KeyEvent.VK_A);
% robot.keyPress(KeyEvent.VK_G);
% robot.keyPress(KeyEvent.VK_E);
% robot.keyPress(KeyEvent.VK_S);
% robot.keyPress(KeyEvent.VK_P);
% robot.keyPress(KeyEvent.VK_A);
% robot.keyPress(KeyEvent.VK_M);
return;

function ResetZoom(robot)
import java.awt.Robot
import java.awt.event.*
robot.mouseMove(80, 10);
robot.mousePress(InputEvent.BUTTON1_MASK);
% robot.mouseRelease(InputEvent.BUTTON1_MASK);
pause(0.2);
robot.mouseMove(100, 90);
robot.mousePress(InputEvent.BUTTON1_MASK);
% robot.mouseRelease(InputEvent.BUTTON1_MASK);
pause(0.2);
robot.mouseMove(320, 135);
robot.mousePress(InputEvent.BUTTON1_MASK);
robot.mouseRelease(InputEvent.BUTTON1_MASK);
% robot.keyPress(KeyEvent.VK_CONTROL);
% robot.keyPress(KeyEvent.VK_0);
% robot.keyRelease(KeyEvent.VK_0);
% robot.keyRelease(KeyEvent.VK_CONTROL);
% % Zoom in 3 times.
% for k = 1 : 4
% % 	robot.mouseMove(320, 135);
% % 	robot.mousePress(InputEvent.BUTTON1_MASK);
% % 	robot.mouseRelease(InputEvent.BUTTON1_MASK);
% 	robot.keyPress(KeyEvent.VK_CONTROL);
% 	robot.keyPress(KeyEvent.VK_PLUS);
% 	robot.keyRelease(KeyEvent.VK_PLUS);
% 	robot.keyRelease(KeyEvent.VK_CONTROL);
% end
return;


