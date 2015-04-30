% ssin.m - makes sinusoidal stimulus -
%
% Usage: out = ssin(len,f,phase,fs);
%
% len = stimulus length in samples 
% f = frequency
% phase = starting phase in radians, if -1 random phase
% fs = sampling rate in Hz
%
% out = output column vector

function out = ssin(len,f,phase,fs);

out = [0:len-1]';

if phase >= 0
  	out = sin(2*pi*out*f/fs + 2*pi*phase); 
else
   out = sin(2*pi*out*f/fs + 2*pi*rand); 
end
   
% eof