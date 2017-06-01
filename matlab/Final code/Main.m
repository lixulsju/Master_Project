clear

%% Market data
[Prices,Strikes,Maturity,r,q,Option_type] = importfile('Market_data.csv',2, 111);
Data = [Prices,Strikes,Maturity,r,q,Option_type];

options = optimset('Display','iter','MaxFunEvals', 5000, 'MaxIter', 5000);
%% Option Parameters
S0  = 0.9762;
K   = [0.9306*ones(1,2) 0.9381*ones(1,4) 0.9451*ones(1,46)];
r   = 0.01197;
q   = -0.01237;
N_fixDates = 52;
Period = 1/52;
T = Period*N_fixDates;
gain_fun = @(S,K) max(S-K,0);
loss_fun = @(S,K) max(K-S,0);
g = 2;
Targ = 0.4;
KO = 'F';
ApF = 40000;
%% Models
%  Black-Scholes
sigma = 0.08912;
param_bs = sigma;
model1 = Model('BS',param_bs);
%%  Merton
% sigma   = 0.08912;
% lambda  = 1;        
% alpha   = 0.1;      
% delta   = 0.1;      
% param_mer = [sigma,lambda,alpha,delta];
param_mer = [0.0491   12.3576    0.0126    0.0071]; % Calibrated
% Calibration %
% Nx = 1000;
% param_mer = fminsearch(@(p) RMSE(p, 'Mer', S0, Data,Nx),param_mer, options)
model2 = Model('Merton',param_mer);
%%  Kou
% sigma   = 0.0461;       
% lambda  = 4.0562;        
% p       = 0.5;   
% eta1    = 100;          
% eta2    = 100;         
% param_kou = [sigma, lambda, p, eta1, eta2];
param_kou = [0.0449   46.7484    1.0000  177.3752  156.2789]; % Calibrated
% Calibration %
% lb = [0 0 0 0 0];
% ub = [Inf Inf 1 Inf Inf];
% param_kou = fmincon(@(p) RMSE(p, 'Kou', S0, Data,Nx),param_kou,[],[],[],[],lb,ub,[],options)
% param_kou = fminsearch(@(p) RMSE(p, 'Kou', S0, Data,Nx),param_kou,options)
model3 = Model('Kou',param_kou);
 %%  NIG
% alpha = 28;     
% beta  =-15;    
% delta = 0.3;  
% param_nig = [alpha,beta,delta];
param_nig = [340.5625  224.2751    0.7227]; % Calibrated
% Calibration
% param_nig = fminsearch(@(p) RMSE(p, 'Nig', S0, Data,Nx),param_nig,options)
model4 = Model('NIG',param_nig);
%%  VG
% theta =  0.0039;
% sigma =  0.0338;
% nu    =  28.4765;
% param_vg = [theta,sigma,nu];
param_vg = [0.4985    0.0558    0.0075]; % Calibrated
% Calibration
% param_vg = fminsearch(@(p) RMSE(p, 'VG', S0, Data,Nx),param_vg, options)
model5 = Model('VG',param_vg);

%% Methods
%  Monte Carlo
N_sim = 1e6;
method1 = Method('MC',N_sim);
%  Finite Difference
Na = 100;
Nx = 1000;
Nt = 40;
method2 = Method('FD',[Na, Nx, Nt]);
%  Convolution
Na = 200;
Nx = 2000;
alpha = 0;
method3 = Method('Conv',[Na, Nx, alpha]);

%% Pricing
TARN_MC_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);

TARN_FD_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);

TARN_Conv_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);

figure
hold on

disp('---------- Black-Scholes ----------')
% TARN_MC_BS.set_price(model1,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_BS.price)));
% TARN_FD_BS.set_price(model1,method2);
% disp(TARN_FD_BS.price)
TARN_Conv_BS.set_price(model1,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_BS.price)));

disp('---------- Merton -----------------')
% TARN_MC_Mer.set_price(model2,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_Mer.price)));
% TARN_FD_Mer.set_price(model2,method2);
% disp(TARN_FD_Mer.price)
TARN_Conv_Mer.set_price(model2,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_Mer.price)));

disp('---------- Kou --------------------')
% TARN_MC_Kou.set_price(model3,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_Kou.price)));
% TARN_FD_Kou.set_price(model3,method2);
% disp(TARN_FD_Kou.price)
TARN_Conv_Kou.set_price(model3,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_Kou.price)));

disp('---------- NIG --------------------')
% TARN_MC_NIG.set_price(model4,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_NIG.price)));
% TARN_FD_NIG.set_price(model4,method2);
% disp(TARN_FD_NIG.price)
TARN_Conv_NIG.set_price(model4,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_NIG.price)));

disp('---------- VG ---------------------')
% TARN_MC_VG.set_price(model5,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_VG.price)));
% TARN_FD_VG.set_price(model5,method2);
% disp(TARN_FD_VG.price);
TARN_Conv_VG.set_price(model5,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_VG.price)));
