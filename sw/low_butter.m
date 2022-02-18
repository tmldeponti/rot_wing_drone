function [arr] = low_butter(arr,filter_freq,sf,debug)
%HIGH_BUTTER Apply a Low pass butter filter to eliminate high frequency
%noise
[b,a] = butter(2,filter_freq/(sf/2),'low')  ;
arr   = filter(b,a,arr)              ;
if debug==1
    figure (200)
    freqz(b,a)
    transfer=tf(b,a);
   transfer2=c2d(transfer,1/500)
end
end

