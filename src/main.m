close all
clear variables
Fs = 1e6;
tau = 1/Fs;

N = 50;

barker_sig = [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];
%barker_sig = [1 1 -1];
barker_sig_ups = kron(barker_sig, ones(1, N));

std_dev = 2;
noise = std_dev*randn(1, length(barker_sig_ups));

barker_sig_ups = barker_sig_ups +

imp_resp = fliplr(barker_sig);
b = kron(imp_resp, ones(1, N));

t = 0:tau:(length(barker_sig)*N-1)*tau;

fig1 = figure(1);
subplot(2,1,1);
plot(t*1e6, b); grid on; grid minor;
xlabel('t, us');
ylabel('s_{in}(t)');
ylim([-1.1 1.1]);

subplot(2,1,2);
bs_filt = filter(b, 1, barker_sig_ups);
plot(t*1e6, bs_filt);
xlabel('t, us');
ylabel('s_{out}(t)');

