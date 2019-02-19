function [shapes_x, shapes_y, range] = shape_points(shadow_image, screen_size)
%Find and return the CentreOfMass of objects in a binary array, as an index.
% 


[shapes_x, shapes_y] = centresOfMass(shadow_image);     %    [-1,1] ....Cartesian coordinates
range = sqrt( shapes_x.^2 + shapes_y.^2);
shapes_x = ceil(((shapes_x+1)/2)*(screen_size(2)-1))+1;   %    translate to pixel index
%shapes_y = [shapes_y,0,1,-1]
shapes_y = screen_size(1) - (ceil(((shapes_y+1)/2)*(screen_size(1)-3))+1); %Flip the Y index, upside down (Because it has to be, for some reason)

end

