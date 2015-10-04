% test legendshrink
figure(1);
clf
x = 0:1:1000;
y = rand(size(x));
z = randn(size(x));
plot(x, y, x, z);
[legh, objh, outh, outm] = legend({'rand', 'randn'}, 'location', 'ne');

legendShrinkLineLength(objh,1.75);



