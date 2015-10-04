% startup that adds paths for lmoLocal files and subdirectories

% where to put the files
local = fullfile(matlabroot, 'toolbox', 'local', 'LMO');

% add local itself
addpath(local)
disp(['addpath ', local]);

% add subdirectories
addList = {
    'grinsted-wavelet-coherence-b3b1867'
    'resamp'
    'psignifit4'
    };

for k = 1 : length(addList)
    addpath(fullfile(local, addList{k}))
    disp(['addpath ', addList{k}]);
end
