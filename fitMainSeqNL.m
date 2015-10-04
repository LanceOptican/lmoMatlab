% fit nonlinar function: fit main sequence peak vel vs. amp
% from Inchingolo, et al., 1985
%   Vpk = 1/(P(1) + (P(2)/Amp))
% but we rearrange so that the fit is:
% Vpk = 1 / (1/P(1) + 1/(P(2)*Amp)),
% which makes P(1) the asymptote, and P(2) ~ Angle Constant * Asymptote
% if a < 0, reverses everyhing, computes, restores
% input:
%   P0 is the initial parameter guess:
%       P(1) = asymptote = VpkMax
%       P(2) = initial slope ~ AngleConstant * VpkMax
%   a is amplitude
%   v is peak velocity
%   eFlag = eval only flag, so yfit is evaluated at [a(1):a(end)] with P0.
%   lblFlag = add labels for P
% output:
%   P is fitted parameter vector
%   [afit, vfit] is the fitted function.
%
% 5dec2014  LM Optican    create
%
function [P, afit, vfit, ht] = fitMainSeqNL(P0, a, v, eFlag, lblFlag)

% initial guess
if isempty(P0)
    P0 = [1/200, 1/12];
end

if ~eFlag
    [P,fval,exitflag,output] = fminsearch(@(P) errfunc(P, a, v), P0, optimset('TolX',1e-12, 'TolFun', 1e-12, 'MaxIter', 1e3, 'MaxFunEvals', 1e5));
else
    P = P0;
end

% divide up range for output fit
nPoints = 100;
lo = min(a);
hi = max(a);
afit = lo + ((0:nPoints)/nPoints) * (hi - lo);
vfit = fitfunc(afit, P);
vhat = fitfunc(a, P);
[Rsquared, adjRsquared] = Rsquares(v, vhat, numel(P));

if lblFlag
    ax = axis;
    ty = 0;
    tx = (hi + lo) / 2;
    ht = text(tx, ty, sprintf('R^2 = %5.3f, aR^2 = %5.3f\nV_p = 1/(1/%5.1f + 1/(%5.1fA))', ...
        Rsquared, adjRsquared, P(1), P(2)));
    ty = 0.05 * (ax(4) - ax(3));
    set(ht, 'horizontalalignment', 'center', 'verticalalignment', 'bottom');
else
    ht = [];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HELPER FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute error
function err = errfunc(P, a, v)
% add constraints by creating forbidden region
if ((P(1) < eps) || (abs(P(2)) < eps))
    err = 1e10;
else
    err = v - fitfunc(a, P);
    err = dot(err, err);
end
    
% compute function
function v = fitfunc(a, P)

a = abs(a);
v = zeros(size(a));
% v = 1 ./ (P(1) + (P(2) ./ a));
v = 1 ./ ((1/P(1)) + (1./(P(2)*a)));

