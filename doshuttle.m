% carry out the bayesian space shuttle example 

engineering = uniform(0,0.0001);
unkunk = uniform(0,1);
prior = urn(.25, engineering, .75, unkunk);

% for the first flight
pos1 = updateshuttle( prior, 0 ); % no crash
% for the second flight, pos1 becomes the prior
pos2 = updateshuttle( pos1, 0);   % no crash
pos3 = updateshuttle( pos2, 0);   % no crash
pos4 = updateshuttle( pos3, 0);   % no crash
pos5 = updateshuttle( pos4, 0);   % no crash
pos6 = updateshuttle( pos5, 0);   % no crash
pos7 = updateshuttle( pos6, 0);   % no crash
pos8 = updateshuttle( pos7, 0);   % no crash
pos9 = updateshuttle( pos8, 0);   % no crash
pos10 = updateshuttle( pos9, 0);   % no crash
pos11 = updateshuttle( pos10, 0);   % no crash
pos12 = updateshuttle( pos11, 0);   % no crash
pos13 = updateshuttle( pos12, 0);   % no crash
pos14 = updateshuttle( pos13, 0);   % no crash
pos15 = updateshuttle( pos14, 0);   % no crash
pos16 = updateshuttle( pos15, 0);   % no crash
pos17 = updateshuttle( pos16, 0);   % no crash
pos18 = updateshuttle( pos17, 0);   % no crash
pos19 = updateshuttle( pos18, 0);   % no crash
pos20 = updateshuttle( pos19, 0);   % no crash
pos21 = updateshuttle( pos20, 0);   % no crash
priorsamp = sample(1000, prior);
