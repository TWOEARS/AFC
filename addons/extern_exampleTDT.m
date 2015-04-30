% revision 0.94.4 beta, modified 19/04/02

function extern_exampleTDT(action)

global def
global work

switch action
    case 'open'
        % call a specific hardware here
        % TDTInit(work.userpar1);

        % just play some zeros to get the DAC running
        if ( def.soundEnable > 0 )

            afc_sound('play_warmup_zeros');

        end
        %disp('hardware open');

    case 'initialize'
        %disp('hardware initialize');

    case 'reset'
        %disp('hardware reset');

    case 'close'
        %disp('hardware close');
        % shut the hardware down
        % TDTClose(work.userpar1);

    otherwise
        disp('hardware unknown action');

end

% eof