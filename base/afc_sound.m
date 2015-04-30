
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

% last modified 17-03-2014 13:26:47
% revision 1.00.1 beta, modified 01/14/2004

function returnValue = afc_sound( action )

% SE 16.03.2011 10:22
% split this in case 'init', 'play' and 'close', remove all calls of sound outputs from other files
% add playrec, m-sound and def.internSoundCommand = 'audioplayer' (default) and 'sound'

global work
global def

returnValue = [];

% SE note 30.01.2014 12:59
% add extern_sound_XY logic to be able to add new sound commands without changing afc_sound (because of license restrictions to al afc_ core files)
% Best would be to change switch order to first switch to the wanted soundCommand, then have the action switch for each
% 
% switch def.externSoundCommand
%     case 'sndmex'
%     case 'soundmex'
%     case 'soundmexfree'
%     case 'soundmex2'
%     case 'soundmex2free'
%     case 'soundmexpro'
%     case 'soundmexprofree'
%     case 'snd_pc'
%     case ''
%         % intern sound command
%     otherwise
%         % check whether external sound function is existing
%         if (exist([ 'extern_sound_' def.externSoundCommand ]) == 2)
%             eval([ 'extern_sound_' def.externSoundCommand '( action )' ]);	% calls extern_sound function if existing
%         else
%             % error
%         end
% end

% SE 30.01.2014 13:10 check whether external sound function is existing
if ( ~isempty(def.externSoundCommand) & exist([ 'sound_' def.externSoundCommand ]) == 2)
    eval([ 'returnValue = sound_' def.externSoundCommand '( action );' ]);	% calls extern_sound function if existing
    return;
end


