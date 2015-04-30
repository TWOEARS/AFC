% used to grab all data from a datread matrix matching a given value in specified col
%
% Usage: out = parsedat(in, col, value)
%
% Typically used to filter different exppars from AFC data ".dat" file matrices read in with
% datread.m
%
% See also DATREAD, PSYDATM, PSYDATZ, ALLMEAN


function out=parsedat(in,col,value)

[len,bla]=size(in);
% remove col from in and copy to swap
if col > 1
   swap = in(:,col);
   in = [in(:,1:col-1) in(:,col+1:end)];
elseif col == 1
	swap = in(:,col);
   	in = in(:,col+1:end);
end 

out=[];

for i=1:len
	if swap(i) == value
	   	out = [out; in(i,:)];   
	end
end

out = sortrows(out,1);
