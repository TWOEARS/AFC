
% prob = mml_psyfcn( value, floorProb, psyfcn50, psyfcnSlope )
%
% This is the errorfunction ranging between floorProb and 1.
% floorProb is should be 1 devided by the number of presentation intervals 
% (chance level for correct response).
% In case of only one presentation interval it should be 0.
% psyfcn50 is the 0.5 (50%) correct point of the unbiased psychometric function (floorProb = 0).
% If floorProb is greater than zero, it transformes to 0.5*(1 + floorProb).
% psyfcnSlope is the slope of the unbiased psychometric function at psyfcn50.
% If floorProb is greater than zero, it transformes to psyfcnSlope*(1 - floorProb).

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

% 1/(psyfcnSlope*sqrt(2*pi)) = sigma

function prob = mml_psyfcn( value, floorProb, psyfcn50, psyfcnSlope )

prob = floorProb + ((1-floorProb)*((1+erf((value-psyfcn50)*psyfcnSlope*sqrt(pi)))/2));

% eof
