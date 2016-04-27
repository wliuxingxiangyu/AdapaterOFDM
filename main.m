clear all; close all; clc;%echo  off;关闭所有命令文件的显示方式 
N_subc=64;%子载波数
BER=1e-4;%误比特率
gap=-log(5*BER)/1.5; %in dB
P_av=1;
Pt=P_av*N_subc;%总发送功率
SNR_av=16;
Rt=128;%要分配的总比特数
Noise=P_av./10.^(SNR_av./10);
%B=1e6;
%N_psd=Noise./(B/N_subc);
N_psd=1.6076e-006;%功率频谱密度
M=8;%但比特功率最大值为8？
Rb=128;%要分配的总比特数
%H=random('rayleigh',1,1,N_subc);
gain_subc=random('rayleigh',1,1,N_subc);
%------------------plot------------------------------
%------------------fisher----------------------------
tic
[bit_alloc power_alloc]=Fischer(N_subc,Rt,Pt,gain_subc);
bit_alloc;
power_alloc1=power_alloc;
sum_bit=0;
sum_bit=sum(bit_alloc)
sum_pow=0;
sum_pow=sum(power_alloc1)
power_alloc=Pt.*(power_alloc./sum(power_alloc));

clf;
figure(1);
subplot(2,1,1);
plot(gain_subc,'-r');
legend('信道增益');
hold on;
stem(bit_alloc,'fill','MarkerSize',3);
title('Fischer算法');
ylabel('Bits allocation');
xlabel('Subcarriers');
subplot(2,1,2);
stem(power_alloc,'fill','MarkerSize',3);
ylabel('Power allocation');
xlabel('Subcarriers');
t1=0;
t1=toc
%------------------chow------------------------------
%subcar_gains=random('rayleigh',1,1,N_subc);
SNR=(gain_subc.^2)./(Noise*gap); 
[bit_alloc power_alloc Iterate_count]=chow_algo(SNR,N_subc,gap,Rt);
bit_alloc;

power_alloc1=power_alloc;
sum_bit=0;
sum_bit=sum(bit_alloc)
sum_pow=0;
sum_pow=sum(power_alloc1)

power_alloc=Pt.*(power_alloc./sum(power_alloc));
figure(2);
subplot(2,1,1);
plot(gain_subc,'-r');
legend('信道增益');
hold on;
stem(bit_alloc,'fill','MarkerSize',3);
title('Chow算法');
ylabel('Bits allocation');
xlabel('Subcarriers');
subplot(2,1,2);
stem(power_alloc,'fill','MarkerSize',3);
ylabel('Power allocation');
xlabel('Subcarriers');
%------------------Hughes-Hartogs--------------------
[bit_alloc, power_alloc]=Hughes_Hartogs(N_subc,Rb,M,BER,N_psd,gain_subc);
bit_alloc;

power_alloc1=power_alloc;
sum_bit=0;
sum_bit=sum(bit_alloc)
sum_pow=0;
sum_pow=sum(power_alloc1)

power_alloc=Pt.*(power_alloc./sum(power_alloc));
figure(3);
subplot(2,1,1);
plot(gain_subc,'-r');
legend('信道增益');
hold on;
stem(bit_alloc,'fill','MarkerSize',3);
title('Hughes-Hartogs算法');
ylabel('Bit allocation');
xlabel('Subcarriers');
subplot(2,1,2);
stem(power_alloc,'fill','MarkerSize',3);
ylabel('power allocation');
xlabel('Subcarriers');
grid on;