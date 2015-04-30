
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

% last modified 25-02-2013 21:00:24

function afc_getCurrentCalLevel

global work
global def

if ( def.calScriptEnable ~= 1 )
    return;
end

if (strcmp(def.calTableEqualize,'fir') == 1)
    targetIdx = find(def.calTable(:,1)==def.calTableEqualizeRefFreq);

    if isempty(targetIdx)
        %error('AFC:calibration','No entry for def.calTableEqualizeRefFreq in def.calTable');
        error('No entry for def.calTableEqualizeRefFreq in def.calTable');
    end

    targetLevel = def.calTable(targetIdx(1),2:end);

else
    calTableSize = size(def.calTable);
    if ( calTableSize(1) == 1 ) % only one freq, disregard lookup value
        if ( calTableSize(2) > 1 )
            targetLevel = def.calTable(1,2:end);
        else
            targetLevel = def.calTable(1,1);
        end
    else
        targetIdx = find(def.calTable(:,1)==def.calTableLookupFreq);

        if isempty(targetIdx)
            %error('AFC:calibraion','No entry for def.calTableLookupFreq in def.calTable');
            error('No entry for def.calTableLookupFreq in def.calTable');
        end

        if ( calTableSize(2) > 1 )
            targetLevel = def.calTable(targetIdx,2:end);
        else
            targetLevel = def.calTable(targetIdx,1);
        end
    end

end

if ( size(targetLevel,2) == 1 )
    targetLevel = ones(def.outputChannels,1)*targetLevel;
elseif ( size(targetLevel,2) ~= def.outputChannels )
    error('Number of channels in def.calTable does not match outputChannels');
end

if ~isempty(def.calTableExcessLevel)
    if ( size(def.calTableExcessLevel,2) == 1 )
        targetLevel = targetLevel + def.calTableExcessLevel(1,1);
    elseif ( size(def.calTableExcessLevel,2) == def.outputChannels )
        targetLevel = targetLevel + def.calTableExcessLevel(1,1:def.outputChannels);
    else
        error('Number of channels in def.calTableExcessLevel does not match outputChannels');
    end
end

work.currentCalLevel = targetLevel;

% eof