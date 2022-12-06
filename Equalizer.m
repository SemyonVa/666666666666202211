classdef Equalizer < handle 
    properties(Constant)
        freqArray=[31,62,125,250,500,1000,2000,4000,8000,16000]
    end
    properties(Access=public)
        gain=[1,1,1,1,1,1,1,1,1,1]
    end
    properties(Access=protected)
        bBank=[]
        initB=[]
    end
    properties(GetAccess=public,SetAccess=protected)
        fS=44100
        order=64
    end
    methods
        function obj = Equalizer(order,fS)
            if nargin == 0
                order = 64;
                fS = 44100;
            end
            obj.order=order;
            obj.fS=fS;
            CreatingFilters();
        end
        function[signalOut,initB]=Filtering(obj)
            b=sum(obj.gain.*obj.bBank,1);
            [signalOut,initB]=filter(b,1,signal,initB);
        end
       function CreatingFilters(obj)
            freqArrayNorm = obj.freqArray/(obj.fS/2);
                for i = 1:length(obj.freqArray)
                    if i==1
                        mLow = [1, 1, 0, 0];
                        freqLow = [0, freqArrayNorm(1), 2*freqArrayNorm(1), 1];
                        obj.bBank(1, :) = fir2(obj.order, freqLow, mLow);
                    elseif i == length(obj.freqArray)
                        mHigh = [0, 0, 1, 1];
                        freqHigh = [0, freqArrayNorm(end)/2, freqArrayNorm(end),1];
                        obj.bBank(length(obj.freqArray),:) = fir2(obj.order, freqHigh, mHigh);
                    else
                        mBand = [0, 0, 1, 0, 0];
                        freqBand = [0, freqArrayNorm(i-1), freqArrayNorm(i), freqArrayNorm(i+1), 1];
                        obj.bBank(i, :) = fir2(obj.order, freqBand, mBand);
                    end
            end
       end
       function [Hdb,w]=GetFreqResponse(obj)
           b=sum(obj.gain.*obj.bBank);
           for i=1:10
               [H(i,:),w(i,:)]=freqz(b(i,:),1,obj.order);
           end
           xdb=@(x)20*log10(x); 
           Hdb=xdb(abs(H));
           w=(w/pi)*(obj.fS/2);
       end
    end
end