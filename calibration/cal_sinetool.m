% function cal_sinetool(freq,len,fs,calFirEqualizeFile)

function cal_sinetool(freq,len,fs,calFirEqualizeFile);

out=sin(2*pi*freq*[0:round(fs*len)-1]'/fs);
out=repmat(out,1,2);

eq = [];

if (strcmp(calFirEqualizeFile,'') ~= 1)
	eval(['load ' calFirEqualizeFile]);

	out = [out; zeros(size(eq,1),2)];
	% different channels
	if size(eq,2) > 1
		for i = 1:2 % only two channels at the moment
			out(:,i) = filter(eq(:,i),1,out(:,i));
		end
	else
		out = filter(eq,1,out);
	end

end

mini=min(out)
maxi=max(out)

sound(out,fs,16);

% eof