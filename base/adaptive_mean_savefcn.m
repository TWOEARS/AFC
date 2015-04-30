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

% last modified 29-06-2006 15:37, revision 0.92 beta, modified 27-04-2004 12:02

function adaptive_mean_savefcn

global def
global work

%global bla

%str=[def.result_path def.expname '_' work.vpname work.userstr '_' work.condition];	% name of save file
str=[def.result_path work.filename];

%%%%%%%%% build headerline %%%%%%%%
if def.interleaved > 0
   headerl = '% track#';
else
   headerl = '%';
end
for i = 1:def.expparnum
   eval(['parunit = def.exppar' num2str(i) 'unit;']);
   headerl = [headerl '   exppar' num2str(i) '[' parunit ']'];
end
headerl = [headerl '   expvar[' def.expvarunit ']'];
%%%%%%%% end headerline %%%%%%%%%

% write experimental variable at all reversals during the measurement phase to disk
%res=[work.exppar work.expvarrev(end - def.reversalnum+1:end)];
%
%r=[];
%for i=1:def.reversalnum
%   r=[r '   %8.8f'];
%end

% write mean and standard deviation to disk  

%res = work.expvarrev(end - def.reversalnum+1:end);
%res=[work.exppar mean(res) std(res,1)];

tmpinterleavenum = 1;
if def.interleaved > 0
   tmpinterleavenum = def.interleavenum;
end

for i = 1:tmpinterleavenum
	restmp = work.expvarrev{i}(end - def.reversalnum+1:end);
   	res{i}=[mean(restmp) std(restmp,1)];

	r='   %8.8f   %8.8f';
	
	%%% FIXME
	%xfTmp = fminsearch('mml_costfcn',[-6 1],[],work.expvar{i},work.correct{i},1/def.intervalnum);
		
	%estTmp = mml_psyfcninv(0.707,1/def.intervalnum,xfTmp(1),xfTmp(1));
	
	%disp(['rev: ' num2str(work.reachedendreversalnum{i}) '   meas: ' num2str(work.reachedendreversalnum{i}-work.reachedendstepsize{i}) '   mean: ' num2str(mean(restmp)) '   est: ' num2str(estTmp(1))]);
	%bla = [bla; [work.reachedendreversalnum{i} work.reachedendreversalnum{i}-work.reachedendstepsize{i} mean(restmp) estTmp(1)]];
end

% write median, lower and upper quartiles to disk
% not yet implemented

ex = exist([str '.dat']);

if ex == 0
   %dat=['% exppar[' def.exppar1unit ']   expvar[' def.expvarunit ']'];
   fid=fopen([str '.dat'],'w');
   fprintf(fid,['%s\n'],headerl);
   for k=1:tmpinterleavenum
      if def.interleaved > 0
         fprintf(fid,'%i',k);
      end
   	for i=1:def.expparnum
      	eval(['tmp = work.int_exppar' num2str(i) '{' num2str(k) '};']);
      	if def.exppartype(i) == 0
         	fprintf(fid,['   %8.8f'],tmp);
      	else
         	fprintf(fid,['   %s'],tmp);
      	end
      end
      fprintf(fid,[r '\n'],res{k});
   end
   
   
   %fprintf(fid,['%8.8f' r '\n'],res);
	fclose(fid);
else
   fid=fopen([str '.dat'],'a');
   for k=1:tmpinterleavenum
      if def.interleaved > 0
         fprintf(fid,'%i',k);
      end
   	for i=1:def.expparnum
      	eval(['tmp = work.int_exppar' num2str(i) '{' num2str(k) '};']);
      	if def.exppartype(i) == 0
         	fprintf(fid,['   %8.8f'],tmp);
      	else
         	fprintf(fid,['   %s'],tmp);
      	end
      end
      fprintf(fid,[r '\n'],res{k});
   end

   
   
   
   %	fprintf(fid,['%8.8f' r '\n'],res);
	fclose(fid);
end

if def.debug == 1
save([str '.mat'], 'work'); 
end

% eof