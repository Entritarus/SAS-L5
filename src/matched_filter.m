Fs = 1e6;
tau = 1/Fs;

N = 50; % samples of a single symbol

%% Barker signal generation
barker_sig = [1 1 -1];
input_sig = [kron(barker_sig, ones(1, N)) zeros(1, N*7)];
P_avg_sig = rms(input_sig)^2;
disp(['P_avg_sig = ' num2str(P_avg_sig)]);

%% Noise generation
rng(123);
std_dev = 1; % CAN CHANGE THIS
noise = std_dev*randn(1, length(input_sig));
P_avg_noise = rms(noise)^2;
disp(['P_avg_noise = ' num2str(P_avg_noise)]);

%% Adding noise to signal
input_sig_noise = input_sig + noise;

SNR = 10*log10(P_avg_sig/P_avg_noise);
disp(['SNR = ' num2str(SNR)]);

%% Matched filter
imp_resp = fliplr(barker_sig);
b = kron(imp_resp, ones(1, N))/(N*length(barker_sig));

%% Plots
% Impulse response
t = 0:tau:(length(input_sig)-1)*tau;
fig1 = figure(1);
stem(b, 'r-', 'linewidth', 1.5); grid on; grid minor;
xlabel('k');
ylabel('h[k]');
ylim([-0.01 0.01]);
title("Filter impulse response");

% Signal filtering
fig2 = figure(2);
plot(t*1e6, input_sig_noise, 'r-', 'linewidth', 1.5);
hold on; grid on; grid minor;

plot(t*1e6, input_sig, 'b-', 'linewidth', 1.5);

bs_filt = filter(b, 1, input_sig_noise);
plot(t*1e6, bs_filt, 'g-', 'linewidth', 1.5);

xlabel('t, us');
ylabel('s(t)');
legend('Noisy signal', 'Original signal', 'Filtered noisy signal');
title("Input and output of the filter");