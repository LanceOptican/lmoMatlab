% fix file separator for any OS
% str = fixFileSep(str)

function str = fixFileSep(str)
if isempty(str)
    return
end
if isunix || ismac
    k = regexp(str, '\\');
    str(k) = filesep;
else
    k = regexp(str, '/');
    str(k) = filesep;
end
