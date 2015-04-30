% revision 1.00.1 beta, 07/01/04

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

function selftestAMModel_init

% this file is used to initialize model parameters

global def
global work
global simwork

% the example model is so simple, there is not much to initialize.
% Some filter coefficients used in example_preproc

simwork.AMthreshold = -22.5;

%eof
