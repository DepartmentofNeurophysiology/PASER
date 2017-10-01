function spikes = ept_sst_filter_rpv(spikes)

nclusts = length(unique(spikes.assigns));

for iclust = 1:nclusts
    
    show = get_spike_indices(spikes, iclust);
    
    x = spikes.waveforms(show,:) * spikes.info.pca.v(:,1);
    y = spikes.waveforms(show,:) * spikes.info.pca.v(:,2);
    z = spikes.waveforms(show,:) * spikes.info.pca.v(:,3);
    
    PCA3 = [x,y,z];
    
    % Find refractory period violations (RPVs)
    
    spiketimes   = spikes.unwrapped_times(show);
    rpvs         = diff(spiketimes) <= 0.001 * spikes.params.detect.ref_period;
    rpvs         = [0,rpvs]; %#ok
    rpvs         = find(rpvs);
    id           = zeros(size(spiketimes));
    id(rpvs)     = 1;
    id(rpvs - 1) = 1;
    id           = find(id);
    
    % Each RPV involves two or more spike. We remove enough spikes to resolve
    % the RPV, where we keep the spikes that have the smallest Mahalanobis
    % distance to cluster
    
    num_rpvs = length(id);
    itr = 1;
    del = [];
    n   = 0;
    
    while (itr < num_rpvs)
        if (spiketimes(id(itr+1)) - spiketimes(id(itr)) <= 0.001 * spikes.params.detect.ref_period)
            v     = [id(itr);id(itr+1)];
            itrV  = [itr;itr+1];
            [~,I] = max(mahal(PCA3(v,:),PCA3));
            I1    = itrV(I);
            I2    = v(I);
            spiketimes(I2) = [];
            PCA3(I2,:)     = [];
            id(I1:end)     = id(I1:end) - 1;
            id(I1)         = [];
            del = [del;I2+n]; %#ok
            num_rpvs = num_rpvs - 1;
            itr = itr - 1;
            n   = n + 1;
        end
        
        itr = itr + 1;
    end
    
    id = show(del);
    spikes = ept_sst_spike_removal(spikes,id,'array');
    
end

end