function freqMain = psr_append_freq(freqMain,freq)

if (isempty_field(freqMain,'freqMain.artifacts'));    freqMain.artifacts    = []; end
if (isempty_field(freqMain,'freqMain.sampleinfo'));   freqMain.sampleinfo   = []; end
if (isempty_field(freqMain,'freqMain.time'));         freqMain.time         = []; end
if (isempty_field(freqMain,'freqMain.trial'));        freqMain.trial        = []; end
if (isempty_field(freqMain,'freqMain.hdr.nSamples')); freqMain.hdr.nSamples = []; end

N = sum(freqMain.hdr.nSamples);
if (isempty(N)); N = 0; end

if (~isempty_field(freq,'freq.artifacts'));    freqMain.artifacts    = [freqMain.artifacts;  freq.artifacts  + N]; end
if (~isempty_field(freq,'freq.sampleinfo'));   freqMain.sampleinfo   = [freqMain.sampleinfo; freq.sampleinfo + N]; end
if (~isempty_field(freq,'freq.time'));         freqMain.time         = [freqMain.time,       freq.time];           end
if (~isempty_field(freq,'freq.trial'));        freqMain.trial        = [freqMain.trial,      freq.trial];          end
if (~isempty_field(freq,'freq.hdr.nSamples')); freqMain.hdr.nSamples = freqMain.hdr.nSamples + freq.hdr.nSamples;  end

end