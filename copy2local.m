% copy2local
% this program copies all the files in the LMOlocal directory to subdirectory
% called LMO under the MATLAB local toolbox. Only files in lmoLocal that
% are newer than those in the local tooblox are copied. If files in Dest
% are nwere, they are copied into lmoLocal
%
% LMO 30mar2015 create
% LMO 5apr3015 make bidirectional
timerstart

debug = 0;

lmoLocal = pwd;
% check that are in correct directory
[pathstr,name,ext] = fileparts(lmoLocal);
if strcmp('lmoLocal', name) == 0
    error('copy2local should only be run from the lmoLocal directory');
    return
end

if ~isdir(lmoLocal)
    error(sprintf('Source: %s is not a valid folder location', lmoLocal));
    return
end

parentFolder = fullfile(matlabroot, 'toolbox', 'local');
dest = fullfile(parentFolder, 'LMO');
if ~isdir(dest)
    str = input('Do you want to create Matlab toolbox/local/LMO directory?:\n(yes/no): ','s');
    if strcmp(str, 'yes')
        [status,message,messageid] = mkdir(parentFolder,'LMO');
        if status ~= 1
            if debug
                disp(message);
            end
            return
        end
    else
        disp('Copy Cancelled');
        return
    end
end

res = input('copy2local: Copy all newer of lance''s m-files to matlab''s toolbox/local folder?\n(yes or no): ', 's');
if strcmp('yes', res) == 0
    disp('Copy Cancelled');
    return
end

disp('Checking modification dates...');
dirSrc = dir2(lmoLocal, '-r');
dirDest = dir2(dest, '-r');

nSrc = numel(dirSrc);
nDest = numel(dirDest);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% go through each file in Src, and check if it exists or is younger or older in Dest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = struct2cell(dirDest);   % convert to structure for search
files = cell(nSrc, 1);
type = [];
revrse = [];
nFiles = 0;

for k = 1:nSrc
    rev = 0;
    s = dirSrc(k);
    nmSrc = s.name;
    if isempty(nmSrc) || nmSrc(1) == '.' || numel(nmSrc) < 4 || nmSrc(end) == '~' || strcmp(nmSrc((end-3):end), '.asv') % skip . or ~ files
        fprintf('Skipping1 %s\n', nmSrc);
        continue
    end
    
    % check for subdirectory with . file
    ix = strfind(nmSrc, filesep);
    skip = 0;
    for kix = 1:length(ix)
        if ~isempty(ix) && nmSrc(ix(kix)+1) == '.'
            fprintf('Skipping2 %s\n', nmSrc);
            skip = 1;
            break
        end
    end
    if skip
        continue
    end
    
    loc = find(ismember(d(1,:), nmSrc));    % find src in dest
    if ~isempty(loc)
        dateSrc = s.datenum;
        dateDest = dirDest(loc).datenum;
        
        if debug
            if strfind(nmSrc, 'copy2local')
                fprintf('%s %s %s %s %10.8f\n', ...
                    dirSrc(k).name, datestr(dirSrc(k).date), dirDest(loc).name, datestr(dirDest(loc).date), (dirSrc(k).date - dirDest(loc).date));
            end
        end
        
        if (dateSrc - dateDest) > 1e-5 % must be newer by at least a second
            %             disp([dateSrc, dateDest, dateSrc - dateDest])
            rev = 0;
        elseif (dateSrc - dateDest) < -1e-5 % dest is newer by at least a second
            %             disp([dateSrc, dateDest, dateSrc - dateDest])
            rev = 1 - 2 * (s.isdir);
        else
            continue
        end
    end
    
    nFiles = nFiles + 1;
    files{nFiles} = nmSrc;
    type(nFiles) = s.isdir;
    revrse(nFiles) = rev;
    
    if debug
        fprintf('n = %d, file = %s\n', nFiles, files{nFiles});
    end
end

if nFiles < nSrc
    files((nFiles+1):end) = [];
    type((nFiles+1):end) = [];
    revrse((nFiles+1):end) = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% copy the files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nFiles
    fprintf('\nCopying %d files ...\n', nFiles);
    for k = 1:nFiles
        if debug
            fprintf('%d: %d %s\n', k, type(k), files{k});
        end
        if type(k)
            [status, message] = mkdir(fullfile(dest, files{k}));
            if length(message) > 1
                if debug
                    %                     disp(message)
                end
            end
        else
            [pathstr, filename, fileext] = fileparts(files{k});
            if length(pathstr)
                dest2 = fullfile(dest, pathstr);
            else
                dest2 = dest;
            end
            if exist(dest2, 'dir') && type(k) == 1
                [status, message] = mkdir(dest2);
                if debug
                    if length(message) > 1
                        %                         disp(message)
                    end
                end
            end
            
            % copy file in appropriate directeion
            if revrse(k) == 1
                dest3 = fullfile(dest2, [filename, fileext]);
                fprintf('reverse copy %s --> %s\n', dest3, lmoLocal);
                [out, msg, msgid] = copyfile(dest3, lmoLocal, 'f');
            else
                fprintf('forward copy %s --> %s\n', files{k}, dest2);
                [out, msg, msgid] = copyfile(files{k}, dest2, 'f');
            end
            if out == 0
                disp(sprintf('Error: %s, %d', msg, msgid));
            end
        end
    end
    
    % also, copy the startup file to toolbox/local
    [out, msg, msgid] = copyfile('startupLocalLMO.m', parentFolder);
    if out == 0
        disp(sprintf('Error: %s, %d', msg, msgid));
    end
else
    fprintf('\nNo files to copy!\n');
end

timerend