function psr_ft_plot_raster(spikesFT,psth,parameters,clustIDs)

cfg = [];
cfg.interactive  = 'no';
if (~isempty(psth))
    if (nargin == 4); cfg.spikechannel = psth.label(clustIDs); end
    if (~isempty_field(parameters,'parameters.analysis.raster.topplotfunc')); cfg.topplotfunc = parameters.analysis.raster.topplotfunc; end
    if (~isempty_field(parameters,'parameters.analysis.raster.markersize'));  cfg.markersize  = parameters.analysis.raster.markersize;  end
    if (~isempty_field(parameters,'parameters.analysis.raster.errorbars'));   cfg.errorbars   = parameters.analysis.raster.errorbars;   end

    psr_ft_spike_plot_raster(cfg,spikesFT,psth);
end
end