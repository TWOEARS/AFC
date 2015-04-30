
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

% last modified 19-04-2013 13:16:41

% Copyright (c) 1999 - 2004 Stephan Ewert. All rights reserved.
% $Revision: 1.00.1 beta$  $Date: 2004/01/11 10:01:37 $

function afc_misc( action )

global def
global work

switch action
    case 'checkDef'
        fnTmp = fieldnames(def);
        warningIssued = 0;
        %	if work.numDefFields ~= size(fnTmp,1)

        % FIXME autoconstruct this list after first load of default cfg, however needs some tweaking anyhow
        % varname, type ( 0 = not numeric, 1 = numeric, 2 = both possible)
        matchList = def.configurationVariableList;
        

        %		work.numDefFields = size(fnTmp,1);
        for i = 1:size(fnTmp,1)

            % find perfect match
            matchMask = strcmp(matchList(:,1), fnTmp{i});
						
						% ugly workaround for char limitation to <32 in field names in Matlab 5.3
						if ( work.matlabVersion < 6 & sum(matchMask) == 0 )
							if ( strcmp('skippedMeasurementProcedureSave', fnTmp{i}) )
            		matchMask(1) = 1;
            	end
            end
						
            if ( sum(matchMask) ~= 1 )
                ind = 0;

                % check again without case sensitivity
                matchMaski = strcmpi(matchList(:,1), fnTmp{i});

                if ( sum( matchMaski ) == 1 )
                    ind = min(find( matchMaski ));
                end

                %warning('AFC:misc', ['Unrecognised configuration variable def.' fnTmp{i}]);

                %warning(['Unrecognised configuration variable def.' fnTmp{i}]);

                if ( warningIssued == 0 )
                    warning('One or more variables in structure def did not pass the integrity check');
                    warningIssued = 1;
                end

                disp(['Warning: Unrecognised configuration variable']);
                disp(['def.' fnTmp{i}]);

                if ( ind > 0 )
                    disp(['Replace by:']);
                    disp(['def.' matchList{ind,1}]);
                else

                    % FIXME: can be better done using regexpi
                    ind = [];
                    ind2 = [];

                    % count chars in the token
                    charNum = length(fnTmp{i});
                    charPart = floor(charNum/2);

                    if charPart > 4
                        charPart = 4;
                    end

                    if charPart > 0
                        % lets try to find possible completions for the start characters
                        ind = strmatch(fnTmp{i}(1:charPart),matchList(:,1));

                        % lets try to find possible completions for the last characters
                        % need to cycle by hand
                        ind2 = [];
                        for k = 1:size(matchList,1)
                            if ( length(matchList{k,1}) >= charPart )
                                if strcmp( fnTmp{i}(end-charPart+1:end) , matchList{k,1}(end-charPart+1:end) )
                                    ind2 = [ind2; k];
                                end
                            end
                        end

                        % reduce list to identical entries if any
                        if ~isempty( intersect(ind, ind2) )
                            ind = intersect(ind, ind2);
                        else
                            % otherwise reduce to unique entries
                            ind = unique([ind; ind2]);
                        end

                        % display the suggestions
                        if ( ~isempty(ind) )
                            disp(['Did you mean:']);
                            for k = 1:min(size(ind,1),3) % show only 3 possible completitions
                                disp(['def.' matchList{ind(k),1}]);
                            end
                        end

                    end
                end

                disp(['   ']);

                % force to check again
                %work.numDefFields = 0;

            elseif ( sum(matchMask) == 1 )
                % found unique perfect match, check type

                ind = min(find(matchMask));

                if ( matchList{ind,2} ~= 2 )

                    % copy the field entry to tmp
                    eval([ 'tmp = def.'  matchList{ind,1} ';']);

                    % check whether type matches the expected type
                    if ( matchList{ind,2} ~= isnumeric(tmp) )

                        if ( warningIssued == 0 )
                            warning('One or more configuration variables did not pass the integrity check');
                            warningIssued = 1;
                        end

                        % display the warning
                        if ( matchList{ind,2} == 0 )
                            disp(['Warning: def.' matchList{ind,1} ' should be a string']);
                        else
                            disp(['Warning: def.' matchList{ind,1} ' should be a numeric value']);
                        end
                    end
                end

            end
        end


        if ( warningIssued == 1 )
            disp('If not in debugging mode, use def.variableCheck = 0 to suppress this warning');
        elseif ( def.debug > 0 )
            disp('All configuration variables have passed the integrity check');
        end
        %	end

    case 'checkVersionIssues'

        % SE 26.02.2013 13:55:24
        if ( work.matlabVersionRelease > 7.1 )
            if ( strcmp(def.internSoundCommand, 'sound') & strcmp(def.externSoundCommand, '') & def.markinterval > 0 )
                disp(['Warning: button marking and usage of sound in def.internSoundCommand not supported in MATLAB 2011 or higher']);
            end
        end
        
        % SE 24.02.2015
        if ~(ispc == 1 | ( ismac == 1 & work.matlabVersionRelease > 7.1 ))
            % only issue a warning if we try to use audioplayer with a
            % specified deviceID other than the default
            if (strcmp(def.internSoundCommand, 'audioplayer') & strcmp(def.externSoundCommand, '') & def.deviceID > -1)
                disp(['Warning: afc_misc: this system and Matlab version do not support selection of deviceIDs in audioplayer']);
            end
        end

    otherwise
end
