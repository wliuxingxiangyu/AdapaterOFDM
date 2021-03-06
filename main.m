clear all; close all; clc;%echo  off;关闭所有命令文件的显示方式 
N_subc=50;%子载波数
BER=1e-4;%误比特率
gap=-log(5*BER)/1.5; %in dB %信噪比间隙（常量）(dB)gap=5.068只在chow算法中用
P_av=1;%归一化信号平均功率
Pt=P_av*N_subc;%总发送功率
SNR_av=16;
Rt=128;%要分配的总比特数，总比特数（数据传输速率）
Noise=P_av./10.^(SNR_av./10);%据SNR求出噪声功率Noise
%B=1e6;
%N_psd=Noise./(B/N_subc);
N_psd=1.6076e-006;%功率频谱密度
M=8;%但比特功率最大值为8？
Rb=128;%要分配的总比特数
%H=random('rayleigh',1,1,N_subc);
gain_subc=random('rayleigh',1,1,N_subc);
%------------------plot------------------------------
%%------------------fisher----------------------------
tic %tic用来保存当前时间，而后使用toc来记录程序完成时间。
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
hold on;
stem(bit_alloc,'fill','MarkerSize',3);
title('Fischer算法');
ylabel('Bits allocation');
xlabel('Subcarriers');
legend('相对速度','比特分配');

subplot(2,1,2);
plot(gain_subc,'-r');
hold on;
stem(power_alloc,'fill','MarkerSize',3);
ylabel('Power allocation');
xlabel('Subcarriers');
legend('相对速度','功率分配');
t1=0;
t1=toc
%%-----------------chow------------------------------
%subcar_gains=random('rayleigh',1,1,N_subc);
SNR=(gain_subc.^2)./(Noise*gap); %信噪比间隙（常量）(dB)gap=5.068
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
hold on;
stem(bit_alloc,'fill','MarkerSize',3);
title('Chow算法');
ylabel('Bits allocation');
xlabel('Subcarriers');
legend('相对速度','比特分配');
subplot(2,1,2);
plot(gain_subc,'-r');
hold on;
stem(power_alloc,'fill','MarkerSize',3);
ylabel('Power allocation');
xlabel('Subcarriers');
legend('相对速度','功率分配');
%%------------------Hughes-Hartogs--------------------
[bit_alloc, power_alloc]=Hughes_Hartogs(N_subc,Rb,M,BER,N_psd,gain_subc);
bit_alloc;
power_alloc1=power_alloc;
sum_bit=0;
sum_bit=sum(bit_alloc)
sum_pow=0;
sum_pow=sum(power_alloc1)

power_alloc=Pt.*(power_alloc./sum(power_alloc));
figure(3);
% subplot(2,1,1);
plot(gain_subc,'-r');
hold on;
stem(bit_alloc,'fill','MarkerSize',3);
legend('归一化相对速度','归一化比特分配');
title('HARA算法');
ylabel('归一化比特分配');
xlabel('信道序号');%Subcarriers

% subplot(2,1,2);
figure(4);
plot(gain_subc,'-r');
hold on;
power_alloc(find(power_alloc==0) )=0.5+eps;
stem(power_alloc,'fill','MarkerSize',3);
legend('归一化相对速度','归一化功率分配');
ylabel('归一化功率分配');
xlabel('信道序号');%Subcarriers
% grid on;