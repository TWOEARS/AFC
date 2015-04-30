%rms.m Returns rms value of vector
% Usage y = rms(x)
function y = rms(x)

ln = length(x);

y = sqrt(sum(x .^ 2) ./ ln);
