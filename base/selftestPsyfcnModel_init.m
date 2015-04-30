
%------------------------------------------------------------------------------
% AFC for Mathwork’s MATLAB
%
% Version 1.40.0
%
% Author(s): Stephan Ewert
%
% Copyright (c) 1999-2014, Stephan Ewert. 
% All rights reserved.
%
% This work is licensed under the 
% Creative Commons Attribution-NonCommercial-NoDerivs 4.0 International License (CC BY-NC-ND 4.0). 
% To view a copy of this license, visit
% http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to Creative
% Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
%------------------------------------------------------------------------------

function selftestPsyfcnModel_init

% this file is used to initialize model parameters

global def
global work
global simwork

% the example model is so simple, there is not much to initialize.


% define 50% point
simwork.psyfcn50 = -18;
simwork.psyfcnSlope = 0.1;%0.25;
% should result in -17.55 for 1up 2down 3 interval

%eof
