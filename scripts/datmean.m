function out=datmean(in,varargin);

switch nargin
case 1
out=psydatm(sortrows(in),1)   
   
otherwise
end


fid=fopen(file,'r');
bla=fgetl(fid);
out=[];

bla2=fgets(fid);
while bla ~= -1
   bla=fgets(fid);
   bla2=sscanf(bla2,'%f');
   out=[out bla2];
	bla2=bla;
end
fclose(fid);

out=out';
