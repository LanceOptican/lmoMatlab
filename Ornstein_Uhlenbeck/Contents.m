% ORNSTEIN_UHLENBECK
%
% test the files from various sources for OU processes
%
% Files
%   CalibrateOrnsteinUhlenbeck_MLE_Test              - function [ output_args ] = MLE_Test( )
%   CalibrateOrnsteinUhlenbeckLeastSquares           - Calibrate an OU process by least squares.
%   CalibrateOrnsteinUhlenbeckMaxLikelihood          - Calibrate an OU process by maximum likelihood.
%   CalibrateOrnsteinUhlenbeckMaxLikelihoodJackknife - Calibrate an O-U processes' parameters by maximum likelihood. Since the basic ML
%   CalibrateOrnsteinUhlenbeckRegress                - #ok<INUSD>
%   OU_Calibrate_LS                                  - calibrate Ornstein-Uhlenbeck process with Least-Squares method
%   OU_Calibrate_ML                                  - calibrate Ornstein-Uhlenbeck process with Maximum Likelihood method
%   ou_process                                       - Daniel Charlebois - January 2011 - MATLAB v7.11 (R2010b)
%   ou_process_orig                                  - Daniel Charlebois - January 2011 - MATLAB v7.11 (R2010b)
%   SimulateOrnsteinUhlenbeck                        - Simulate an ornstein uhlenbeck process.
%   test_ou                                          - Daniel Charlebois - January 2011 - MATLAB v7.11 (R2010b)
%   test_ou_sitmo                                    - test OU programs from sitmo
%   OU_Simulate                                      - Simulate an ornstein uhlenbeck process.
%
% final solution:
% use OU_Simulate, OU_Calibrate_LS, OU_Calibrate_ML
