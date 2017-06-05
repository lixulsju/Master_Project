BS_errors = [TARN_MC_BS_3N.error, ...
    TARN_MC_BS_4N.error, ...
    TARN_MC_BS_5N.error, ...
    TARN_MC_BS_6N.error] ;
Mer_errors = [TARN_MC_Mer_3N.error, ...
    TARN_MC_Mer_4N.error, ...
    TARN_MC_Mer_5N.error, ...
    TARN_MC_Mer_6N.error] ;
Kou_errors = [TARN_MC_Kou_3N.error, ...
    TARN_MC_Kou_4N.error, ...
    TARN_MC_Kou_5N.error, ...
    TARN_MC_Kou_6N.error] ;
NIG_errors = [TARN_MC_NIG_3N.error, ...
    TARN_MC_NIG_4N.error, ...
    TARN_MC_NIG_5N.error, ...
    TARN_MC_NIG_6N.error] ;
VG_errors = [TARN_MC_VG_3N.error, ...
    TARN_MC_VG_4N.error, ...
    TARN_MC_VG_5N.error, ...
    TARN_MC_VG_6N.error] ;

plot(3:6,BS_errors,'linewidth',2)
hold on
plot(3:6,Mer_errors,'linewidth',2)
plot(3:6,Kou_errors,'linewidth',2)
plot(3:6,NIG_errors,'linewidth',2)
plot(3:6,VG_errors,'linewidth',2)
plot(3:0.01:6,0.14*1./sqrt(10.^(3:0.01:6)),'-.k','linewidth',1)
title('\fontsize{14} Monte Carlo simulations standard errors')
ylabel('\fontsize{12} Standard Error (SE)')
xlabel('\fontsize{12} log(M)')
l=legend('Black-Scholes','Merton','Kou','NIG','VG','$\frac{C}{\sqrt{M}}$');
set(l,'Interpreter','latex')