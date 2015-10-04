% set parameters (width, format) for excel spreadsheet
function setExcelParams(file, sheet, sheetName, colWidth, colFmt)
% open it
hExcel = actxserver('Excel.Application');
hWorkbook = hExcel.Workbooks.Open(fullfile(pwd, file));
hWorksheet = hWorkbook.Sheets.Item(sheet);

hWorksheet.name = sheetName;

for c = 1:length(colWidth)
    hWorksheet.Columns.Item(c).columnWidth = colWidth(c);
    hWorksheet.Columns.Item(c).NumberFormat = colFmt{c};
end

% close it
hWorkbook.Save;
hWorkbook.Close;
hExcel.Quit;
delete(hExcel);
