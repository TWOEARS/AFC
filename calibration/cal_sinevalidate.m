% cal_sinevalidate(freq,len,fs,calScript,dBSPLrmsDesired)

function cal_sinevalidate(freq,len,fs,calScript,dBSPLrmsDesired);

clear global def
clear global work
global def
global work

default_cfg;

def.samplerate = fs;
def.calScriptEnable = 0;

out=sin(2*pi*freq*[0:round(fs*len)-1]'/fs);
out = out/rms(out)*10^(dBSPLrmsDesired/20);
work.currentsig=repmat(out,1,2);

calstr = [];
eq = [];
work.eq2 = [];

% some values to get afc_process run
work.bgsig = [];

if (strcmp(calScript,'') ~= 1)
	if (exist([calScript '_calibration']) == 2)
		calstr = [calScript '_calibration'];
	else
		error('CAL:calibration','Specified calibration file not found.');
	end
end

if ( ~isempty(calstr))
	eval(calstr);
	
	def.calScriptEnable = 1;
	
	if (strcmp(def.calTableEqualize,'fir') == 1)
		work.eq2 = afc_calsettings;
	else
		def.calTableLookupFreq = freq;
	end
end

if (strcmp(def.calFirEqualizeFile,'') ~= 1)
	eval(['load ' def.calFirEqualizeFile]);
end

work.eq = eq;

afc_process;

mini=min(work.out)
maxi=max(work.out)

sound(work.out,fs,16);

% eof