
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

% last modified 21-07-2014 10:47:14
% 07/01/04 -- se based on 27/08/03 -- jlv
% show signals during run of experiment

function afc_show( action )

global def
global work

%positions = work.position{1};
%disp(sprintf('signal is in %d interval \n',round(positions(length(positions)))))
% % --+ Use the following lines to plot the current trial signal on  screen
% % 21/08/03 jlv

switch action
    case 'open'
        % open different windows, get handles, tags, position them
        
        % close them all
        afc_show( 'close' );
        
        % count the windows
        winCount = 0;
        winNumber = 0;
        if def.showtrial == 1
            winCount = winCount + 1;
        end
        if def.showspec == 1
            winCount = winCount + 1;
        end
        if def.showstimuli == 1
            winCount = winCount + 1;
        end
        if def.showrun == 1
            winCount = winCount + 1;
        end
        
        if def.showtrial == 1
            % removed for matlab 2014b
            %             % Do we have windows open?
            %             if isempty( findobj(0,'type','figure') ) % no figure open
            %                 h = 0;
            %             else
            %                 h = gcf;		%FIXME might once not be the afc_win
            %                 if ~isnumeric(h) % catch the new return value of Matlab 2014b
            %                     h = h.Number;
            %                 end
            %             end
            %
            %             % open up new fig
            %             h = figure(h+1);
            
            h = figure;
            
            winNumber = winNumber + 1;
            set(h,'position',get(0,'defaultFigurePosition'),'Tag','afc_win_showtrial', ...
                'Name',['AFC - Trial view'] );
            
            % change to default size again
            offset = (winCount-(winNumber-1))*20;
            set(h,'position',get(0,'defaultFigurePosition') + [-offset offset-40 0 0] );
        end
        if def.showspec == 1
            % removed for matlab 2014b
            %             h = gcf;		%FIXME might once not be the afc_win
            %             % open up new fig
            %             h = figure(h+1);
            
            h = figure;
            
            winNumber = winNumber + 1;
            set(h,'position',get(0,'defaultFigurePosition'),'Tag','afc_win_showspec', ...
                'Name',['AFC - Spectrum view'] );
            
            % change to default size again
            offset = (winCount-(winNumber-1))*20;
            set(h,'position',get(0,'defaultFigurePosition') + [-offset offset-40 0 0] );
        end
        if def.showstimuli == 1
            % removed for matlab 2014b
            %             h = gcf;		%FIXME might once not be the afc_win
            %             % open up new fig
            %             h = figure(h+1);
            h = figure;
            
            winNumber = winNumber + 1;
            set(h,'position',get(0,'defaultFigurePosition'),'Tag','afc_win_showstimuli', ...
                'Name',['AFC - Stimulus view'] );
            
            offset = (winCount-(winNumber-1))*20;
            set(h,'position',get(0,'defaultFigurePosition') + [-offset offset-40 0 0] );
        end
        if def.showrun == 1
            % removed for matlab 2014b
            %             if isempty( findobj(0,'type','figure') ) % no figure open
            %                 h = 0;
            %             else
            %                 h = gcf;		%FIXME might once not be the afc_win
            %             end
            %             % open up new fig
            %             h = figure(h+1);
            
            h = figure;
            winNumber = winNumber + 1;
            set(h,'position',get(0,'defaultFigurePosition'),'Tag','afc_win_showrun', ...
                'Name',['AFC - Experimental run view'] );
            
            offset = (winCount-(winNumber-1))*20;
            set(h,'position',get(0,'defaultFigurePosition') + [-offset offset-40 0 0] );
        end
        
        % return focus to measurement window
        if ( def.afcwinEnable )
            h=findobj('Tag','afc_win');
            figure(h);
        end
        
    case 'close'
        % close all the guys
        
        if def.showtrial == 1
            h=findobj('Tag','afc_win_showtrial');
            delete(h);
        end
        if def.showspec == 1
            h=findobj('Tag','afc_win_showspec');
            delete(h);
        end
        if def.showstimuli == 1
            h=findobj('Tag','afc_win_showstimuli');
            delete(h);
        end
        if def.showrun == 1
            h=findobj('Tag','afc_win_showrun');
            delete(h);
        end
        
    case 'update'
        % update with new content
        ears = 1;
        titles = {''};
        
        if def.showbothears == 1
            ears = 2;
            titles = {'Left ear','Right ear'};
        end
        
        if def.showtrial == 1
            h=findobj('Tag','afc_win_showtrial');
            
            if ~isempty(h)
                figure(h);
                for i = 1:ears
                    subplot(1,ears,i)
                    plot([1:length(work.out)]./def.samplerate,work.out(:,i))
                    title(titles{i})
                    xlabel('Time (s)')
                    ylabel('Amplitude (lin)')
                end
            end
        end
        if def.showspec == 1
            h=findobj('Tag','afc_win_showspec');
            
            if ~isempty(h)
                
                figure(h);
                % FIXME only up to 5-AFC
                ylabels = {'Target amp (dB)','Ref-1 amp (dB)','Ref-2 amp (dB)','Ref-3 amp (dB)','Ref-4 amp (dB)'};
                for i = 1:def.intervalnum
                    %left ear only
                    subplot(def.intervalnum,round(ears),round(ears*(i-1)+1))
                    plspect(work.signal(:,round(2*i-1))',def.showspec_frange,def.showspec_dbrange, def.samplerate);
                    xlabel('Frequency (Hz)')
                    ylabel(ylabels{i})
                    if i == 1
                        title(titles{1})
                    end
                    if ears == 2;
                        %right ear only
                        subplot(def.intervalnum,2,round(2*i))
                        plspect(work.signal(:,round(2*i))',def.showspec_frange,def.showspec_dbrange, def.samplerate);
                        xlabel('Frequency (Hz)')
                        ylabel(ylabels{i})
                        if i == 1
                            title(titles{2})
                        end
                    end
                end
            end
        end
        if def.showstimuli == 1
            h=findobj('Tag','afc_win_showstimuli');
            
            if ~isempty(h)
                
                figure(h);
                ylabels = {'Target amp (lin)','Ref-1 amp (lin)','Ref-2 amp (lin)','Ref-3 amp (lin)','Ref-4 amp (lin)'};
                tsamples = ([1:def.intervallen]'-1)./def.samplerate;
                absmaxy = max(max(abs(work.signal)));
                for i = 1:def.intervalnum
                    %left ear only
                    subplot(def.intervalnum,ears,ears*(i-1)+1)
                    plot(tsamples,work.signal(:,round(2*i-1))')
                    xlabel('Time (s)')
                    ylabel(ylabels{i})
                    if i == 1
                        title(titles{1})
                    end
                    axis([min(tsamples) max(tsamples) -absmaxy absmaxy])
                    if ears == 2;
                        %right ear only
                        subplot(def.intervalnum,2,round(2*i))
                        plot(tsamples,work.signal(:,round(2*i))')
                        xlabel('Time (s)')
                        ylabel(ylabels{i})
                        if i == 1
                            title(titles{2})
                        end
                        axis([min(tsamples) max(tsamples) -absmaxy absmaxy])
                    end
                end
            end
        end
        
        drawnow;
        % return focus to measurement window
        if ( def.afcwinEnable )
            h=findobj('Tag','afc_win');
            figure(h);
        end
        
    case 'runUpdate'
        if def.showrun == 1
            h=findobj('Tag','afc_win_showrun');
            
            if ~isempty(h)
                
                figure(h);
                
                if ( strcmp(def.measurementProcedure, 'transformedUpDown') )
                    for i = 1:def.interleavenum
                        
                        xrange = 40;
                        while (length(work.stepnum{i}) >= xrange)
                            xrange = xrange + 10;
                        end
                        
                        yrange = [def.startvar{i}-def.varstep{i}(1)  def.startvar{i}+def.varstep{i}(1)];
                        while ( yrange(1) >= min(work.expvar{i}) )
                            % SE 22.05.2014 hangs for neg varsteps yrange(1) = yrange(1) - def.varstep{i}(1);
                            yrange(1) = yrange(1) - abs(def.varstep{i}(1));
                        end
                        while ( yrange(2) <= max(work.expvar{i}) )
                            % SE 22.05.2014 hangs for neg varsteps  yrange(2) = yrange(2) + def.varstep{i}(1);
                            yrange(2) = yrange(2) + abs(def.varstep{i}(1));
                        end
                        
                        subplot(def.interleavenum,1,i)
                        if ~isempty(work.correct{i})
                            for k=1:length(work.correct{i})
                                if work.correct{i}(k) == 1
                                    style = '+k';
                                else
                                    style = 'or';
                                end
                                
                                % check special events
                                %if isfield( work, 'reachedendstepsize' )			% might not be existing
                                %	if ( length(work.reachedendstepsize) >= i )		% might not be initialized for i
                                if ~isempty(work.reachedendstepsize{i}) 	% might still be empty for i
                                    % enter measurement phase
                                    if work.reachedendstepsize{i} == work.stepnum{i}(k)
                                        plot([work.stepnum{i}(k) work.stepnum{i}(k)],[def.minvar def.maxvar],'b--');
                                        hold on;
                                    end
                                    % mark reversals in measurement phase
                                    if ( (work.reachedendstepsize{i} < work.stepnum{i}(k)) & (abs(work.reversal{i}(k)) > 0) )
                                        symbol = '^b';
                                        if ( work.reversal{i}(k) < 0 )
                                            symbol = 'vb';
                                        end
                                        plot(work.stepnum{i}(k),work.expvar{i}(k)-(work.reversal{i}(k)*2*work.stepsize{i}),symbol);
                                        hold on;
                                    end
                                    % draw mean and std when finished
                                    if work.trackfinished{i}
                                        restmp = work.expvarrev{i}(end - def.reversalnum+1:end);
                                        restmp = [mean(restmp) std(restmp,1)];
                                        
                                        xposition = xrange*0.625;
                                        yposition = (yrange(2)-yrange(1))/10;
                                        text( xposition, yrange(2)-yposition, sprintf('Mean: %4.3f, Std: %4.3f', restmp(1), restmp(2)));
                                    end
                                end
                                %	end
                                %end
                                
                                plot(work.stepnum{i}(k),work.expvar{i}(k),style)
                                hold on;
                                
                            end
                        end
                        axis([0 xrange yrange])
                        hold off;
                        
                        % current exppars
                        for i_exp=1:def.expparnum
                            eval(['i_parunit = def.exppar' num2str(i_exp) 'unit;']);
                            eval(['i_tmp = work.int_exppar' num2str(i_exp) '{' num2str(i) '};']);
                            if def.exppartype(i_exp) == 0
                                prints = sprintf(['%8.8f'],i_tmp);
                            else
                                prints = sprintf(['%s'],i_tmp);
                            end
                            
                            xposition = xrange/4;
                            yposition = (yrange(2)-yrange(1))/10;
                            text( xposition, yrange(2)-(i_exp)*yposition, ['exppar' num2str(i_exp) ': ' prints ' ' i_parunit]);
                            
                        end
                        
                        xlabel('Step number');
                        ylabel(['Tracking variable (' def.expvarunit ')']);
                    end
                    
                elseif ( strcmp(def.measurementProcedure, 'PEST') )
                    for i = 1:def.interleavenum
                        
                        xrange = 40;
                        while (length(work.stepnum{i}) >= xrange)
                            xrange = xrange + 10;
                        end
                        
                        yrange = [def.startvar{i}-def.varstep{i}(1)  def.startvar{i}+def.varstep{i}(1)];
                        while ( yrange(1) >= min(work.expvar{i}) )
                            yrange(1) = yrange(1) - def.varstep{i}(1);
                        end
                        while ( yrange(2) <= max(work.expvar{i}) )
                            yrange(2) = yrange(2) + def.varstep{i}(1);
                        end
                        
                        subplot(def.interleavenum,1,i)
                        if ~isempty(work.correct{i})
                            for k=1:length(work.correct{i})
                                if work.correct{i}(k) == 1
                                    style = '+k';
                                else
                                    style = 'or';
                                end
                                
                                % check special events
                                %if isfield( work, 'reachedendstepsize' )			% might not be existing
                                %	if ( length(work.reachedendstepsize) >= i )		% might not be initialized for i
                                %if ~isempty(work.reachedendstepsize{i}) 	% might still be empty for i
                                %	% enter measurement phase
                                %	if work.reachedendstepsize{i} == work.stepnum{i}(k)
                                %		plot([work.stepnum{i}(k) work.stepnum{i}(k)],[def.minvar def.maxvar],'b--');
                                %		hold on;
                                %	end
                                %	% mark reversals in measurement phase
                                %	if ( (work.reachedendstepsize{i} < work.stepnum{i}(k)) & (abs(work.reversal{i}(k)) > 0) )
                                %		symbol = '^b';
                                %		if ( work.reversal{i}(k) < 0 )
                                %			symbol = 'vb';
                                %		end
                                %		plot(work.stepnum{i}(k),work.expvar{i}(k)-(work.reversal{i}(k)*2*work.stepsize{i}),symbol);
                                %		hold on;
                                %	end
                                % draw mean and std when finished
                                if work.trackfinished{i}
                                    %restmp = work.expvarrev{i}(end - def.reversalnum+1:end);
                                    %restmp = [mean(restmp) std(restmp,1)];
                                    text( xrange-15, yrange(2)-def.varstep{i}(2), sprintf('Result: %4.3f', work.PEST_Expvar{i} ));
                                end
                                %end
                                %	end
                                %end
                                
                                plot(work.stepnum{i}(k),work.expvar{i}(k),style)
                                hold on;
                                
                            end
                        end
                        axis([0 xrange yrange])
                        hold off;
                        xlabel('Step number');
                        ylabel(['Tracking variable (' def.expvarunit ')']);
                    end
                    
                elseif ( strcmp(def.measurementProcedure, 'MML') )
                    for i = 1:def.interleavenum
                        
                        xrange = 40;
                        while (length(work.stepnum{i}) >= xrange)
                            xrange = xrange + 10;
                        end
                        
                        yrange = [def.startvar{i}-def.varstep{i}(1)  def.startvar{i}+def.varstep{i}(1)];
                        while ( yrange(1) >= min(work.expvar{i}) )
                            yrange(1) = yrange(1) - def.varstep{i}(1);
                        end
                        while ( yrange(2) <= max(work.expvar{i}) )
                            yrange(2) = yrange(2) + def.varstep{i}(1);
                        end
                        
                        subplot(def.interleavenum,1,i)
                        if ~isempty(work.correct{i})
                            for k=1:length(work.correct{i})
                                if work.correct{i}(k) == 1
                                    style = '+k';
                                else
                                    style = 'or';
                                end
                                
                                % check special events
                                %if isfield( work, 'reachedendstepsize' )			% might not be existing
                                %	if ( length(work.reachedendstepsize) >= i )		% might not be initialized for i
                                if ~isempty(work.reachedendstepsize{i}) 	% might still be empty for i
                                    % enter measurement phase
                                    if work.reachedendstepsize{i} == work.stepnum{i}(k)
                                        plot([work.stepnum{i}(k) work.stepnum{i}(k)],[def.minvar def.maxvar],'b--');
                                        hold on;
                                    end
                                    %	% mark reversals in measurement phase
                                    %	if ( (work.reachedendstepsize{i} < work.stepnum{i}(k)) & (abs(work.reversal{i}(k)) > 0) )
                                    %		symbol = '^b';
                                    %		if ( work.reversal{i}(k) < 0 )
                                    %			symbol = 'vb';
                                    %		end
                                    %		plot(work.stepnum{i}(k),work.expvar{i}(k)-(work.reversal{i}(k)*2*work.stepsize{i}),symbol);
                                    %		hold on;
                                    %	end
                                    % draw mean and std when finished
                                    if work.trackfinished{i}
                                        %restmp = work.expvarrev{i}(end - def.reversalnum+1:end);
                                        %restmp = [mean(restmp) std(restmp,1)];
                                        text( xrange-15, yrange(2)-def.varstep{i}(2), sprintf('Result: %4.3f', work.MML_MuEstimate{i}(end) ));
                                    end
                                end
                                %	end
                                %end
                                
                                plot(work.stepnum{i}(k),work.expvar{i}(k),style)
                                hold on;
                                
                            end
                        end
                        axis([0 xrange yrange])
                        hold off;
                        xlabel('Step number');
                        ylabel(['Tracking variable (' def.expvarunit ')']);
                    end
                    
                elseif ( strcmp(def.measurementProcedure, 'constantStimuli') )
                    for i = 1:def.interleavenum
                        
                        xrange = [min(def.expvar{i}) max(def.expvar{i})];
                        yrange = [0 100];
                        
                        endstepsizeindex = sum(def.practicenum{i});
                        
                        subplot(def.interleavenum,1,i)
                        if ~isempty(work.correct{i})
                            if ( length(work.expvar{i}) > endstepsizeindex )
                                restmp = work.expvar{i}(endstepsizeindex + 1 : end);										% get expvars in measurement phase
                                correcttmp = work.correct{i}(endstepsizeindex + 1 : end);
                                
                                res.range{i} = sort(def.expvar{i});%[min(restmp):def.varstep{i}(end):max(restmp)]';							% determine expvar range
                                res.n_pres{i} = res.range{i} * 0;
                                res.n_correct{i} = res.range{i} * 0;
                                
                                for k = 1:length(restmp)																			% gathering statistics
                                    tmpindex = find(res.range{i} == restmp(k));
                                    res.n_pres{i}(tmpindex) = res.n_pres{i}(tmpindex) + 1;
                                    res.n_correct{i}(tmpindex) = res.n_correct{i}(tmpindex) + correcttmp(k);
                                end
                                
                                %res.range{i}
                                %res.n_pres{i}
                                %res.n_correct{i}
                                
                                for k = 1:length(res.range{i})
                                    % was level presented?
                                    if ( res.n_pres{i}(k) > 0 )
                                        plot(res.range{i}(k),res.n_pres{i}(k),'vk');
                                        hold on;
                                        plot(res.range{i}(k),res.n_correct{i}(k),'+b');
                                        plot(res.range{i}(k),100*res.n_correct{i}(k)/res.n_pres{i}(k),'ok')
                                    end
                                end
                            end
                        end
                        axis([xrange yrange])
                        hold off;
                        
                        xlabel(['Experimental variable (' def.expvarunit ')']);
                        ylabel(['Percent correct']);
                    end
                    
                else
                    % 17.04.2013 18:00 default
                    for i = 1:def.interleavenum
                        
                        xrange = 40;
                        while (length(work.stepnum{i}) >= xrange)
                            xrange = xrange + 10;
                        end
                        
                        yrange = [def.startvar{i}-def.varstep{i}(1)  def.startvar{i}+def.varstep{i}(1)];
                        while ( yrange(1) >= min(work.expvar{i}) )
                            yrange(1) = yrange(1) - def.varstep{i}(1);
                        end
                        while ( yrange(2) <= max(work.expvar{i}) )
                            yrange(2) = yrange(2) + def.varstep{i}(1);
                        end
                        
                        subplot(def.interleavenum,1,i)
                        if ~isempty(work.correct{i})
                            for k=1:length(work.correct{i})
                                
                                style = 'or';
                                
                                
                                plot(work.stepnum{i}(k),work.expvar{i}(k),style)
                                hold on;
                                
                            end
                        end
                        axis([0 xrange yrange])
                        hold off;
                        xlabel('Step number');
                        ylabel(['Tracking variable (' def.expvarunit ')']);
                    end
                end
            end
        end
        
        drawnow;
        % return focus to measurement window
        if ( def.afcwinEnable )
            h=findobj('Tag','afc_win');
            figure(h);
        end
end

% eof