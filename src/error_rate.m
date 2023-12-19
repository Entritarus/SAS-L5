Fs = 1e6;
tau = 1/Fs;

N = 50; % samples of a single symbol

%% Barker signal generation
barker_sig = [1 1 -1];
input_sig = [kron(barker_sig, ones(1, N)) zeros(1, N*7)];
P_avg_sig = rms(input_sig)^2;

%% Matched filter
imp_resp = fliplr(barker_sig);
b = kron(imp_resp, ones(1, N))/(N*length(barker_sig));


%% Error rate vs SNR
SNR_v = [];
err_rate = [];
threshold = 0.6;
for std_dev = 0.1:0.1:10

    noise = std_dev*randn(1, length(input_sig));
    P_avg_noise = rms(noise)^2;
    SNR_v = [SNR_v 10*log10(P_avg_sig/P_avg_noise)];

    %% Adding noise to signal
    sampled = zeros(1, 100);
    for i = 1:100
        noise = std_dev*randn(1, length(input_sig));
        input_sig_noise = input_sig + noise;
        bs_filt = filter(b, 1, input_sig_noise);
        sampled(i) = bs_filt(150) >= threshold;
    end
    err_rate = [err_rate mean(ones(1,100)-sampled)];
end

%% Plots
fig3 = figure(3);
scatter(SNR_v, err_rate, 'r', 'filled'); grid on; grid minor;
xlabel('SNR, dB');
ylabel('Error rate');
title("Error rate vs SNR");

