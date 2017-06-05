clear

S0 = 1;
K = 1;
Targ = 0.5;
Na = 1000;
Nx = 1000;
A = linspace(0,Targ,Na);
Xmin = -5;
Xmax = 2;
dx = (Xmax-Xmin)/Nx;
x = Xmin + (0:Nx-1)*dx;
S = S0*exp(x);

NoGain = zeros(Na,Nx);
PartGain = zeros(Na,Nx);
FullGain = zeros(Na,Nx);
for j = 1:Nx
    NoGain(:,j) = (max(S(j)-K,0).*((S(j)-K) < Targ-A));
    PartGain(:,j) = (max(S(j)-K,0).*((S(j)-K) < Targ-A)+(Targ-A).*((S(j)-K) > Targ-A));
    FullGain(:,j) = (max(S(j)-K,0));
end
figure(1)
surf(S,A,NoGain,'EdgeColor','none','LineStyle','none');
xlim([0,2])
figure(2)
surf(S,A,PartGain,'EdgeColor','none','LineStyle','none');
xlim([0,2])
figure(3)
surf(S,A,FullGain,'EdgeColor','none','LineStyle','none');
xlim([0,2])
zlim([0 2])