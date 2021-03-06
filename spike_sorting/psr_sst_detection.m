function spikes = psr_sst_detection(spikes, data, parameters)

if (size(data,2) > size(data,1)); data = data'; end % Convert input
data = psr_int16_to_single(data,parameters);

% Set constants

Fs          = parameters.Fs;
sLength     = size(data,1); % total number of samples in signal
nChan       = size(data,2);
sWindow     = round(Fs * parameters.spikes.window_size / 1000);
sWindowHalf = round(0.5 * (sWindow - 1));
precision   = 10^parameters.general.precision;
thresh      = parameters.spikes.thresh * spikes.info.bgn;

% Find peaks in signal that exceed threshold

locations = false(nChan,sLength);
peaks     = zeros(nChan,sLength);

for iChan = 1:nChan
    signalChan = data(:,iChan);
    del = signalChan > thresh(iChan);
    I   = find(~del); % Keep raw locations of thresholded data
    signalChan(del) = []; % Ignore sub-threshold data
    if (length(signalChan) > 3) % Condition required for 'findpeaks'
        [pks,loc] = findpeaks(double(sign(thresh(iChan)) * signalChan));
        loc = I(loc); % find locations of peaks in raw data
        locations(iChan,loc) = true;
        peaks(iChan,loc)     = pks;
    end
end

divisor   = abs(repmat(spikes.info.thresh', 1, size(peaks,2)));
peaks     = peaks ./ divisor; % Normalize depending on threshold
peaksMax  = max(peaks); % Maximum amplitude channel
locations = find(sum(locations));
peaksMax  = peaksMax(locations);

% Deal with immediately adjacent peaks, within spike window.
% Keep largest amplitude peak

indices = diff(locations) <= sWindowHalf;
indices = [indices,0];
nspikes = length(indices);
indices = [indices,0]; % needed for stop criterion
peakLocations = [];
iSpike = 1;
while iSpike <= nspikes
    pks = [];
    itr = 0;
    while(itr == 0 || indices(iSpike+itr-1))
        pks = [pks;peaksMax(iSpike+itr)]; %#ok
        itr = itr + 1;
    end
    [~,I] = max(pks);
    peakLocations = [peakLocations;locations(iSpike+I-1)]; %#ok
    iSpike = iSpike + itr;
end

% Save

locations = peakLocations';
locations(locations <= sWindowHalf) = [];
locations(locations > sLength - sWindowHalf) = [];
spiketimes = (locations - 1) / Fs;
spikes.spiketimes = single(spiketimes);

indices = bsxfun(@plus,locations,(-sWindowHalf:sWindowHalf)');
waveforms = data(indices, :);
waveforms = reshape(waveforms,size(indices,1),size(indices,2),nChan);
waveforms = permute(waveforms,[2 1 3]);
spikes.waveforms = int16(precision * waveforms);

end