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

% last modified 29-06-2006 15:37:51

% 16-03-2004 16:19

function eq = afc_calsettings

global def
global work

%if ( ~isempty(work.eq))
%	return;
%end
 
% design fir filter

eq = [];

fftpts = def.samplerate;
binfactor = fftpts / def.samplerate;

xi = [0:def.samplerate/2+1]'/binfactor;

x = def.calTable(:,1);
y = def.calTable(:,2:end);

% now take ref point and invert
rp = find(x == def.calTableEqualizeRefFreq);

for idx = 1:size(y,2) 
	
	% corrected Stephan Ernst 01.12.2005 12:04
	ytmp = y(:,idx) - y(rp,idx);
	
	yi = interp1(x,ytmp,xi,'cubic'); 
	
	
	% new table with boundarys
	
	% find NaN range
	nanRange = 1- isnan(yi); % returns one where we have values
	nan_low = min(find(nanRange > 0));
	nan_upp = max(find(nanRange > 0));
	
	yi(1:nan_low) = yi(nan_low);
	yi(nan_upp:end) = yi(nan_upp);
	
	xi_low = max(find(xi < def.calFilterDesignLow));
	xi_upp = min(find(xi > def.calFilterDesignUp));
	
	yi(1:xi_low) = yi(xi_low+1);
	yi(xi_upp:end) = yi(xi_upp-1);
	
	yi = 1./(10.^(yi/20));
	
	invyi = zeros(fftpts,1);
	invyi(1:length(yi)) = yi;
	
	switch ( def.calFilterDesignFirPhase )
	case 'minimum'
		invyi(fftpts/2+2:end) = flipud(invyi(2:fftpts/2));
		% make minimum phase
		invyi = invyi.*exp(-i*imag(hilbert(log(invyi))));
		
		invyi(fftpts/2+2:end) = 0;
	otherwise
	
	end
	
	invyi(1) = 0;	%no dc
	
	fir = fftshift(2*real(ifft(invyi))); 
	
	%%%% window cut
	% asymmetric window for minimum phase
	switch ( def.calFilterDesignFirPhase )
	case 'minimum'
		winds = hannfl(def.calFilterDesignFirCoef,def.calFilterDesignFirCoef/16,def.calFilterDesignFirCoef/4);
		fir2 = fir(fftpts/2+1-def.calFilterDesignFirCoef/16:fftpts/2+def.calFilterDesignFirCoef-def.calFilterDesignFirCoef/16);
		fir2 = fir2.*winds;
	otherwise
		winds = hannfl(def.calFilterDesignFirCoef,def.calFilterDesignFirCoef/4,def.calFilterDesignFirCoef/4);
		fir2 = fir(fftpts/2+1-def.calFilterDesignFirCoef/2:fftpts/2+def.calFilterDesignFirCoef/2);
		fir2 = fir2.*winds;
	end
	
	eq = [eq fir2];

end % for size y


% eof