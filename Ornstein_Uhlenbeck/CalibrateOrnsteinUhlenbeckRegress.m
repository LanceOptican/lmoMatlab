function [ mu, sigma, lambda ] = CalibrateOrnsteinUhlenbeckRegress(S, deltat, bigt)
%#ok<INUSD>
% Calibrate an OU process by a simple discrete time regression.
% Does not properly take the reversion into account, meaning this will
% become inaccurate for large deltat.
%
% Use CalibrateOrnsteinUhlenbeckLeastSquares if deltat is small.
%
%% License
% Copyright 2010, William Smith, CommodityModels.com . All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification, are
% permitted provided that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice, this list of
% conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice, this list
% of conditions and the following disclaimer in the documentation and/or other materials
% provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER, WILLIAM SMITH ``AS IS'' AND ANY EXPRESS
% OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
% THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
% OF SUBSTITUTE GOODS ORSERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 % Regressions prefer row vectors to column vectors, so rearrange if
 % necessary.
 if (size(S,2) > size(S,1))
 S = S';
 end
 % Regress S(t)-S(t-1) against S(t-1).
 [ k,dummy,resid ] = regress(S(2:end)-S(1:end-1),[ ones(size(S(1:end-1))) S(1:end-1) ] );
 a = k(1);
 b = k(2);
 lambda = -b/deltat;
 mu = a/lambda/deltat;
 sigma = std(resid) / sqrt(deltat);
end
