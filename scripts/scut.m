% scut.m - cuts rectangular portion of a signal's fourier transform.
%			  Fourier coefficients outside the passband specified by flow
%			  and fhigh are set to zero.
%
% Usage: cut = scut(in,flow,fhigh,fs)
%
% in     = input vector containing a signal's discrete fourier transform
% flow   = lower cutoff frequency in Hz
% fhigh  = upper cutoff frequency in Hz 
% fs     = sampling rate in Hz 
%
% cut    = output vector

function cut = scut(in,flow,fhigh,fs);

len = length(in);
flow = round(flow*len/fs);
fhigh = round(fhigh*len/fs);
cut = zeros(len,1);
cut(flow+1:fhigh+1) = in(flow+1:fhigh+1);

% HACK: if lowpass ( flow = 0) index would be greater than len (len +1)
if flow == 0
	flow = 1;
end

cut(len-fhigh+1:len-flow+1) = in(len-fhigh+1:len-flow+1);
