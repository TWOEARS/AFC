
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

% last modified 23-04-2013 15:16:10

function orderarray = afc_genorder;

% generates ordered (parrand=0) or random (parrand =1) matrix containing
% all possible combinations of exppar1, exppar2, ..., expparX (indices
% only! does not contain the actual elements of exppar!)
% The output (orderarray) is then used in afc_savectr.m to generate control
% file (which then contains the actual elements of exppar)

global def

% get expparsize, matrix [size exppar1; size exppar2; size exppar3; ...]
expparsize=[];
for i=1:def.expparnum
    eval(['tmpsize = size(def.exppar' num2str(i) ');']);
    expparsize=[expparsize; tmpsize];
end
def.expparsize=expparsize;

allorderrand = 0;
if size(def.parrand,2) ~= def.expparnum
    % of request 12-03-2004 10:46 randomize completly if def.parrand scalar und expparnum > 1 
	% FIXME should go to main!
    if size(def.parrand,2) == 1
	% 24-01-2006 11:14 only set allorderrand to 1 if parrand was 1, fixed
        if ( def.parrand == 1 )
            allorderrand = 1;
        end
        def.parrand = repmat(def.parrand,1,def.expparnum);
    else
        
        error('def.parrand dimension mismatch');
    end
end


indmat = [];
for i_rep = 1:def.repeatnum
    indmatblock = [];
    for i_exp = 1:def.expparnum
        % column in indmat
        indmatcol = [];
        
        
        if def.expparnum - i_exp == 0
            repnum = 1;
        else
            repnum = prod(expparsize(i_exp + 1:end,2),1);
        end
        
        
        for i_col = 1:repnum
            switch def.parrand(i_exp)
                case 0	% order
                    indmattmp = [1:expparsize(i_exp,2)]';
                case 1	% random
                    indmattmp = randperm(expparsize(i_exp,2))';
            end
            
            
            if i_exp == 1
                repnum2 = 1;
            else
                repnum2 = prod(expparsize(1:i_exp-1,2),1);
            end
            
            
            for i = 1:length(indmattmp)
                indmatcol = [indmatcol; repmat(indmattmp(i),repnum2,1)];
            end		% for i
            
        end			% for i_col
        
        indmatblock = [indmatblock indmatcol];
        
    end				% for i_exp
    indmat = [indmat; indmatblock];
    
end					% for i_rep

orderarray = indmat;

% 15-03-2004 12:27
% create random order of all conditions (all possible exppar combinations)
if allorderrand == 1;
    indmattmp = [];
    blocksize = size(orderarray,1)/def.repeatnum;
    for i_rep = 1:def.repeatnum
        indmattmp = [indmattmp; (blocksize*(i_rep-1))+randperm(blocksize)'];
    end
    orderarray = orderarray(indmattmp,:);
end
% eof