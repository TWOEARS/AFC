function out=rancut(in,cutlen);

% cyclic random cut

len=length(in);
if cutlen>len
   disp('cutlen must be < len')
   return
end

out=in(1:cutlen);
pos=ceil(len*rand);
if pos+cutlen-1 <= len
   out(1:cutlen)=in(pos:pos+cutlen-1);
else
   ueber=mod(pos+cutlen-1,len);
   out(1:cutlen-ueber)=in(pos:len);
   out(cutlen-ueber+1:cutlen)=in(1:ueber);
end
