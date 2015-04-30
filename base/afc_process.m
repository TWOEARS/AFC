
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

% last modified 25-02-2013 20:23:00
% revision 1.01.2 beta, modified 01.12.2005 14:27

function afc_process(def,work)

global def
global work

switch def.backgroundsig							% background signal
case 0
   out = work.currentsig;
case 1
   out = work.bgsig + work.currentsig;
case 2
   out = work.bgsig .* work.currentsig;
end

% removed 12-03-2004 18:39
%switch def.headphoneeq								% headphone equalization
%case 0
%   
%otherwise
%   out = [out; zeros(length(work.eq),2)];
%   out = filter(work.eq,1,out);
%end

% new 12-03-2004 18:39
if ( strcmp(def.calFirEqualizeFile,'') ~= 1)
	out = [out; zeros(size(work.eq,1),def.outputChannels)];
	% different channels
	if ( size(work.eq,2) == def.outputChannels )
		for i = 1:def.outputChannels % 22.04.2009 11:00 SE added more output channels
			out(:,i) = filter(work.eq(:,i),1,out(:,i));
		end
	elseif ( size(work.eq,2) == 1 )
		out = filter(work.eq,1,out);
	else
		% if there is no match, use only first channel of eq file and issue a warning
		out = filter(work.eq(:,1),1,out);
		warning('Different number of channels in def.calFirEqualizeFile and def.outputChannels. Using first channel of def.calFirEqualizeFile');
	end

	%out = [out; zeros(length(work.eq),2)];
	%out = filter(work.eq,1,out);
end

if ( (def.calScriptEnable == 1) & (strcmp(def.calTableEqualize,'fir') == 1) )
	out = [out; zeros(size(work.eq2,1),def.outputChannels)];
	% different channels
	if ( size(work.eq2,2) == def.outputChannels )
		for i = 1:2 % only two channels at the moment
			out(:,i) = filter(work.eq2(:,i),1,out(:,i));
		end
	elseif ( size(work.eq2,2) == 1 )
		out = filter(work.eq2,1,out);
	else
		% if there is no match, use only first channel of eq file and issue a warning
		out = filter(work.eq2(:,1),1,out);
		warning('Different number of channels in def.calTableEqualize and def.outputChannels. Using first channel of def.calTableEqualize');
	end
end


% 16-03-2004 12:15 now engage calScript scaling
if ( def.calScriptEnable == 1 )
	
	% SE 25.02.2013 19:22:49 moved to extra function
	afc_getCurrentCalLevel;
	
	for (i=1:def.outputChannels)
		out(:,i) = out(:,i) / 10^(work.currentCalLevel(i)/20);
	end
end


switch def.dither										% digital dithering
case 0
   
case 1
	out = out + (rand(size(out))-0.5)/2^(def.bits) * 4 * def.ditherdepth;
end   
%out = work.currentsig + def.dither*(randn(size(work.currentsig))*0.28865)/2^def.bits;

work.out=out;

% eof