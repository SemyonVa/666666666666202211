function bBank = CreatingFilters(freqArray, order, fS)
freqArrayNorm = freqArray/(fS/2);
bBank = zeros(length(freqArray),order+1);
for i = 1:length(freqArray)
if i==1
mLow = [1, 1, 0, 0];
freqLow = [0, freqArrayNorm(1), 2*freqArrayNorm(1), 1];
bBank(1, :) = fir2(order, freqLow, mLow);
elseif i == length(freqArray)
mHigh = [0, 0, 1, 1];
freqHigh = [0, freqArrayNorm(end)/2, freqArrayNorm(end),1];
bBank(length(freqArray),:) = fir2(order, freqHigh, mHigh);
else
mBand = [0, 0, 1, 0, 0];
freqBand = [0, freqArrayNorm(i-1), freqArrayNorm(i), freqArrayNorm(i+1), 1];
bBank(i, :) = fir2(order, freqBand, mBand);
end
end
end