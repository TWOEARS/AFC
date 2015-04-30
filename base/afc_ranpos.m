
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

% last modified 25-04-2013 15:21
% changed 10/07/00

function afc_ranpos

global def
global work

% 08.09.2005 11:57 based on Helmut Riedel/Helge Lueddemann
% 22.04.2009 11:49 SE more than 2 output channels

% 20.07.2010 13:50 SE assert signal size and outputchannels
% FIXME fallbacks?
if ( size(work.signal,2) ~= (def.outputChannels * def.intervalnum)  )
	error('Mismatching size of work.signal, def.outputChannels, and def.intervalnum');
elseif ( size(work.presig,2) ~= def.outputChannels )
	error('Mismatching size of work.presig and def.outputChannels');
elseif ( size(work.pausesig,2) ~= def.outputChannels )
	error('Mismatching size of work.pausesig and def.outputChannels');
elseif ( size(work.postsig,2) ~= def.outputChannels )
	error('Mismatching size of work.postsig and def.outputChannels');
end

ranpos = def.ranpos;

if ranpos == 0                               			    % random position of the signal in [1 def.intervalnum]
  ranpos = 1:def.intervalnum;                 		    % e.g., 0 --> [1 2 3] in 3AFC
end
permu = randperm(length(ranpos));                 		% e.g., def.ranpos = [2 3] --> ranpos = [1 2] or [2 1]
                                                      % permute def.ranpos, write to ranpos, do not change def.ranpos
position = ranpos(permu(1));                  		    % e.g., position is 2 or 3, random position of the interval containing the signal

work.position{work.pvind}=[work.position{work.pvind} position]; % add current position to vector of all positions

%% set vector of channels (mono)
monochannels = 1:def.intervalnum;                     % e.g., [1        2 3 4]
monochannels(1) = position;                           % e.g., [position 2 3 4] = [3 2 3 4], e.g., with position = 3
monochannels(position) = 1;                           % e.g., [position 2 1 4] = [3 2 1 4], e.g., with position = 3

%%% set vector of channels (stereo)
%stereochannels = [2*monochannels-1;2*monochannels];   % convert mono to stereo channels, e.g.: [5 6;3 4;1 2;7 8]'
%stereochannels = stereochannels(:)';                  % convert [C 2] to [2*C 1], e.g.:[5 6 3 4 1 2 7 8]

% vector of outputChannels
numChannels = [1:def.outputChannels];

% BUG, Stephan Ernst report 28-03-2006 16:15: the order of stimuli in work signal was touched
% work.signal = work.signal(:,stereochannels);          % e.g.: permute 4 stereo signals: work.signal(:,[5 6 3 4 1 2 7 8]);


% generate output signal
work.currentsig = [work.presig; work.signal(:,numChannels + (monochannels(1)-1)*def.outputChannels)];% presignal and 1st interval
for n=2:def.intervalnum
  work.currentsig = [work.currentsig; work.pausesig; work.signal(:,numChannels + (monochannels(n)-1)*def.outputChannels)]; % add pause and nth interval  
end %n
work.currentsig=[work.currentsig; work.postsig];
return

% eof