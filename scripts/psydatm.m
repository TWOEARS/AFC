function out=psydatm(in,num)
%	out=psydatm(in) calculates mean and std-deviation of psydat data
%	num means average over the last num experimental runs per parameter.

% changed std(x,1) to std(x,0) 07.01.02 


[len,bla]=size(in);
tmpold=-19832456702.9457308;
out=[];
tmp2=[];

for i=1:len
	%maxdev=abs(in(i,3)-in(i,4));
	tmp=in(i,1);
	if tmp == tmpold
		%if maxdev > 3
		%	disp('WARNING: MORE THAN 3 dB DEVIATION')
		%else
		%end
		tmp2=[tmp2 in(i,2)];
	else
		len2=length(tmp2);
		if num <= len2
			out=[out; tmpold mean(tmp2(len2-num+1:len2)) std(tmp2(len2-num+1:len2),0)];
		elseif i==1

		else
			out=[out; tmpold mean(tmp2) std(tmp2,0)];
			%disp('WARNING: NOT ENOUGH DATA POINTS')
			warning(['PSYDATM: NOT ENOUGH DATA POINTS, PARAMETER: ' num2str(tmpold)]);
		end 
		
		%if maxdev > 3
		%	tmp2=in(i,2);
		%	disp('WARNING: MORE THAN 3 dB DEVIATION')
		%else
			tmp2=in(i,2);
		%end
		tmpold=tmp;
	end
end

len2=length(tmp2);
if num <= len2
	out=[out; tmpold mean(tmp2(len2-num+1:len2)) std(tmp2(len2-num+1:len2),0)];
else
	out=[out; tmpold mean(tmp2) std(tmp2,0)];
	%disp('WARNING: NOT ENOUGH DATA POINTS')
	warning(['PSYDATM: NOT ENOUGH DATA POINTS, PARAMETER: ' num2str(tmpold)]);
end 

