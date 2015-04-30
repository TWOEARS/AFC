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

function response = selftestLevelModel_main

% the model_main function must return the presentation interval selected by the model

global def
global work
global simwork

% we select only the left channels, the model is monaural
tmpSig = work.signal(:,1:2:end);

% now we check whether the test or the reference interval has the higher
% level

tmprms = std(tmpSig,0,1);
detect = find(tmprms == max(tmprms));

% if detected than select the current signal position as the response interval, select a random one from the
% remaining intervals otherwise 
switch detect
    case 1
        response = work.position{work.pvind}(end);
    otherwise
        if def.intervalnum > 1
            responseTmp = randperm( def.intervalnum );
            response = work.position{work.pvind}(end);
            i = 1;
            while ( response == work.position{work.pvind}(end) )
                response = responseTmp(i);
                i = i + 1;
            end
        else
            response = 2;
        end
end

%work.position{work.pvind}(end)
%response
%pause

% eof
