function tilefigs(tile, border, nobars)
% <cpp> tile figure windows usage: tilefigs ([nrows ncols],border_in pixels, nobars)
% nobars = 1 causes toolbar and menubar to be suppressed
% Restriction: maximum of 100 figure windows
% Without arguments, tilefigs will determine the closest N x N grid


%Charles Plum                    Nichols Research Corp.
%<cplum@nichols.com>             70 Westview Street
%Tel: (781) 862-9400             Kilnbrook IV
%Fax: (781) 862-9485             Lexington, MA 02173
%
% LM Optican  15may07   fix spacing on Windows XP for titlebar

maxpos  = get (0,'screensize'); % determine terminal size in pixels
hands   = get (0,'Children');   % locate fall open figure handles
hands   = sort(hands);          % sort figure handles
numfigs = size(hands,1);        % number of open figures
maxfigs = 100;

if (numfigs>maxfigs)            % figure limit check
    disp([' More than ' num2str(maxfigs) ' figures ... get serious pal'])
    return
end

if nargin == 0
    maxfactor = sqrt(maxfigs);       % max number of figures per row or column
    sq = [2:maxfactor].^2;           % vector of integer squares
    sq = sq(find(sq>=numfigs));      % determine square grid size
    gridsize = sq(1);                % best grid size
    nrows = sqrt(gridsize);          % figure size screen scale factor
    ncols = nrows;                   % figure size screen scale factor
elseif nargin > 0
    nrows = tile(1);
    ncols = tile(2);
    if numfigs > nrows*ncols
        disp ([' requested tile size too small for ' ...
            num2str(numfigs) ' open figures '])
        return
    end
end
if nargin < 2
    border = 0;
end
if nargin < 3
    nobars = 0;
end


window_edge_wd = 4;
titlebar_ht = 78;
if nobars
    toolbar_ht = 27;
    menubar_ht = 21;
    titlebar_ht = titlebar_ht - toolbar_ht - menubar_ht;
end

xlen = (maxpos(3)/ncols) - 2*window_edge_wd - 2*border; % new tiled figure width
ylen = (maxpos(4)/nrows) - titlebar_ht - window_edge_wd - 2*border; % new tiled figure height


% tile figures by position
% Location (1,1) is at upper left corner
cellHt = maxpos(4) / nrows;
cellWd = maxpos(3) / ncols;
pnum=0;
for iy = 1:nrows
    ypos = maxpos(4) - iy*cellHt + window_edge_wd + border + 1; % figure location (row)
    for ix = 1:ncols
        xpos = (ix-1)*cellWd + window_edge_wd + border + 1;     % figure location (column)
        pnum = pnum+1;
        if (pnum>numfigs)
            break
        else
            figure(hands(pnum))
            set(hands(pnum),'Position',[ xpos ypos xlen ylen ]); % move figure
            if (nobars)
                setfigbars(0, 0);
            else
                setfigbars(1, 1);
            end
        end
    end
end
return


% -------------------------------------------------------------------------