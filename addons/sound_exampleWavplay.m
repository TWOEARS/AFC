% revision 1.40.1

function returnValue = sound_exampleWavplay( action )

% SE 16.03.2014
% custom sound function interface
% must support the following actions 
% (leave empty if nothing should be done):
% 'init'
% 'close'
% 'play_warmup_zeros'
% 'bgloopwav_restart'
% 'play'
% 'isSoundmex'
% 'isSoundmexMarking'
% 'blockWhilePlaying'
% 'stop'

global work
global def

returnValue = [];

% switch the wanted action
switch ( action )
    case 'init'

    case 'close'

    case 'play_warmup_zeros'
        wavplay(zeros(100,2),def.samplerate,'async');

    case 'bgloopwav_restart'

    case 'play'
        if ( def.checkOutputClip > 0 )
            clipped = max(max(abs(work.out)));

            if ( clipped > 1 )
                switch 	def.checkOutputClip
                    case 1
                        %warning('AFC:clipped', 'Output stimulus clipped');
                        warning('Output stimulus clipped');
                    case 2
                        %error('AFC:clipped', 'Output stimulus clipped');
                        error('Output stimulus clipped');
                end
            end
        end

        % 1.001 use actual output sig len for blocking
        work.blockButtonTime = size(work.out,1)/def.samplerate+0.1;	% plus 0.1 sec safety margin

        wavplay(work.out,def.samplerate,'async');


        if ( def.markIntervalDelay > 0 )
            pause( def.markIntervalDelay )
        end

    case 'isSoundmex'
        returnValue = 0;

    case 'isSoundmexMarking'
        returnValue = 0;

    case 'blockWhilePlaying'
        % needed for secure blocking in release 6.5
        pause(0.01);
        
    case 'stop'

    otherwise
        warning('sound_exampleSoundmexpro: unknown action specified');

end

% eof