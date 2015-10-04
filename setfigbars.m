function setfigbars(toolbar, menubar)
% turns on (1) or off (0) the current figures menubars
%
if toolbar
    tb = 'auto';
else
    tb = 'none';
end

if menubar
    mb = 'figure';
    db = 'on';
else
    mb = 'none';
    db = 'off';
end

set(gcf,'toolbar', tb, 'dockcontrols', db, 'menubar', mb);