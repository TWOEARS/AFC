
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

% last modified 24-07-2013 12:57:37
% revision 0.92 beta 05/07/2000

function afc_result

global def
global work
global msg

if ( def.remoteObserver == 0 )

    % for debugging
    if def.debug == 1
        save blatest work def
    end


    % SE 09.01.2012 17:44 special case for constantStimuli measurement after skipped TUD
    if ( strcmp( def.skippedMeasurementProcedure, 'constantStimuli' ) )
        if ( work.skippedMPFlag == 0 )
            if ( strcmp( def.measurementProcedure, def.skippedMeasurementProcedure ) )
                % we have ended the CS measurement after having skipped TUD

                if ( work.matlabVersion < 6 )
                    % this field name is truncated in 5.3
                    eval([def.skippedMeasurementProcedureSave '_savefcn']);
                else
                    eval([def.skippedMeasurementProcedureSavefcn '_savefcn']);
                end

            else
                % we have ended TUD without skipping
                eval([def.savefcn '_savefcn']);
            end

            work.numrun = work.numrun + 1;
            work.runsFinished = work.runsFinished + 1;

            afc_proto;

            % assert original procedure
            def.measurementProcedure = work.skippedMP;
        else
            % we have just skipped the TUD procedure
            eval([def.savefcn '_savefcn']);

            work.finishedcount = work.finishedcount - 1;

            afc_proto;

            % change measurement procedure
            def.measurementProcedure = def.skippedMeasurementProcedure;
        end

    else
        % like before
        eval([def.savefcn '_savefcn']);					% calls function which writes results to disk

        work.numrun = work.numrun + 1;
        work.runsFinished = work.runsFinished + 1;

        afc_proto;															% writes protocol file to disk
    end


    control=afc_savectr(1);						% calls afc_savectr as save only function

end
% answer-variable 'control' is not needed
if ( def.afcwinEnable > 0 )
    hm=findobj('Tag','afc_message');
    h=findobj('Tag','afc_win');

    if ( work.skippedMPFlag )
        % skip message
        set(h,'UserData',-1);
        work.terminate = 1;
    else
        set(h,'UserData',2);
        if ( work.numrun <= work.numrunMax )    %work.control(1) <= length(work.control)-1
            set(hm,'string',msg.next_msg);
            feval(def.afcwin, 'next');

            % SE FIXME required at all? afc_main already calls afcwin('finished') 24.07.2013 10:54
            % seems to be required
        else
            set(hm,'string',msg.finished_msg);
            feval(def.afcwin, 'finished');
        end
    end
end

% eof
