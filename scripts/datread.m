% datread.m reads floats from ascii file. Tabs and space characters are ignored.
% Every line with a leading '%' or '//' is skipped. If all lines were skipped,
% datread returns an empty char.
%
% Usage: out = datread('filename');
%
% Typically used to read AFC data ".dat" files
%
% See also PARSEDAT, PSYDATM, PSYDATZ, ALLMEAN


function out=datread(file);

fid=fopen(file,'r');
bla=1;%fgetl(fid);
out=[];

bla2=fgets(fid);
while bla ~= -1
   bla=fgets(fid);
   bla2=sscanf(bla2,'%f');
   	
   	% added this 27/03/03 for MATLAB 6.5
   	if ~isempty(bla2)
   		out=[out bla2];
	end
	bla2=bla;
end
fclose(fid);

out=out';
