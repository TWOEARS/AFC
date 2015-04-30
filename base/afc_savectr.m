
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

% last modified 23-04-2013 15:41:57
% version 0.92, modified 13/01/00

function control = afc_savectr( sel )

global def
global work

%str=[def.control_path 'control_' def.expname '_' work.vpname work.userstr '_' work.condition '.dat'];
str=[def.control_path 'control_' work.filename '.dat'];

%%%%%%%%%%%%% build headerlines %%%%%%%%%%
headerl1 = '% run#';
tmpinterleavenum = 1;
if def.interleaved > 0
	tmpinterleavenum = def.interleavenum;
end

headerl2 = '%';
for i = 1:tmpinterleavenum
   headerl2 = [headerl2 ' track' num2str(i) ':'];
   for k = 1:def.expparnum
      headerl2 = [headerl2 ' exppar' num2str(k)];
   end
   headerl2 = [headerl2 ';'];
end
%%%%%%%%%%%%% end build %%%%%%%%%

switch sel				% 0 = checks whether control file is existing, if not it is generated; 1 = write only 
case 0
   fid = fopen(str,'r');
	
	if fid == -1		% not existing, generate
	
   	%switch def.parrand
      %case 1
         
         % generate the order array
         % 23.04.2013 15:25
         % v 1.30.0 can be a custom function now
         eval(['order = ' def.controlFileGenerateOrder '_genorder;']);
                 
      %	control=[]; 
      %	for i=1:def.repeatnum
      %   	control=[control def.exppar(randperm(length(def.exppar)))];
      % 	end
      %case 0
         % changed for exppar1 ... expparN and interleaved
         
         %%%%%%%%% convert all matrices to cell arrays of numbers %%%%%%%
         %
         % FIXME: this leads to the fact that all def.expars are cell arrays for first call (no existing control file)
         % while they might be number later (when defined as numbers in cfg) because they are not converted if the control file exists.
         % Hint from  MA Stone, (december 2004) 04-05-2005 10:31 
         %
         for k = 1:def.expparnum					% number of exppars
            if ~def.exppartype(k)				% if matrix = 0, if cellarray of strings = 1     
               eval(['def.exppar' num2str(k) ' = num2cell(def.exppar' num2str(k) ');']);
            end
         end
         %%%%%%%%% end convert
         
         %%%%%%%%% expand exppars for interleaving
         tmpinterleavenum = 1;
         if def.interleaved > 0
            tmpinterleavenum = def.interleavenum;
            for i=1:def.expparnum
               eval(['tmpexppar = def.exppar' num2str(i) ';']);
               if size(tmpexppar,1) == def.interleavenum	% size correct
                  
               elseif size(tmpexppar,1) == 1					% only one track specified, taken as default for all tracks
                  tmp2exppar = tmpexppar;
                  for k=1:def.interleavenum-1
                     tmp2exppar = [tmp2exppar; tmpexppar];
                  end
                  eval(['def.exppar' num2str(i) ' = tmp2exppar;']);
               else
                  error('exppar dimension mismatch, incorrect number of tracks');
               end
            end            
         end % if def.interleaved
         %%%%%%%%% end expand %%%%%%%%%%%%
         
         %%%%%%%%%% build control %%%%%%%%
         control={};
            for m = 1:tmpinterleavenum
            	for k = 1:def.expparnum					% number of exppars
            %switch def.exppartype(k)			% if matrix = 0, if cellarray of strings = 1     
            %case 0
         	%	tmp=[];
      		%	for i=1:def.repeatnum
            %   	eval(['tmp = [tmp; transpose(def.exppar' num2str(k) ')];']);
            %   end   
            %   control = [control num2cell(tmp)];
            %   %format = [format '%8.8f '];
            %case 1
            		tmp={};
            		eval(['tmpexppar = def.exppar' num2str(k) ';']);
               	for i=1:size(order,1)
                  	%for k=1:size(tmpexppar,2)
                     	tmp = [tmp; {tmpexppar{m,order(i,k)}}];
                  	%end
               	end   
              		control = [control tmp];
              	%format = [format '%s '];
                 %end
            	end
         	end
         %elseif def.interleaved == 0				% skipping additional tracks in def.exppars
         %   for k = 1:def.expparnum					% number of exppars
         %     	tmp={};
         %   	eval(['tmpexppar = def.exppar' num2str(k) ';']);
         %      for i=1:def.repeatnum
         %         for k=1:size(tmpexppar,2)
         %            tmp = [tmp; {tmpexppar{1,k}}];
         %         end
         %      end   
         %     	control = [control tmp];
         %  	end  
         %end % end if interleaved
      %end % end switch def.parrand
      
      work.numrun = 1;									% first run
      
      
      
      fid=fopen(str,'w');								% write to disk
      
      fprintf(fid,'%s\n',headerl1);					% write headerlines
		  fprintf(fid,'%s\n',headerl2);
      
      fprintf(fid,'%8i\n',work.numrun);
      for i=1:size(control,1)
         for k=1:size(control,2)
            switch def.exppartype(mod(k-1,def.expparnum)+1)
            case 0
               format = '%16.8f';
            case 1
               format = '%16s';
            end
            pr=control{i,k};
            fprintf(fid,format,pr);
         end
         fprintf(fid,'\n');
		end
      fclose(fid);
      
   else														% read control file (already existing and already opened in 'r' mode)
      %fclose(e);

      %%%%%%% check for headerlines (commentstyle '%') %%%%%%%%
      %fid=fopen(str,'r');
      found = 1;
      headerlines = -1;
      while isempty(found) == 0
         found=findstr(fgets(fid),'%');
      	headerlines = headerlines + 1;   
      end
      fclose(fid);
      %%%%%%% end check headerlines %%%%%%%%
      
      tmp=textread(str,'%s','headerlines',headerlines);
      control = {};
      work.numrun = str2num(tmp{1,1});				% number of threshold run (control(1) before)
      
      %%%%%%%%%%% check correct dimension of tmp %%%%%%%%%%
      
      % get number of rows (dirty, reread control file)
      tmprownum=size(textread(str,'%s','delimiter','\n','whitespace','','headerlines',headerlines),1)-1;
      tmpintnum = 1;										% also valid if not interleaved (==1)
      if def.interleaved > 0
         if length(tmp)-1 == def.interleavenum * def.expparnum * tmprownum
            tmpintnum = def.interleavenum;		% change to correct number of interleaved tracks
			%elseif length(tmp)-1 == def.expparnum * tmprownum
			%	warning('control-file dimension mismatch, reading only track 1');
         else
            error('control-file dimension mismatch, incorrect number of tracks');
         end
      end
      %%%%%%%%%%% end check %%%%%%%%%%%%%%%%%
      
      % restore columns of the control array
      for i=1:def.expparnum * tmpintnum
         control = [control tmp(i+1:def.expparnum*tmpintnum:end-def.expparnum*tmpintnum+i)];	% control is now a cell array
         %control = [control tmp(i+1:def.expparnum:end-def.expparnum+i)];	% control is now a cell array
         if ~isempty(str2num(control{1,i}))											% convert to numbers
            for k=1:size(control,1)
               control{k,i}=str2num(control{k,i});
            end     
         end
      end
      %fclose(e);
	end
	   
case 1														% write only
   control=work.control;
   fid=fopen(str,'w');
	%fprintf(fid,'%8.8f\n',control);   
   %fclose(fid);
   fprintf(fid,'%s\n',headerl1);					% write headerlines
	fprintf(fid,'%s\n',headerl2);
   
   fprintf(fid,'%8i\n',work.numrun);
      for i=1:size(control,1)
         for k=1:size(control,2)
            switch def.exppartype(mod(k-1,def.expparnum)+1)
            case 0
               format = '%16.8f';
            case 1
               format = '%16s';
            end
            pr=control{i,k};
            fprintf(fid,format,pr);
         end
         fprintf(fid,'\n');
		end
      fclose(fid);
end