clear all; close all; clc;%echo  off;�ر����������ļ�����ʾ��ʽ 
N_subc=64;%���ز���
BER=1e-4;%�������
gap=-log(5*BER)/1.5; %in dB
P_av=1;
Pt=P_av*N_subc;%�ܷ��͹���
SNR_av=16;
Rt=128;%Ҫ������ܱ�����
Noise=P_av./10.^(SNR_av./10);
%B=1e6;
%N_psd=Noise./(B/N_subc);
N_psd=1.6076e-006;%����Ƶ���ܶ�
M=8;%�����ع������ֵΪ8��
Rb=128;%Ҫ������ܱ�����
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
legend('�ŵ�����');
hold on;
stem(bit_alloc,'fill','MarkerSize',3);
title('Fischer�㷨');
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
legend('�ŵ�����');
hold on;
stem(bit_alloc,'fill','MarkerSize',3);
title('Chow�㷨');
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
legend('�ŵ�����');
hold on;
stem(bit_alloc,'fill','MarkerSize',3);
title('Hughes-Hartogs�㷨');
ylabel('Bit allocation');
xlabel('Subcarriers');
subplot(2,1,2);
stem(power_alloc,'fill','MarkerSize',3);
ylabel('power allocation');
xlabel('Subcarriers');
grid on;