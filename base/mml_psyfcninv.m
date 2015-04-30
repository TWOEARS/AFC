
% value = mml_psyfcninv( prob, floorProb, psyfcn50, psyfcnSlope )
%
% This is the inverse to mml_psyfcn

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

% last modified 29-06-2006 15:37:51
% revision 1.00.1 beta, 07/01/04

function value = mml_psyfcninv( prob, floorProb, psyfcn50, psyfcnSlope )

%prob = floorProb + ((1-floorProb)*((1+erf((value-psyfcn50)*psyfcnSlope*sqrt(pi)))/2));

value = (erfinv((prob - floorProb)/(1-floorProb)*2-1))/(psyfcnSlope*sqrt(pi))+psyfcn50;

% eof
