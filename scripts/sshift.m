% sshift.m - shifts rectangular portion of a signal's fourier transform
%				 in frequency.
%			    Fourier coefficients outside the passband specified by flow
%			    and fhigh are set to zero.
%
% Usage: cut = sshift(in,flow,fhigh,fshift,fs)
%
% in     = input vector containing a signal's discrete fourier transform
% flow   = lower cutoff frequency in Hz
% fhigh  = upper cutoff frequency in Hz
% fshift = shifting frequency in Hz
% fs     = sampling rate in Hz 
%
% cut    = output vector

function cut = scut(in,flow,fhigh,fshift,fs);

len = length(in);
flow = round(flow*len/fs);
fhigh = round(fhigh*len/fs);
fshift = round(fshift*len/fs);
cut = zeros(len,1);
cut(flow+1+fshift:fhigh+1+fshift) = in(flow+1:fhigh+1);
cut(len-fhigh-fshift+1:len-flow-fshift+1) = in(len-fhigh+1:len-flow+1);
