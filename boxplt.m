function boxplt(varargin)
% BOXPLT( data1, title1, data2, title2,...) - draw a boxplot
% Draws out boxplots of one or more data sets
% The titles are optional.
%
% Example:
% y = randn(100,1);
% y2 = 2*randn(1000,1);
% y3 = 3+randn(200,1);
% boxplot(y,'unit variance', y2, 'wider', y3, 'shifted')

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

nargs = length(varargin);

% count the number of data sets, and collect their titles
ndatasets=0;
defaulttitles={'one' 'two' 'three' 'four' 'five' 'six' 'seven' 'eight' 'nine' 'ten'};

datasets = cell(100,1);
titles = cell(100,1);

for k=1:nargs
   if isnumeric(varargin{k})
      ndatasets = 1+ndatasets;
      datasets{ndatasets} = varargin{k};
      %peak ahead for the title
      if (k+1)<= nargs
         if ~isnumeric(varargin{k+1})
            titles{ndatasets} = varargin{k+1};
         else
            if ndatasets <= 10
               titles{ndatasets} = defaulttitles{ndatasets};             else
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

if ndatasets == 1
   [t,b] = oneboxplot(datasets{1}, 1, .4);
   axis([0 2 b-.2*(t-b) t+.2*(t-b)])
else
   tt = -1e100;
   bb =  1e100;
   for k=1:ndatasets
      [t,b] = oneboxplot(datasets{k}, k, .3);
      tt = max(t,tt);
      bb = min(b,bb);
      hold on;
   end
   axis([0 (ndatasets+1) bb-.2*(tt-bb) tt+.2*(tt-bb)]);
   hold off;
end 
set(gca,'XTick', 1:ndatasets);
set(gca,'XTickLabel',titles)

function [high, low] = oneboxplot(data, xpos, halfwidth)
% helper function for boxplots

foo = percentile(data, [.25, .50, .75]);
q1 = foo(1); q2 = foo(2); q3 = foo(3);

xleft=xpos-halfwidth; xright=xpos+halfwidth;

high = max(data);
low  = min(data);
top = min( high, q3+1.5*(q3-q1) );
bottom = max( low, q1-1.5*(q3-q1) );
outliers = data( data<bottom | data>top );
xvals = xpos*ones(size(outliers));



plot([xleft xleft xright xright xleft],[q1 q3 q3 q1 q1], 'b-',...
   [xleft xright], [q2 q2], 'r-', ...
   [xpos xpos (xpos-halfwidth/3) (xpos+halfwidth/3)],... 
   [q3 top top top],'b-', ...
   [xpos xpos (xpos-halfwidth/3) (xpos+halfwidth/3)],... 
   [q1 bottom bottom bottom],'b-',...
   xvals, outliers, 'bd',...
   [xpos xpos], [top high],'b:',...
   [xpos xpos], [bottom low], 'b:');

