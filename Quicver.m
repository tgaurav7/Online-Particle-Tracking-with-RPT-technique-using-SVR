data_X = load('exp_results_x.txt');
data_Y = load('exp_results_y.txt');
data_Z = load('exp_results_z.txt');

%positions
ar_x = [];
ar_y = [];
ar_z = [];
tim = [];
%directional velcoities
ar_x_v = [];
ar_y_v = [];
ar_z_v = [];

xyz = [ar_x ar_y ar_z];

%instantaneous velocity magnitude
arv_mag = [];

for i = 1:length(data_Z)
    ar_x = [ar_x data_X(i)];
    ar_y = [ar_y data_Y(i)];
    ar_z = [ar_z data_Z(i)];
    
    %calculating directional velcotities
    if(i == 0)
        ar_x_v = [ar_x_v 0];
        ar_y_v = [ar_y_v 0];
        ar_z_v = [ar_z_v 0];
    end
    
    if(i>1)
        ar_x_v = [ar_x_v (ar_x(i) - ar_x(i-1))];
        ar_y_v = [ar_y_v (ar_y(i) - ar_y(i-1))];
        ar_z_v = [ar_z_v (ar_z(i) - ar_z(i-1))];
        arv_mag = [arv_mag sqrt(ar_x_v(i-1)*ar_x_v(i-1) + ar_y_v(i-1)*ar_y_v(i-1) + ar_z_v(i-1)*ar_z_v(i-1))];
        tim = [tim 0.02*i];
    end
end

%larx = length(ar_x);
%length(ar_x_v);

%lary = length(ar_y);
%length(ar_y_v);

%larz = length(ar_z);
%length(ar_z_v)

%reading data
xy =  [ar_x(2:length(ar_x))' ar_y(2:length(ar_y))'];

vel_x = ar_x_v';
vel_y = ar_y_v';
vel_z = ar_z_v';
velocity = arv_mag';

% Interpolate to grid
interpolant_mag = scatteredInterpolant(xy(:,1),xy(:,2),velocity);
interpolant_x = scatteredInterpolant(xy(:,1),xy(:,2),vel_x);
interpolant_y = scatteredInterpolant(xy(:,1),xy(:,2),vel_y);
interpolant_z = scatteredInterpolant(xy(:,1),xy(:,2),vel_z);

% Grid
[xx,yy] = meshgrid(linspace(-120,120, 500));  % replace, 0 1, 10 with range of your values

% Interpolate
velocity_mag_interp = interpolant_mag(xx,yy);%magnitude of total velocity
velocity_x_interp = interpolant_x(xx,yy);
velocity_y_interp = interpolant_y(xx,yy);
velocity_z_interp = interpolant_z(xx,yy);

figure
quiver(ar_x(2:larx), ar_y(2:lary), ar_x_v, ar_y_v)
title('Position-Velocity vectors for plane x-y')

figure
quiver(ar_x(2:larx), ar_z(2:larz), ar_x_v, ar_z_v)
title('Position-Velocity vectors for plane x-z')

figure
quiver(ar_y(2:lary), ar_z(2:larz), ar_y_v, ar_z_v);
title('Position-Velocity vectors for plane y-z')

figure
quiver3(ar_x(2:larx)', ar_y(2:lary)', ar_z(2:larz)', ar_x_v', ar_y_v', ar_z_v')
xlim([-60 60])
ylim([-60 60])
zlim([0 800])
title('Position Velocity Vector - 3D ')

figure
quiver3(ar_x(2:larx)', ar_y(2:lary)', ar_z(2:larz)', ar_x_v', ar_y_v', ar_z_v');
xlim([-60 60]);
ylim([-60 60]);
zlim([0 800]);
hold on
start = [-60,60];
finish = [60,-60];
imagesc(start, finish, velocity_mag_interp);
title('Position-Velocity vectors in 3D with velocity magnitude contour')