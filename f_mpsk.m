function power=f_mpsk(b,Pe,N_psd)%N_psd为噪声功率谱密度
switch b
    case 0
        power=0;
    case 1
        power=N_psd/2*(Qinv(Pe))^2;%余补误差函数的反函数pe求信噪比（信号功率）
    case 2
        power=N_psd*(Qinv(1-sqrt(1-Pe)))^2;
    otherwise
        power=N_psd/2*(Qinv(Pe/2)/sin(pi/2^b))^2;
end
