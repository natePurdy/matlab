function [combined_signal, resulting_time] = add_two_signals_differing_lengths(sig1,times1, sig2,times2)
    if (length(times2) > length(times1))
        % second signal is more delayed, pad the shorter one with zeros
        resulting_time = times2;
        dif = length(times2)-length(times1);
        sig1 = [sig1 zeros(1,dif )];
    else
        % first signal is more delayed (longer), pad the shorter one with zeros
        resulting_time = t_array_1;
        dif = length(times1)-length(times2);
        sig2 = [sig2 zeros(1,dif )];
        
    end
    combined_signal = sig1 + sig2;
    
end