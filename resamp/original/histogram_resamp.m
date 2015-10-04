function histogram_resamp(varargin)
% HISTOGRAM_resamp(data)
% LMO renamed to avoid collision with Matlab's histogram().
%
% plot out a histogram showing relative frequencies
% this means that the area of the histogram will be 1,
% measured according to the scale of the graph
%
% histogram(nbins,data)
% use the indicated number of bins for the histogram
%
% histogram(data1,[title1],data2,[title2],...)
% make several histograms, all sharing the same bins and
% plotted on the same scale, but in different windows.
%
% To make a histogram with absolute frequencies (wherein the
% height of a bar is the number of points that fall into the
% corresponding bin), use
% histogram('abs', ...)
% where ... is the remaining arguments as given above.
%
%
% Examples:
% y = randn(100,1);
% y2 = 2*randn(1000,1);
% y3 = 3+randn(200,1);
% histogram(y,'unit variance', y2, 'wider', y3, 'shifted')
% or
% histogram(100, y, 'unit variance', y2, 'wider', y3, 'shifted')
% which gives many more bars, but the same overall appearance.
% Note particularly that the areas in the two types of plots
% are directly comparable.
%
% If you want to plot several histograms on different axes,
% then call histogram separately for each axis.

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved

nbins = 0;
relative=1;
nargs = length(varargin);
argoffset = 0;  % for getting rid of 'abs' and nbins

if ~isnumeric( varargin{1} )
   if strcmp(varargin{1}, 'abs')
      relative = 0;
      argoffset = 1;
   else
      error('histogram: first argument neither data nor ''abs'' ');
   end
end

if nargs > argoffset
  if length(varargin{1+argoffset}) == 1
     nbins = varargin{1+argoffset};
     argoffset = argoffset+1;
  end
end

% count the number of data sets, and collect their titles
ndatasets=0;
defaulttitles={'one' 'two' 'three' 'four' 'five' 'six' 'seven' 'eight' 'nine' 'ten'};

datasets = cell(100,1);
titles = cell(100,1);
if nargs > argoffset
   for k=(argoffset+1):nargs
      if isnumeric(varargin{k})
         ndatasets = 1+ndatasets;
         datasets{ndatasets} = varargin{k};
         %peak ahead for the title
         if (k+1)<= nargs
            if ~isnumeric(varargin{k+1})
               titles{ndatasets} = varargin{k+1};
            else
               if ndatasets <= 10
                  titles{ndatasets} = defaulttitles{ndatasets};
               else
                  titles{ndatasets} = num2str(ndatasets);
               end
            end
         else 
            if ndatasets <= 10
                titles{ndatasets} = defaulttitles{ndatasets};
            else
                titles{ndatasets} = num2str(ndatasets);
            end
         end
      end
   end
else
   error('histogram: no data arguments provided.')
end

if ndatasets == 1
   dohist1(nbins, relative,titles{1},datasets{1});
else
   newtitles = cell(ndatasets,1);
   newdata = cell(ndatasets,1);
   for k=1:ndatasets
      newdata{k} = datasets{k};
      newtitles{k} = titles{k};
   end
   
   dohistmany(nbins, relative, newtitles, newdata );
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [res, mess,y,b] = dohist1(bins, relative, titlestring, data, ymax, noplot)
% dohist1(bins, relative, titlestring, data, ymax, noplot)
% internal, helper program for plotting histograms
% bins is either the number of bins to use, or the bin centers
% relative == 1, plot relative frequencies
% relative == 0, plot absolute frequencies
% titlestring -- a string to title the graph
% data, a column of data to be histogrammed
% ymax :: the maximum value on the y axis
% noplot :: suppress plotting
%
% returned value res is 0 for success, 1 for failure
% returned value mess contains the error message
% returned value y is the maximum value of the y axis.
% returned value b is the list of bins

% set default value
if nargin < 6  
   noplot = 0;  % do the plot
end
if nargin < 5
   ymax = 0;    % automatically scale the axis
end
if nargin < 3
   res = 1;
   mess = 'not enough arguments.';
   return;
end

nbins = length(bins);
if length(data) < 2
   res = 1;
   mess = 'must give >= 2 data points for histogram.';
   return;
end

if nbins == 1
   if bins == 0 
      bins = floor(2 + 2*log(length(data)));
   end
end


[n, x] = hist(data, bins);
binwidth = x(2) - x(1);

ylab = 'Abs. Freq.';
if relative == 1
   n = n./(binwidth*length(data));
   ylab = 'Rel. Freq.';
end

if ymax == 0
   ymax = 1.2*max(n);
end
ymin = 0;
nmin = min(x);
nmax = max(x);
nbins = length(x);
slop = (0.1*(nmax-nmin) + binwidth);

xmin = nmin - slop;
xmax = nmax + slop;
y = ymax;

if ~noplot
   bar(x,n,1);
   axis([xmin xmax ymin ymax]);
	ylabel(ylab);   
   text(xmin+ .03*(xmax-xmin),.85*ymax,titlestring);   
end

b = x;
res = 0;
mess = 'no error';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dohistmany(bins,relative,titlearray,dataarray)
% dohistmany
% internal, helper function for plotting many histograms
% with the same axes
ndatasets = length(dataarray);
data = makerow(dataarray{1});
for k = 2:ndatasets
   data = concat(data, dataarray{k});
end

% find good bins
[r,mess,y,b] = dohist1(bins, relative, 'all',data,0,1);
if r == 1
   error(mess);
end

% find a good y-scale
ys = zeros(ndatasets,1);
for k=1:ndatasets
   [r,mess,y,b1] = dohist1(b,relative,'bogus',dataarray{k},0,1);
   ys(k) = y;
end

ybest = max(ys);

% make the histograms
plotrows = floor(1+ndatasets/6);
plotcols = ceil(ndatasets/plotrows);

for k=1:ndatasets
   subplot(plotcols, plotrows,k);
   [r,mess,y,b1] = dohist1(b,relative,titlearray{k},dataarray{k},ybest);
end

