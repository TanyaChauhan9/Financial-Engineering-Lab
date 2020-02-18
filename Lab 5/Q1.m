clear all
clc
clf
fprintf('\nIndex - BSE SENSEX\n')
[b_names,b_mu_market,b_sigma_market,b_m,b_c]=get_data('bsedata1.csv');
capm(b_m(1,1:10),b_c(1:10,1:10));
figure()
r_f = 0.05;
mu_v=-1:1;
beta = (mu_v -r_f)/(b_mu_market-r_f);
plot (mu_v,beta);
xlabel('\beta Factor (Measure of Systematic Risk)')
ylabel('Return (\mu)')
title('Security Market Line')
b_names = string(b_names);
beta_b = (b_m - r_f)./(b_mu_market - r_f);
fprintf('Betas for stocks included in the Index');
fprintf('Stock Name\t\tBeta\n')
for i=1:10
   fprintf('%s\t\t%f\n',b_names(i),beta_b(i));
end
fprintf('Betas for stocks not included in the Index');
fprintf('Stock Name\t\tBeta\n')
for i=11:20
   fprintf('%s\t\t%f\n',b_names(i),beta_b(i));
end
fprintf('\nIndex - NSE NIFTY50\n')
[n_names,n_mu_market,n_sigma_market,n_m,n_c]=get_data('nsedata1.csv');
capm(n_m(1,1:10),n_c(1:10,1:10));
figure()
r_f = 0.05;
mu_v=-1:1;
beta = (mu_v -r_f)/(b_mu_market-r_f);
plot (mu_v,beta);
xlabel('\beta Factor (Measure of Systematic Risk)')
ylabel('Return (\mu)')
title('Security Market Line')
n_names = string(n_names);
beta_n = (n_m - r_f)./(n_mu_market - r_f);
fprintf('Betas for stocks included in the Index');
fprintf('Stock Name\t\tBeta\n')
for i=1:10
   fprintf('%s\t\t%f\n',n_names(i),beta_n(i));
end
fprintf('Betas for stocks not included in the Index');
fprintf('Stock Name\t\tBeta\n')
for i=11:20
   fprintf('%s\t\t%f\n',n_names(i),beta_n(i));
end
function capm(m,c)
    u= ones(1,length(m));
    mu_v = -2.5:0.001:3.6;
    [~,sd] = MVL(m,c,mu_v);
    mu_rf = 0.05;
    plot(sd,mu_v,'lineWidth',2);
    xlabel('Risk (\sigma)')
    ylabel('Return (\mu)')
    gamma_w = (m - mu_rf*u)/c;
    gamma = sum(gamma_w);
    w_m = gamma_w/gamma;
    market_mu = m*transpose(w_m);
    market_sd = sqrt((w_m*c)*transpose(w_m));
    hold on
    plot(market_sd,market_mu,'*');
    x=0:0.001:1;
    y=mu_rf+((market_mu-mu_rf)/market_sd)*x;
    hold on
    plot(x,y,'r');
    legend('Markowitz Efficient Frontier','Market Portfolio','Capital Market Line');
end
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
function [stock_names,mu_market,sigma_market,m,c] = get_data(file_name)
    stock_data_table = readtable(file_name);
    stock_names = stock_data_table.Properties.VariableNames(:,3:end);
    stock_data = table2array(removevars(stock_data_table,'Month'));
    stock_data(2:end,:)=(stock_data(2:end,:)-stock_data(1,:))./stock_data(1,:);
    K=stock_data(2:end,2:end);
    market_K = stock_data(2:end,1);
    mu_market = mean(market_K);
    sigma_market = sqrt(var(market_K));
    m = mean(K);
    c= cov(K);
end