% SE 07.06.2011 09:41 has actions now, all sound calls are here now
switch ( action )

    case 'init'
        switch def.externSoundCommand
            case 'sndmex'
                % close the device in case it was open (doesn't hurt otherwise)
                sndmex('exit');
                sndmex('init');
            case 'soundmex'
                % 27-09-2004 11:26
                soundmex('init','force');
            case 'soundmexfree'
                % 01-02-2005 09:13
                soundmex('init','forcefree');
            case 'soundmex2'
                % 05-04-2005 10:29
                soundmex2('init','force', 1);
            case 'soundmex2free'
                % 05-04-2005 10:29
                soundmex2('init','force', 1, 'mode', 'free');
            case 'soundmexpro'
                % 20.07.2010 15:22
                if ( def.continuous > 0 )
                    soundmexpro('init','force',1, ... % command name
                        'driver', def.deviceID, ...        % enter a name here to load a driver its index
                        'samplerate', def.samplerate,... % samplerate to use (default is 44100)
                        'numbufs', def.soundmexproBufferNum, ...      % number of software buffers used to avoid xruns (dropouts, default is 10)
                        'output', def.outputChannelMap, ...    % output channels to use (here: first two output channels of device: this is default)
                        'track', 2*def.outputChannels ...          % number of virtual tracks
                        );

                    if ( def.continuous > 1 )
                        soundmexpro('trackmode', ...    % command name
                            'track', [def.outputChannels:2*def.outputChannels-1], ...               % track to apply mode to
                            'mode', 1 ...                   % track mode, here: multiplication (0 is adding)
                            );
                    end
                    
                    % SE 19.08.2013 13:56 include trackmap initialisation
			              soundmexpro('trackmap', ...
			                    'track', def.trackMap ...        % new mapping
			                    );
			              
                else
                    % SE/SK 15.10.2012 10:35 fixed 'driver' and 'numbufs' specification
                    soundmexpro('init','force',1, ... % command name
                        'driver', def.deviceID, ...        % enter a name here to load a driver by it's name
                        'samplerate', def.samplerate,... % samplerate to use (default is 44100)
                        'numbufs', def.soundmexproBufferNum, ...      % number of software buffers used to avoid xruns (dropouts, default is 10)
                        'output', def.outputChannelMap, ...    % output channels to use (here: first two output channels of device: this is default)
                        'track', def.outputChannels ...          % number of virtual tracks
                        );
                        
                    % SE 19.08.2013 13:56 include trackmap initialisation (only initialize the first def.outputChannels) if not mixing
                    % haven't checked whether 2*def.outputChannels hurts                
			        soundmexpro('trackmap', ...
			                    'track', def.trackMap(1:def.outputChannels) ...        % new mapping
			                    );
			              
                end
            case 'soundmexprofree'
                % 01.03.2013 16:51 doesnt digest track specification on init
                if ( def.continuous > 0 )
                    soundmexpro('init','force',1, ... % command name
                        'driver', def.deviceID, ...        % enter a name here to load a driver its index
                        'samplerate', def.samplerate,... % samplerate to use (default is 44100)
                        'numbufs', def.soundmexproBufferNum, ...      % number of software buffers used to avoid xruns (dropouts, default is 10)
                        'output', def.outputChannelMap ...    % output channels to use (here: first two output channels of device: this is default)
                         );

                    if ( def.continuous > 1 )
                        soundmexpro('trackmode', ...    % command name
                            'track', [def.outputChannels:2*def.outputChannels-1], ...               % track to apply mode to
                            'mode', 1 ...                   % track mode, here: multiplication (0 is adding)
                            );
                    end
                else
                    % SE/SK 15.10.2012 10:35 fixed 'driver' and 'numbufs' specification
                    soundmexpro('init','force',1, ... % command name
                        'driver', def.deviceID, ...        % enter a name here to load a driver by it's name
                        'samplerate', def.samplerate,... % samplerate to use (default is 44100)
                        'numbufs', def.soundmexproBufferNum, ...      % number of software buffers used to avoid xruns (dropouts, default is 10)
                        'output', def.outputChannelMap ...    % output channels to use (here: first two output channels of device: this is default)
                        );
                end

                %soundmexpro('showmixer');
            case 'snd_pc'

        end

    case 'close'
        switch def.externSoundCommand
            case 'sndmex'
                sndmex('exit');
            case {'soundmex','soundmexfree'}
                soundmex('exit');
            case {'soundmex2','soundmex2free'}
                soundmex2('exit');
            case {'soundmexpro','soundmexprofree'}
                soundmexpro('exit');
            case 'snd_pc'
                % FIXME: is this neccesary?
                if ( isfield(work, 'soundres' ) )
                    if ( sum(work.soundres) ~= 0 )
                        snd_stop(work.soundres);
                        work.soundres = 0;
                    end
                end
            case ''
                % clear audioplayer handle in base
                evalin('base','clear afc_ap_handle');
        end

    case 'play_warmup_zeros'
        switch def.externSoundCommand
            case 'sndmex'
                sndmex('playmem', zeros(100,2), def.bits, def.samplerate, 'async', 1, def.deviceID);
            case {'soundmex','soundmexfree'}
                soundmex('playmem', zeros(100,2), def.bits, def.samplerate, 'async', 1, def.deviceID);
            case {'soundmex2','soundmex2free'}
                soundmex2(  'playmem',                             ... % command name
                    'data', zeros(100,2),   		 ... % name of wavefile
                    'bitlength', def.bits,    ... % bitlength for playback
                    'sampfreq', def.samplerate,  ... % sampling frequency
                    'mode', 'async',  ... % mode
                    'loopcount', 1,                         ... % endloss loop (loopcount 0)
                    'device', def.deviceID                        ... % DeviceId. Default is 0
                    );
                %soundmex('playmem', zeros(100,2), def.bits, def.samplerate, 'async', 1, def.deviceID);
            case {'soundmexpro','soundmexprofree'}
                soundmexpro('loadmem', ...      % command name
                    'data', zeros(100,2), ...              % data vector
                    'name', 'sweep', ...            % name used in track view for this vector
                    'track', [0:def.outputChannels-1], ...             % tracks, here 0 and 1 (one track on each channel)
                    'loopcount', 1 ...              % loopcount
                    );
                soundmexpro('start');
            %case {'soundmexprofree'}
            %    soundmexpro('loadmem', ...      % command name
            %        'data', zeros(100,2), ...              % data vector
            %        'name', 'sweep', ...            % name used in track view for this vector
            %        'loopcount', 1 ...              % loopcount
            %        );
            %    soundmexpro('start');
            case 'snd_pc'
                if ( isfield(work, 'soundres' ) )
                    if ( sum(work.soundres) ~= 0 )
                        snd_stop(work.soundres);
                        work.soundres = 0;
                    end
                end
                work.soundres = snd_multi([1 0 def.samplerate def.bits],zeros(2,100));
            case ''
                switch def.internSoundCommand
                    case 'sound'
                        sound(zeros(100,2),def.samplerate,def.bits);
                    case 'audioplayer'
                        if (ispc == 1 | ( ismac == 1 & work.matlabVersionRelease > 7.1 )) 
                            ap_handle = audioplayer(zeros(100,2), def.samplerate, def.bits, def.deviceID);
                        else
                            ap_handle = audioplayer(zeros(100,2), def.samplerate, def.bits);
                        end
                        
                        assignin('base','afc_ap_handle',ap_handle);
                        evalin('base','play(afc_ap_handle);');
                    case 'wavplay'
                        wavplay(zeros(100,2),def.samplerate,'async');
                end
        end

    case 'bgloopwav_restart'
        switch def.externSoundCommand
            case 'sndmex'

                [snd_a, snd_b] = sndmex('isplaying', def.deviceID);
                if snd_b
                    sndmex('stop');
                end
                %sndmex('playfile', def.bgloopwav, 'loopasync', 0, def.deviceID, 'random');
                % new sndmex syntax 28.11.02
                sndmex('playfile', def.bgloopwav, 'async', 0, def.deviceID, 'random');

                work.bgloopwav_old = def.bgloopwav;

            case {'soundmex','soundmexfree'}

                [snd_a, snd_b] = soundmex('isplaying', def.deviceID);
                if snd_b
                    soundmex('stopplay');
                end

                soundmex('playfile', def.bgloopwav, 'async', 0, def.deviceID, def.bits, 'random');
                work.bgloopwav_old = def.bgloopwav;

            case {'soundmex2','soundmex2free'}

                [snd_a, snd_b] = soundmex2('isplaying', 'device', def.deviceID);
                if snd_b
                    soundmex2('stopplay');
                end
                soundmex2(  'playfile',                             ... % command name
                    'filename', def.bgloopwav,    ... % name of wavefile
                    'mode', 'async', ...
                    'loopcount', 0,                         ... % endloss loop (loopcount 0)
                    'bitlength', def.bits,                  ... %
                    'random', 1,                            ... %
                    'device', def.deviceID                  ... % DeviceId. Default is 0
                    );

                %soundmex('playfile', def.bgloopwav, 'async', 0, def.deviceID, def.bits, 'random');
                work.bgloopwav_old = def.bgloopwav;

            case {'soundmexpro','soundmexprofree'}

                [snd_a, snd_b] = soundmexpro('playing');
                if any(snd_b)
                    soundmexpro('stop');
                end

                % SE 15.10.2012 14:45 for more channels have a loop to load individual mono files
                % also included random offset per default as was in soundmex and soundmex2
                if ( exist( [ def.bgloopwav(1:end-4) '01.wav' ] ) )
                    % we have individual mono files, load them in a loop
                    for i=1:def.outputChannels

                        if ( i < 10 )
                            waveNameTmp = [ def.bgloopwav(1:end-4) '0' num2str(i) '.wav' ];
                        else
                            waveNameTmp = [ def.bgloopwav(1:end-4) num2str(i) '.wav' ];
                        end

                        soundmexpro('loadfile', ...   % command name
                            'filename', waveNameTmp, ...  % filename
                            'track', [i-1], ...
                            'loopcount', 0, ...           % loopcount
                            'startoffset', def.bgloopwavStartoffset ...										% random start position
                            );
                    end
                else

                    % load the background file on the first block of virtual tracks, so that we can add or multiply on later
                    soundmexpro('loadfile', ...                  % command name
                        'filename', def.bgloopwav, ...  % filename
                        'track', [0:def.outputChannels-1], ...
                        'loopcount', 0, ...                          % loopcount
                        'startoffset', def.bgloopwavStartoffset ...										% random start position
                        );
                end

                % SE 15.10.2012 14:45 include trackmap def.trackmap = [0 0 1 0]; soundmexpro counts from 0
                % def.trackMap = repmat([0:def.outputChannels-1],1,2)
                % change mapping to map three virtual tracks (0, 1 and 3) to output channel
                % 0 and the remaining track No. 2 to output channel 1
                
                if ( strcmp(def.externSoundCommand, 'soundmexpro' ) )
	                soundmexpro('trackmap', ...
	                    'track', def.trackMap ...        % new mapping
	                    );
	              end
	              
                if ( isfield(work, 'currentCalLevel') & ~isempty(def.bgloopwavFullScaleLevel) )

                    attenuation = 10^((-work.currentCalLevel+def.bgloopwavFullScaleLevel)/20);

                    % now change volume of backgroundtrack
                    [success, volume]=soundmexpro('trackvolume', ...  % command name
                        'track', [0:def.outputChannels-1], ...          % for which tracks
                        'value', attenuation*ones(1,def.outputChannels) ...                          % volume values for sweep
                        );

                    if success ~= 1
                        error(['error calling ''trackvolume''' error_loc(dbstack)]);
                    end

                end

                soundmexpro('start');

                %soundmex('playfile', def.bgloopwav, 'async', 0, def.deviceID, def.bits, 'random');
                work.bgloopwav_old = def.bgloopwav;
            
            otherwise
                warning('afc_sound: continuous output not supported for sound command in def.externSoundCommand');
            %case 'snd_pc'
                % nothing
        end

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

        % 1.001
        switch def.externSoundCommand
            case 'sndmex'
                if ((def.markinterval == 1) & (def.sndmexmark == 1))
                    % test button marking
                    start = def.presiglen + 1;
                    duration = def.intervallen;

                    if  def.continuous == 0
                        mixto = 'org';
                    else
                        mixto = 'mix';
                    end

                    for i=1:def.intervalnum
                        sndmex('setbutton', 'AFC-measure', num2str(i), mixto, start, duration, def.deviceID);
                        start = start + duration + def.pauselen;
                    end
                end

                if  def.continuous == 0
                    sndmex('playmem', work.out, def.bits, def.samplerate, 'async', 1, def.deviceID);
                elseif def.continuous == 1
                    sndmex('mixmem', work.out, 'add', def.deviceID);
                elseif def.continuous == 2
                    sndmex('mixmem', work.out, 'multiply', def.deviceID);
                end

            case {'soundmex','soundmexfree'}
                if ((def.markinterval == 1) & (def.soundmexMark == 1))
                    % test button marking
                    start = def.presiglen + 1;
                    duration = def.intervallen;

                    if  def.continuous == 0
                        mixto = 'org';
                    else
                        mixto = 'mix';
                    end

                    for i=1:def.intervalnum
                        soundmex('setbutton', 'AFC-measure', num2str(i), mixto, start, duration, def.deviceID);
                        start = start + duration + def.pauselen;
                    end
                end

                if  def.continuous == 0
                    soundmex('playmem', work.out, def.bits, def.samplerate, 'async', 1, def.deviceID);
                elseif def.continuous == 1
                    soundmex('mixmem', work.out, 'add', def.deviceID);
                elseif def.continuous == 2
                    soundmex('mixmem', work.out, 'multiply', def.deviceID);
                end

            case {'soundmex2','soundmex2free'}
                if ((def.markinterval == 1) & (def.soundmexMark == 1))
                    % test button marking
                    start = def.presiglen + 1;
                    duration = def.intervallen;

                    if  def.continuous == 0
                        mixto = 'org';
                    else
                        mixto = 'mix';
                    end

                    for i=1:def.intervalnum
                        %soundmex('setbutton', 'AFC-measure', num2str(i), mixto, start, duration, def.deviceID);

                        % find button and set units to pixels
                        buttonh = findobj('Tag',['afc_button' num2str(i)]);
                        oldUnits = get(buttonh, 'Units');
                        set (buttonh, 'Units', 'pixels');

                        soundmex2(  'setbutton',                    ... % command name
                            'handle', buttonh,                    ...
                            'mode', mixto,                   ... % positions relative to mixed signal?
                            'startpos', start,              ... % starting position
                            'length', duration,                ... % length
                            'device', def.deviceID                ... % DeviceId. Default is 0
                            );

                        % reset to old Units
                        set(buttonh, 'Units', oldUnits);

                        start = start + duration + def.pauselen;

                    end
                end

                if  def.continuous == 0
                    soundmex2(  'playmem',                             ... % command name
                        'data', work.out,   		 ... % name of wavefile
                        'bitlength', def.bits,    ... % bitlength for playback
                        'sampfreq', def.samplerate,  ... % sampling frequency
                        'mode', 'async',  ... % mode
                        'loopcount', 1,                         ... % endloss loop (loopcount 0)
                        'device', def.deviceID                        ... % DeviceId. Default is 0
                        );
                    %soundmex('playmem', work.out, def.bits, def.samplerate, 'async', 1, def.deviceID);
                elseif def.continuous == 1
                    soundmex2(  'mixmem',                             ... % command name
                        'data', work.out,   		 ... % name of wavefile
                        'mode', 'add',  ... % mode
                        'device', def.deviceID                        ... % DeviceId. Default is 0
                        );
                    %soundmex('mixmem', work.out, 'add', def.deviceID);
                elseif def.continuous == 2
                    soundmex2(  'mixmem',                             ... % command name
                        'data', work.out,   		 ... % name of wavefile
                        'mode', 'multiply',  ... % mode
                        'device', def.deviceID                        ... % DeviceId. Default is 0
                        );
                    %soundmex('mixmem', work.out, 'multiply', def.deviceID);
                end

            case {'soundmexpro','soundmexprofree'}

                % load sounds from memory to the respective tracks
                if  def.continuous == 0
                    soundmexpro('loadmem', ...      % command name
                        'data', work.out, ...              % data vector
                        'name', 'out', ...            % name used in track view for this vector
                        'track', [0:def.outputChannels-1], ...             % tracks, here 0 and 1 (one track on each channel)
                        'loopcount', 1 ...              % loopcount
                        );

                    % a new sound output is started, set the offset to zero
                    offset = 0;

                elseif def.continuous < 3
                    % adding/multiplying mode is already set
                    soundmexpro('loadmem', ...          % command name
                        'data', work.out, ...           % data vector
                        'name', 'out', ...              % name used in track view for this vector
                        'track', [def.outputChannels:2*def.outputChannels-1], ...             % tracks, here 0 and 1 (one track on each channel)
                        'loopcount', 1 ...              % loopcount
                        );

                    % retrieve the load position, the continuous sound runs in the background
                    [a_tmp, offset] = soundmexpro('loadposition');

                end

                if ((def.markinterval == 1) & (def.soundmexMark == 1))
                    % button marking
                    start = def.presiglen + 1;
                    duration = def.intervallen;

                    for i=1:def.intervalnum
                        % find button and set units to pixels
                        buttonh = findobj('Tag',['afc_button' num2str(i)]);
                        oldUnits = get(buttonh, 'Units');
                        set (buttonh, 'Units', 'pixels');

                        soundmexpro(  'setbutton',                    ... % command name
                            'handle', buttonh,                    ...
                            'startpos', start+offset,              ... % starting position
                            'length', duration                ... % length
                            );

                        % reset to old Units
                        set(buttonh, 'Units', oldUnits);

                        start = start + duration + def.pauselen;
                    end
                end

                % play the sound if required
                if ( def.continuous == 0 )
                    soundmexpro('start');
                end

            case 'snd_pc'
                if ( isfield(work, 'soundres' ) )
                    if ( sum(work.soundres) ~= 0 )
                        snd_stop(work.soundres);
                        work.soundres = 0;
                    end
                end
                work.soundres = snd_multi([1 0 def.samplerate def.bits],work.out');


            case ''

                switch def.internSoundCommand
                    case 'sound'
                        sound(work.out,def.samplerate,def.bits);
                    case 'audioplayer'
                        if (ispc == 1 | ( ismac == 1 & work.matlabVersionRelease > 7.1 )) 
                            ap_handle = audioplayer(work.out, def.samplerate, def.bits, def.deviceID);
                        else
                            ap_handle = audioplayer(work.out, def.samplerate, def.bits);
                        end
                        
                        % SE doesnt work to wait for delayed sound output
                        % with startfcn nor with isplaying. The delay must
                        % be introduced later
                        %set( ap_handle, 'StartFcn', 'toc')
                        
                        assignin('base','afc_ap_handle',ap_handle);
                        evalin('base','play(afc_ap_handle);');
                        
                        % SE block until sound output has started
                        %while ( 1 )
                        %	if ( isplaying(ap_handle) )
                        %		break;
                        %    end
                        % 	pause(0.01)
                        %end
                        
                      
                        
                    case 'wavplay'
                        wavplay(work.out,def.samplerate,'async');
                    otherwise
                        warning('afc_sound: unknown sound command in def.internSoundCommand');
                end
                
                if ( def.markIntervalDelay > 0 )
                    pause( def.markIntervalDelay )
                end

            otherwise
                warning('afc_sound: unknown sound command in def.externSoundCommand');

        end
        % end of case 'play'

        % SE 12.02.2013 12:07
    case 'isSoundmex'
        if ( strcmp(def.externSoundCommand, 'sndmex') | strcmp(def.externSoundCommand, 'soundmex') | strcmp(def.externSoundCommand, 'soundmexfree')  | strcmp(def.externSoundCommand, 'soundmex2') | strcmp(def.externSoundCommand, 'soundmex2free') | strcmp(def.externSoundCommand, 'soundmexpro') | strcmp(def.externSoundCommand, 'soundmexprofree') )
            returnValue = 1;
        else
            returnValue = 0;
        end

    case 'isSoundmexMarking'
        if ( ~(strcmp(def.externSoundCommand, 'sndmex') & def.sndmexmark) & ~((strcmp(def.externSoundCommand, 'soundmex') | strcmp(def.externSoundCommand, 'soundmexfree') | strcmp(def.externSoundCommand, 'soundmex2') | strcmp(def.externSoundCommand, 'soundmex2free') | strcmp(def.externSoundCommand, 'soundmexpro') | strcmp(def.externSoundCommand, 'soundmexprofree') ) & def.soundmexMark) )
            returnValue = 0;
        else
            returnValue = 1;
        end

        % SE 12.02.2013 12:07
    case 'blockWhilePlaying'

        switch def.externSoundCommand
            % better check output stage if using sndmex
            case 'sndmex'
                if ( def.continuous > 0 )
                    [snd_a, snd_is] = sndmex('ismixing', def.deviceID);
                    while (snd_is == 1)
                        [snd_a, snd_is] = sndmex('ismixing', def.deviceID);
                        pause(0.05);
                    end
                    pause(0.5);
                else
                    [snd_a, snd_is] = sndmex('isplaying', def.deviceID);
                    while (snd_is == 1)
                        [snd_a, snd_is] = sndmex('isplaying', def.deviceID);
                        pause(0.05);
                    end
                end
            case {'soundmex','soundmexfree'}
                if ( soundmex('isinitialized') )
                    if ( def.continuous > 0 )
                        [snd_a, snd_is] = soundmex('ismixing', def.deviceID);
                        while (snd_is == 1)
                            [snd_a, snd_is] = soundmex('ismixing', def.deviceID);
                            pause(0.05);
                        end
                        pause(0.5);
                    else
                        [snd_a, snd_is] = soundmex('isplaying', def.deviceID);
                        while (snd_is == 1)
                            [snd_a, snd_is] = soundmex('isplaying', def.deviceID);
                            pause(0.05);
                        end
                    end
                end
            case {'soundmex2','soundmex2free'}
                if ( soundmex2('isinitialized') )
                    if ( def.continuous > 0 )
                        [snd_a, snd_is] = soundmex2('ismixing', 'device', def.deviceID);
                        while (snd_is == 1)
                            [snd_a, snd_is] = soundmex2('ismixing', 'device', def.deviceID);
                            pause(0.05);
                        end
                        pause(0.5);
                    else
                        [snd_a, snd_is] = soundmex2('isplaying', 'device', def.deviceID);
                        while (snd_is == 1)
                            [snd_a, snd_is] = soundmex2('isplaying', 'device', def.deviceID);
                            pause(0.05);
                        end
                    end
                end
            case {'soundmexpro','soundmexprofree'}
                if ( soundmexpro('initialized') )
                    if ( def.continuous > 0 )
                        % FIXME soundmexPro
                        [snd_a, snd_is] = soundmexpro('playing');
                        while ( any(snd_is(def.outputChannels+1:end)) )
                            [snd_a, snd_is] = soundmexpro('playing');
                            pause(0.05);
                        end
                        pause(0.5);
                    else
                        [snd_a, snd_is] = soundmexpro('playing');
                        while ( any(snd_is) )
                            [snd_a, snd_is] = soundmexpro('playing');
                            pause(0.05);
                        end
                    end
                end
            otherwise
                % needed for secure blocking in release 6.5
                pause(0.01);
        end

    % SE 12.02.2013 12:07
    %case 'stopSndPc'
    case 'stop'
        % snd_pc specific
        if ( strcmp(def.externSoundCommand,'snd_pc') )
            if ( isfield(work, 'soundres' ) )
                if ( sum(work.soundres) ~= 0 )
                    snd_stop(work.soundres);
                    work.soundres = 0;
                end
            end
        end

    otherwise
        warning('afc_sound: unknown action specified');

end

% eof