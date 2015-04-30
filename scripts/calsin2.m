function calsin(freq,len,fs);%,eqfile);

%bla=load(eqfile); 

out=sin(2*pi*freq*[0:round(fs*len)-1]'/fs);
%out = filter(bla.eq,1,out);

mini=min(out)
maxi=max(out)

sound(out,fs,16);