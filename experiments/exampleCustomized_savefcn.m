
% example for custom save function, identical to adaptive_mean_savefcn as
% basis for own creations ( code for median commented out)

function exampleCustomized_savefcn

global def
global work

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



tmpinterleavenum = 1;
if def.interleaved > 0
   tmpinterleavenum = def.interleavenum;
end

% write mean and standard deviation to disk  
for i = 1:tmpinterleavenum
	restmp = work.expvarrev{i}(end - def.reversalnum+1:end);
   	res{i}=[mean(restmp) std(restmp,1)];

	r='   %8.8f   %8.8f';
end

% write median, lower and upper quartiles to disk
% for i = 1:tmpinterleavenum
%     restmp = work.expvarrev{i}(end - def.reversalnum+1:end);
%     
%     restmp = sort( restmp );
%     lenh = length( restmp ) / 2;
%     clenh = ceil( lenh );
%     
%     if clenh == lenh	% even
%         med = mean(restmp(lenh : lenh + 1));
%         lqr = abs( median(restmp(1:lenh)) - med );
%         uqr = abs( median(restmp(lenh+1:end)) - med );
%     else
%         med = x(clenh);
%         lqr = abs( median(restmp(1:clenh-1))- med );
%         uqr = abs( median(restmp(clenh+1:end))- med );
%     end
%     
%     res{i}=[med lqr uqr];
%     
%     r='   %.8f   %.8f   %.8f';
% end

ex = exist([str '.dat']);

if ex == 0

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

	fclose(fid);
end

if def.debug == 1
save([str '.mat'], 'work'); 
end

% eof