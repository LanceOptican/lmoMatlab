% draw tick marks
function h = drwTick(x, y, ht, clr)

h = plot(x * [1,1], y + ht * [-1, 1], 'color', clr);
