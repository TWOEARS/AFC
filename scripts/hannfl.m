function h = hannfl(len,h1len,h2len);

if len > 0
h = ones(len,1);

switch h1len
case 0
otherwise
   h(1:h1len)=(1-cos(pi/h1len*[0:h1len-1]))/2;
end

switch h2len
case 0
otherwise
   h(end-h2len+1:end)=(1+cos(pi/h2len*[1:h2len]))/2;
end

else
end
