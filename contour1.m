% Synthetic Data  
xy =  [arx(2:length(arx))' ary(2:length(ary))'];
velocity = arvmag';
% Interpolate to grid
interpolant = scatteredInterpolant(xy(:,1),xy(:,2),velocity);
% Grid
r1 = range(velocity)
r2 = range(xx)
r3 = range(yy)
[xx,yy] = meshgrid(linspace(-60,60, 500));  % replace, 0 1, 10 with range of your values
% Interpolate
velocity_interp = interpolant(xx,yy);
contour(xx,yy,velocity_interp);
title('contour with lines')


figure
contourf(xx,yy,velocity_interp);
shading interp

figure
contourf(xx,yy,velocity_interp);
shading interp
title('flat')

figure
surf(velocity_interp);
hold on
imagesc(velocity_interp);
title('surf with imagesc')

figure

mesh(xx, yy, velocity_interp);
shading interp
hold on
imagesc(velocity_interp);
title('mesh')


figure

surfc(xx, yy, velocity_interp);
shading interp
hold on
imagesc(velocity_interp);
title('surfc')

figure

contour3(xx, yy, velocity_interp, 100);
shading interp
hold on
imagesc(velocity_interp);
title('surfc')