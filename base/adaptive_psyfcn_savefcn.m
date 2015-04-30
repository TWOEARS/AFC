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

% last modified 29-06-2006 15:37, revision 0.93 beta, modified 07/08/00

function adaptive_psyfun_savefcn

global def
global work

%str=[def.result_path def.expname '_' work.vpname work.userstr '_' work.condition];	% name of save file
str=[def.result_path work.filename];

%%%%%%%%% build headerline %%%%%%%%
%if def.interleaved > 0
   headerl = '% run#   track#';
%else
%   headerl = '% run#';
%end
for i = 1:def.expparnum
   eval(['parunit = def.exppar' num2str(i) 'unit;']);
   headerl = [headerl '   exppar' num2str(i) '[' parunit ']'];
end
headerl = [headerl '   expvar[' def.expvarunit ']   n.pres   n.correct'];
%%%%%%%% end headerline %%%%%%%%%

%%%%%%%% get data %%%%%%%%%%%%%%%
tmpinterleavenum = 1;								% fixme: remove this in future versions
if def.interleaved > 0
   tmpinterleavenum = def.interleavenum;
end

for i = 1:tmpinterleavenum
   endstepsizeindex = min(find(abs(diff(work.expvar{i})) == def.varstep{i}(end)));	% reached final stepsize
	restmp = work.expvar{i}(endstepsizeindex + 1 : end);										% get expvars in measurement phase
   correcttmp = work.correct{i}(endstepsizeindex + 1 : end);

   res.range{i} = [min(restmp):def.varstep{i}(end):max(restmp)]';							% determine expvar range
   res.n_pres{i} = res.range{i} * 0;
   res.n_correct{i} = res.range{i} * 0;
   
   for k = 1:length(restmp)																			% gathering statistics
      tmpindex = find(res.range{i} == restmp(k));
      res.n_pres{i}(tmpindex) = res.n_pres{i}(tmpindex) + 1;
      res.n_correct{i}(tmpindex) = res.n_correct{i}(tmpindex) + correcttmp(k);
   end
end
%%%%%%%% end get data %%%%%%%%%%%%%

r='   %.8f   %i   %i';

ex = exist([str '.dat']);

if ex == 0
   %dat=['% exppar[' def.exppar1unit ']   expvar[' def.expvarunit ']'];
   fid=fopen([str '.dat'],'w');
   fprintf(fid,['%s\n'],headerl);
   for k=1:tmpinterleavenum    
      for l = 1:length(res.range{k})
	      fprintf(fid,'%i',work.numrun);			% current run number
   	   %if def.interleaved > 0
      	   fprintf(fid,'   %i',k);					% track number if interleaved
      	%end
       	for i=1:def.expparnum
      		eval(['tmp = work.int_exppar' num2str(i) '{' num2str(k) '};']);
      		if def.exppartype(i) == 0
         		fprintf(fid,['   %.8f'],tmp);
      		else
         		fprintf(fid,['   %s'],tmp);
      		end
      	end
         fprintf(fid,[r '\n'],[ res.range{k}(l) res.n_pres{k}(l) res.n_correct{k}(l) ] );
      end
   end
	fclose(fid);
else
   fid=fopen([str '.dat'],'a');
   for k=1:tmpinterleavenum    
      for l = 1:length(res.range{k})
	      fprintf(fid,'%i',work.numrun);			% current run number
   	   %if def.interleaved > 0
      	   fprintf(fid,'   %i',k);					% track number if interleaved
      	%end
       	for i=1:def.expparnum
      		eval(['tmp = work.int_exppar' num2str(i) '{' num2str(k) '};']);
      		if def.exppartype(i) == 0
         		fprintf(fid,['   %.8f'],tmp);
      		else
         		fprintf(fid,['   %s'],tmp);
      		end
      	end
         fprintf(fid,[r '\n'],[ res.range{k}(l) res.n_pres{k}(l) res.n_correct{k}(l) ] );
      end
   end
	fclose(fid);
end

if def.debug == 1
save([str '.mat'], 'work'); 
end

% eof