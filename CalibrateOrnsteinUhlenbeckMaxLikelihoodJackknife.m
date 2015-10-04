function [ mu, sigma, lambda ] = CalibrateOrnsteinUhlenbeckMaxLikelihoodJackknife(S, deltat,T)
%% Calibrate an O-U processes' parameters by maximum likelihood. Since the basic ML
%% calibration has a bias (resulting in frequent estimates of lambda which are much too
%% high), we perform a 'jackknife' operation to %% reduce the bias.
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
%% Reference.
% To get a less biased lambda, we just the jackknife procedure described in
% Phillips, Peter C. B., and Jun Yu. 2005. 'Jackknifing Bond Option Prices.'
% The Review of Financial Studies 18, no. 2 (Summer): 707-742.
% http://www.jstor.org/stable/3598050

 m = 2; % Number of partitions.
 partlength = floor(length(S)/m);

 Spart = zeros(m,partlength);
 for i=1:1:m
 Spart(i,:) = S(partlength*(i-1)+1:partlength*i);
 end
 %fprintf('n = %d\n', length(S));

 %% Calculate for entire partition.
 [ muT, sigmaT, lambdaT ] = CalibrateOrnsteinUhlenbeckMaxLikelihood(S, deltat, T);

 %% Calculate the individual partitions.
 mupart = zeros(m,1);
 sigmapart = zeros(m,1);
 lambdapart= zeros(m,1);
 for i=1:1:m
 [ mupart(i), sigmapart(i), lambdapart(i) ] = ....
 CalibrateOrnsteinUhlenbeckMaxLikelihood(Spart(i,:), deltat, T/m);
 end
 %% Now the jacknife calculation.
 lambda = (m/(m-1))*lambdaT - (sum(lambdapart))/(m^2-m);

 % mu and sigma are not biased, so there's no real need for the jackknife.
 % But we do it anyway for demonstration purposes.
 mu = (m/(m-1))*muT - (sum(mupart ))/(m^2-m);
 sigma = (m/(m-1))*sigmaT - (sum(sigmapart ))/(m^2-m);
end