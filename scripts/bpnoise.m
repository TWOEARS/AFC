% bpnoise.m - generates spectrally rectangular shaped band-pass noise.
%
% Usage: out = bpnoise(len,flow,fhigh,fs)
%
% len    = output length in samples
% flow   = lower cutoff frequency in Hz
% fhigh  = upper cutoff frequency in Hz 
% fs     = sampling rate in Hz 
%
% out    = output vector

function out = bpnoise(len,flow,fhigh,fs);

out = real(ifft(scut(fft(randn(len,1)),flow,fhigh,fs)));

out = out/(norm(out,2)/sqrt(len));

% eof
