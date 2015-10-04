function r2 = getR2(y, yfit)
    % get R^2 from most general form (due to Kvalseth, 1985);
    SStot = sum((y - mean(y)).^2);  % total sum of squares
    SSerr = sum((y - yfit).^2);  % sum of squared errors (i.e., residual sum of squares)
    r2 = 1 - SSerr / SStot;
end
