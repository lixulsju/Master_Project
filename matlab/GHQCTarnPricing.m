function [ Price ] = GHQCTarnPricing(S0,K,r_d,r_f,sigma,period,Targ,N_fixDates,Nx,Na,KO_type,q_order,tol)
T = N_fixDates*period;
dt = period;

tau = sigma*sqrt(dt);
nu =(r_d-r_f-0.5*sigma^2)*dt;

A = linspace(0,Targ,Na);

% Hermite polynomials of order q_order :
u = sqrt((1:q_order-1)/2);
[V,Lambda] = eig(diag(u,1)+diag(u,-1));
[xi,i] = sort(diag(Lambda));
Vtop = V(1,:);
Vtop = Vtop(i);
w = sqrt(pi)*Vtop.^2;

% step 1 :
Smin = K*exp(-(r_d-r_f)*T-0.5*sigma^2*T+sigma*sqrt(T)*norminv(tol/K));
Smax = K*exp(0.5*sigma^2*T - sigma*sqrt(T)*norminv(tol/K));

Xmin = log(Smin/S0);
Xmax = log(Smax/S0);

h = (Xmax-Xmin)/Nx;
X = Xmin + (0:Nx)*h;
S = S0*exp(X);

% step 2 :
Q = zeros(Nx+1,Na);
Qnew = Q;
for k = 1:N_fixDates
    for m = 1:Nx+1
        Ctild = max(S(m)-K,0);
        switch KO_type
            case 'fullGain'
                W = 1;
            case 'noGain  '
                W = 0;
            case 'partGain'
                W = (Targ-A)/(S(m)-K);
        end
        C = Ctild .* ( ( (A+Ctild)<Targ )+W .*( (A+Ctild)>=Targ ) );
        Aplus  = A + C;
        Q(m,:) = interp1(A,Q(m,:),Aplus,'spline').*(Aplus<Targ);
        Qnew(m,:) = Q(m,:)+C;
    end
    for j = 1:Na
        % Step 3 :
        Qint = griddedInterpolant(X,Qnew(:,j),'cubic');
        % step 4 :
        for m = 1:Nx+1
            Q(m,j) = exp(-r_d*dt)/sqrt(pi) * (w*Qint(sqrt(2)*tau*xi+nu+X(m)));
        end
    end
end
%%
Price = interp1(S,Q(:,1),S0);
