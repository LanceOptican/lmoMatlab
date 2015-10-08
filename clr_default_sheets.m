function clr_default_sheets(file)
if ~ispc
    return
end
nfile = fullfile(pwd, file);    % add full path for matlab
xls_delete_sheets(nfile, {'Sheet1', 'Sheet2', 'Sheet3'});
