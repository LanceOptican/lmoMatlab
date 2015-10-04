function res = between(data, low, high)
% BETWEEN( data, low, high ) 
% determines whether data is between low and high (inclusive)

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0


res = data >= low & data <= high;

