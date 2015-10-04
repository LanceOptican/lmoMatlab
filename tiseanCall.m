function [status, nums, cmnts] = tiseanCall(string, input)
%
% [status, nums, cmnts] = tiseanCall(string, input)
%
% uses "system" to call TISEAN program with
% arguments in "string"
% input:
%   string = the TISEAN command
%   input = matrix to be sent to the command
% output:
%   status = 0 if call succeeds
%   nums = matrix of output numbers
%   cmnts = comments pulled from text file before conversion to matrix
%
% LMO   10may07  create
% LMO   11may07  add special case for ghkss program

% init
status = 1;
cmnts = [];
nums = [];
rand('seed', sum(100 * clock));

% if input matrix, save as file for TISEAN call
if (nargin > 1)
    rndin = [freename('./', 'tc', 4) '.dat'];
    [nr,nc] = size(input);
    if (nc > nr)
        input = input';
    end
    save(rndin, 'input', '-ascii');
else
    rndin = '';
end

% uses CYGWIN to run unix commands
CYGWIN_ROOT='c:\cygwin';          % <--------------  DOS syntax here

% get TISEAN files path
tiseanBin = ['.\Tisean_3.0.0\bin'];

% set search path
pth = ['SET PATH=' tiseanBin ';' CYGWIN_ROOT '\usr\local\bin;' CYGWIN_ROOT '\bin;%SYSTEMROOT%\system32;%SYSTEMROOT% && '];

%
%
% run the command
%
% get a random output name
rndout = [freename('./', 'tc', 4) '.dat'];

% run the command
[status, txt] = system([pth  string ' ' rndin ' -o ' rndout]);
%
%

if status ~= 0
    delFiles(rndin, rndout);
    return
end

fid = fopen(rndout, 'r');
if (fid < 0)
    if (strfind(string, 'ghkss'))  % ghkss changes the output file name, so need special case
        k = strfind(string, '-i');
        if (length(k))
            n = sscanf(string((k+2):end), '%d');
            n = n(1);
        else
            n = 1;
        end
        fid = fopen(sprintf('%s.%d', rndout, n), 'r');
        if (fid < 0)
            delFiles(rndin, rndout);
            status = 3;
            return;
        else
            nums = fscanf(fid, '%g', inf);
            fclose(fid);
        end
        for i = 1:n
            fn = sprintf('%s.%d', rndout, i);
            delete(fn); % delete tmp files
        end
    else
        rndout
        status = 2;
        delFiles(rndin, rndout);
        return;
    end
else
    while(1)
        line = fgets(fid);  % read file one line at a time
        if (line < 0)
            break
        end
        a = str2num(line);
        if (isempty(a))
            cmnts = [cmnts, line];
        else
            nums = [nums; a];
        end
    end
    fclose(fid);
    delFiles(rndin, rndout);
end

function delFiles(rndin, rndout)
% delete tmp files
if (length(rndin))
    delete(rndin);
end
if (length(rndout))
    delete(rndout);
end
