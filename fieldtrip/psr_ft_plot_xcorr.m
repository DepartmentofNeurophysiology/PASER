function psr_ft_plot_xcorr(XCorr,parameters,clustIDs)

if (length(clustIDs) ~= 2); disp(['Error in "' mfilename '" -- Must input two unit indices']); return; end 

% Initialize

cfg            = [];
cfg.color      = 'k';
cfg.linewidth  = 1.5;
cfg.marker     = 'none';
cfg.markersize = 3;

if (~psr_isempty_field(parameters,'parameters.analysis.xcorr.plot.color'));      cfg.color      = parameters.analysis.xcorr.plot.color;      end
if (~psr_isempty_field(parameters,'parameters.analysis.xcorr.plot.linewidth'));  cfg.linewidth  = parameters.analysis.xcorr.plot.linewidth;  end
if (~psr_isempty_field(parameters,'parameters.analysis.xcorr.plot.marker'));     cfg.marker     = parameters.analysis.xcorr.plot.marker;     end
if (~psr_isempty_field(parameters,'parameters.analysis.xcorr.plot.markersize')); cfg.markersize = parameters.analysis.xcorr.plot.markersize; end

t = XCorr.time;
y = squeeze(XCorr.xcorr(clustIDs(1),clustIDs(2),:));
plot(t,y,...
    'Color',     cfg.color,...
    'LineWidth', cfg.linewidth,...
    'Marker',    cfg.marker,...
    'MarkerSize',cfg.markersize);
   
ylabelStr = [];
switch XCorr.cfg.outputunit
    case 'raw';        ylabelStr = 'Cross-correlation';
    case 'center';     ylabelStr = 'Scaled \ cross-correlation';
    case 'proportion'; ylabelStr = 'Proportion \ of \ occurence';        
end
ylabel(['\bf{' ylabelStr '}'],'Interpreter','Latex');
xlabel( '\bf{Lag \ [s]}',     'Interpreter','Latex');
set(gca,'TickLabelInterpreter','Latex');

end