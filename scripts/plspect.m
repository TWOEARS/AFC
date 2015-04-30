function freqspec = plspect(stimulus,freqrange,dynrange,SAMPLERATE)
% plspec(stimulus,freqrange,dynrange,SAMPLERATE) 
%
% DESCRIPTION:
% Plots log power spectrum of stimulus
% Returns the spectrum (dB re rms value of 1).
%
% dynrange,freqrange, and SAMPLERATE are optional.
% Default values: dynrange: [20 80], freqrange: [0 8000]; Samplerate: 44100 Hz.
% 
% SEE ALSO: 
% fft, plot 
if nargin < 1
   disp(sprintf('%s(stimulus[,freqrange,dynrange,SAMPLERATE])',mfilename))
   disp(sprintf('Type -> help %s <- for more information',mfilename))
   return
end

if nargin < 2
    freqrange= [200 4000]; %Hz
end
if nargin < 3
    dynrange= [20 -80]; % dB re 1
end
if nargin < 4
   SAMPLERATE = 44100;
end

linmin = 10.^(dynrange(2)/10);
linmax = 10.^(dynrange(1)/10);

xcomp = fft(stimulus);
xmag = ((real(xcomp)).^2) + ((imag(xcomp)).^2);
%level = 10 .* log10(mean(stimulus.^2));

xmag = xmag ./ (ceil(length(stimulus)*0.5)^2);
maxxmag = max(xmag);
%toolow = find(xmag<(maxxmag*linmin));
toolow = find(xmag<linmin);
xmag(toolow) = linmin;
toohigh = find(xmag>linmax);
xmag(toohigh) = linmax;

logmag = 10 .* log10(xmag);

binfreq = [1:length(stimulus)];
binfreq = (binfreq - 1)*SAMPLERATE/length(stimulus);
showlensamp = min(round(freqrange(2)*(length(stimulus)/SAMPLERATE)),length(binfreq));
freqscale = binfreq(1:round(length(stimulus)/2));
levelscale = logmag(1:length(freqscale));
plot(freqscale(1,[1:showlensamp]),levelscale(1,[1:showlensamp]));
axis([freqrange(1) freqscale(showlensamp) dynrange(2)-5 dynrange(1)+5]);
freqspec = [freqscale;levelscale];
