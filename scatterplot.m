plot3(arx, ary, arz, '.-');
tri = delaunay(arx, ary);
plot(arx,ary,'.');
[r,c] = size(tri);
disp(r)
h = trisurf(tri, arx, ary, arz);
axis vis3d
axis off
axis off
l = light('Position',[-500 -150 290])
set(gca,'CameraPosition',[2080 -500 7687])
lighting phong
shading interp
colorbar EastOutside