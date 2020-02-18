clear all;
clc;   
m = [0.1,0.2,0.15];
c = [0.005,-0.010,0.004;
  -0.010,0.040,-0.002;
   0.004,-0.002,0.023];
u = ones(1,length(m));
min_w = (u/c)/((u/c)*transpose(u));
min_sd = sqrt((min_w*c)*transpose(min_w));
mu_v = 0.0001:0.0001:0.3;
[w,sd] = MVL(m,c,mu_v);
%part a
plot(sd,mu_v,'.');
xlabel('Risk (\sigma)')
ylabel('Return (\mu)')
title('Markowitz Efficient Frontier')

%part b
fprintf('Index\tw1\t\tw2\t\tw3\t\tReturn\t\tRisk\n');
for i=50:50:500
   fprintf('%d\t%f\t%f\t%f\t%f\t%f\n',i,w(i,1),w(i,2),w(i,3),mu_v(i),sd(i));
end
%part c and d
ret_15=[];
for i=1:length(mu_v)
    if (abs(sd(i)-0.15)<0.0001)
        ret_15=[ret_15,[mu_v(i),w(i,:)]];
    end
    if (mu_v(i)== 0.18) 
        risk_18=sd(i);
        fprintf('Portfolio for 18%% return with Minimum Risk:\nWeights: w1 = %f w2 = %f w3 = %f\n Risk = %f\n',w(i,1),w(i,2),w(i,3),risk_18);
    end
end
fprintf('Portfolio for 15%% risk with Minimum Return:\nReturn = %f\nWeights: w1 = %f w2 = %f w3 = %f\n',ret_15(1),ret_15(2),ret_15(3),ret_15(4));
fprintf('Portfolio for 15%% risk with Maximum Return:\nReturn = %f\nWeights: w1 = %f w2 = %f w3 = %f\n',ret_15(5),ret_15(6),ret_15(7),ret_15(8));
%part e 
figure()
hold on
plot(sd,mu_v);
xlabel('Risk (\sigma)')
ylabel('Return (\mu)')
mu_rf = 0.1;
gamma_w = (m - mu_rf*u)/c;
gamma = sum(gamma_w);
w_m = gamma_w/gamma;
market_mu = m*transpose(w_m);
market_sd = sqrt((w_m*c)*transpose(w_m));
hold on
plot(market_sd,market_mu,'*');
x=0:0.001:0.4;
y=mu_rf+((market_mu-mu_rf)/market_sd)*x;
hold on
plot(x,y,'b');
legend('Markowitz Efficient Frontier','Market Portfolio','Capital Market Line');
%part f
sig = 0.1;
mu = mu_rf +((market_mu-mu_rf)/market_sd)*sig;
w_rf1 = (mu-market_mu)/(mu_rf-market_mu);
w_r1 = (1-w_rf1)*w_m;
fprintf('Portfolio for 10%% risk\nReturn = %f\nWeight of Risk-Free Asset = %f\nWeight of Risky Assets w1 = %f w2 = %f w3 = %f\n',mu,w_rf1,w_r1(1),w_r1(2),w_r1(3));

sig = 0.25;
mu = mu_rf +((market_mu-mu_rf)/market_sd)*sig;
w_rf1 = (mu-market_mu)/(mu_rf-market_mu);
w_r1 = (1-w_rf1)*w_m;
fprintf('Portfolio for 25%% risk\nReturn = %f\nWeight of Risk-Free Asset = %f\nWeight of Risky Assets w1 = %f w2 = %f w3 = %f\n',mu,w_rf1,w_r1(1),w_r1(2),w_r1(3));

function [w,sd] = MVL(m,c,mu_v)
    n = length(m);
    u = ones(1,n);
    ucinv = u/c;
    mcinv = m/c;
    w = [];
    sd = [];
    for i=1:length(mu_v)
        w1 = det([1,ucinv*transpose(m);mu_v(i),mcinv*transpose(m)])*ucinv;
        w2 = det([ucinv*transpose(u),1;mcinv*transpose(u),mu_v(i)])*mcinv;
        w3 = det([ucinv*transpose(u),ucinv*transpose(m);mcinv*transpose(u),mcinv*transpose(m)]);
        w_i = (w1 +w2)/w3;
        w = [w;w_i];
        sd(i) = sqrt((w_i*c)*transpose(w_i));
    end
end
