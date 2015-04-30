
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

function cost = mml_costfcn( x, value, response, floorProb )

psyfcn50 = x(1);
psyfcnSlope = x(2);

prob = mml_psyfcn( value, floorProb, psyfcn50, psyfcnSlope );

posResponse = find(response);
negResponse = find(1-response);

cost = -(prod(prob(posResponse)) * prod(1-prob(negResponse)));

%cost = -(sum(prob(posResponse)) + sum(1-prob(negResponse)));

% eof
