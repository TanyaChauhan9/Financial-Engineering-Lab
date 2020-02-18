clear all
clc
clf
%importing stock data
stock_data_table = readtable('Final_Data.csv');
head(stock_data_table);
stock_data = table2array(removevars(stock_data_table,'Date'))
stock_data(2:end,:)=(stock_data(2:end,:)-stock_data(1:end-1,:))./stock_data(1:end-1,:);
K=stock_data(2:end,:);
m = zeros(1,10);
for i=1:10
    m(i) = mean(K(:,i));
end
c= cov(K);
%part a
u = ones(1,length(m));
mu_v = 0.0001:0.0001:0.08;
[w,sd] = MVL(m,c,mu_v);
plot(sd,mu_v);
xlabel('Risk (\sigma)')
ylabel('Return (\mu)')
title('Markowitz Efficient Frontier')
%part b 
figure()
hold on
plot(sd,mu_v);
xlabel('Risk (\sigma)')
ylabel('Return (\mu)')
mu_rf = 0.001;
gamma_w = (m - mu_rf*u)/c;
gamma = sum(gamma_w);
w_m = gamma_w/gamma;
market_mu = m*transpose(w_m);
market_sd = sqrt((w_m*c)*transpose(w_m));
fprintf('Market Portfolio:\nReturn = %f\nRisk = %f\nWeight of Assets w1 = %f w2 = %f w3 = %f w4 = %f w5 = %f w6 = %f w7 = %f w8 = %f w9 = %f w10 = %f\n',market_mu,market_sd,w_m(1),w_m(2),w_m(3),w_m(4),w_m(5),w_m(6),w_m(7),w_m(8),w_m(9),w_m(10));
%part c
hold on
plot(market_sd,market_mu,'*');
x=0:0.001:0.12;
y=mu_rf+((market_mu-mu_rf)/market_sd)*x;
hold on
plot(x,y,'r');
legend('Markowitz Efficient Frontier','Market Portfolio','Capital Market Line');
%part d
figure()
beta = (mu_v -mu_rf)/(market_mu-mu_rf);
plot (mu_v,beta);
xlabel('\beta Factor (Measure of Systematic Risk)')
ylabel('Return (\mu)')
title('Security Market Line')
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
 