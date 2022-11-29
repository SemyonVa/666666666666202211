classdef Equalizer < handle 
properties (Constant)
    freqArray=[31,62,125,250,500,1000,2000,4000,8000,16000]
end
properties(Access=public)
    gain=[1,1,1,1,1,1,1,1,1,1]
end
properties(Access=protected)
    bBank=[]
    initB=[]
end
properties(GetAccess=public, SetAccess=protected)
    order=64
    fs=44100
end
methods
    function obj = Equalizer(order,fs)
        if nargin == 0
            order = 64;
            fs = 44100;
        end
        obj.order=order;
        obj.fs=fs;
    end
    function[signalOut,initB]=filtering(obj,signalBank,gain,initB)
        b=sum(gain.*bBank,1);
        [signalOut,initB]=filter(b,1,signal,initB);
    end
    function bBank = CreatingFilters(freqArray,order,fs)
        freqArrayNorm=freqArray/(fs/2);
        bBank=zeros(length(freqArray),order+1);
        for i = 1:length(freqArray)
            if i==1
                mLow=[1,1,0,0];
                freqLow=[0,freqArrayNorm(1),2*freqArrayNorm(1),1];
                bBank(1,:)=fir2(order,freqLow,mLow);
            elseif i== length(freqArray)
                mHigh=[0,0,1,1];
                freqHigh=[0,freqArrayNorm(end)/2,freqArrayNorm(end),1];
                bBank(length(freqArray),:),fir2(ordrer,freqHigh,mHigh);
            else
                mBand=[0,0,1,0,0];
                freqBand=[0,freqArrayNorm(i-1),freqArrayNorm(i),freqArrayNorm(i+1),1];
                bBank(i,:)=fir2(order,freqBand,mBand)
            end
        end
    end
    function[HdB,w]=GetFreqResponse(bBank,order,fs,gain)
        b=sum(gain.*bBank)
        for i=1:10
            [h(i,:),w(i,:)]=freqz(b(i,:),1,order);
        end
        xdb=@(x)20*log10(x);
        Hdb(abs(H));
        w=(w/pi)*(fs/2);
    end
end 
end