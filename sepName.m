% fix file name separators for win/mac/linux
function nm = fixFileSep(nm)
nm = regexprep(nm,'[/\\]',filesep);
