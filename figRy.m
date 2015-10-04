% FIG - Create a figure window and handle it with its name.
%
% FIG handles figures with names instead of numbers as FIGURE does. This is
% useful when you have lot of different plots that different MATLAB scripts
% create.
%
% FIG figname   OR    FIG('figname') creates a new figure window with the name
% 'figname'. If the figure with the name 'figname' already exist that will be
% reused and activated as current window. FIG returns the figure hander number
% for the figure and it is a non integer number to not be mixed and reused by
% calls to FIGURE. With fig you can skip use of figure handler variables and
% and replace input of handlers to function by FIG('figname') as in following
% example.
%
% Example:
%
%    fig ModelA
%    plot([1 3 3]);
%    fig ModelB
%    plot([1 2 3]);
%    set(fig('ModelA'),'pointer','cross'); 
%    set(fig('ModelB'),'pointer','left');
%
% In this example the figure windows 'ModelA' and 'ModelB' will be reused each
% time you run the script.
%
% Se also: FIGURE
%
%
%   Copyright (C) Peter Rydesäter 2001, Mitthögskolan, SWEDEN
%
%   This program is free software; you can redistribute it and/or
%   modify it under the terms of the GNU General Public License
%   as published by the Free Software Foundation; either version 2
%   of the License, or (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program; if not, write to the Free Software
%   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%   
%
%   Please, send me an e-mail if you use this and/or improve it. 
%   If you think this is us full fore your work, please remember me and my
%   hard work with it!
%
%   Peter.Rydesater@mh.se
%
%   Peter Rydesäter
%   Mitthögskolan (Mid Sweden University)
%   SE-831 25 ÖSTERSUND
%   SWEDEN
%

function varargout=fig(str)
  if nargin==0,
    str='';
  end
  if ischar(str)==0,
    figh=figure(str);
  else
    figh=get(0,'Children');
    figh=findobj(figh,'Tag',str);
    if length(figh)==0,
      figh=figure;
      set(figh,'Tag',str,'Name',str,'NumberTitle','off','IntegerHandle','off');
    else
      figure(figh);
    end
    figh=figh(1);
  end
  if nargout>0,
    varargout{1}=figh;
  end
  return;
  