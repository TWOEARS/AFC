% revision 1.00.1 beta, 07/01/04

function response = exampleModel_detect

global def
global work
global simwork

% we select only the left channels, the model is monaural
simwork.tmpSig = work.signal(:,1:2:end);
simwork.actStd = [];

for i=1:def.intervalnum
	simwork.actStd(i) = eval([work.vpname '_preproc(simwork.tmpSig(:,i))']);		% actual sig processing
end

% now select the interval with the maximum standard deviation
[tmp,response] = max(simwork.actStd);														% select max power

% if it is another interval than the first, the response is wrong, since in the work.signal always carries the
% signal interval in the first column
if response ~= 1
   response = 0;
end

% eof
