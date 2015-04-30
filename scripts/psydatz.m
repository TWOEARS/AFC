function out=psydatz(in,num)
%	out=psydatm(in) calculates median and the interquartile intervals of psydat data
%	num means average over the last num experimental runs per parameter.

[len,bla]=size(in);
tmpold=-19832456702.9457308;
out=[];
tmp2=[];

for i=1:len
	tmp=in(i,1);
	if tmp == tmpold
		tmp2=[tmp2 in(i,2)];
	else
		len2=length(tmp2);
		if num <= len2
			tmp2=sort(tmp2(len2-num+1:len2));
			len2=num;
			out=[out; tmpold median(tmp2) median(tmp2(1:fix(len2/2))) median(tmp2(ceil(len2/2)+1:len2))];
		elseif i==1

		else
			tmp2=sort(tmp2);
			out=[out; tmpold median(tmp2) median(tmp2(1:fix(len2/2))) median(tmp2(ceil(len2/2)+1:len2))];
			disp('WARNING: NOT ENOUGH DATA POINTS')
		end 
		tmp2=in(i,2);
		tmpold=tmp;
	end
end

len2=length(tmp2);
if num <= len2
	tmp2=sort(tmp2(len2-num+1:len2));
	len2=num;
	out=[out; tmpold median(tmp2) median(tmp2(1:fix(len2/2))) median(tmp2(ceil(len2/2)+1:len2))];
else
	tmp2=sort(tmp2);
	out=[out; tmpold median(tmp2) median(tmp2(1:fix(len2/2))) median(tmp2(ceil(len2/2)+1:len2))];
	disp('WARNING: NOT ENOUGH DATA POINTS')
end 

out(:,3)=abs(out(:,3)-out(:,2));
out(:,4)=abs(out(:,4)-out(:,2));


