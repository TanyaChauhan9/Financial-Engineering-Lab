clear all
clc

S0 = 50:5:150;
S0_1 = 100;
M = 1:1:10;
M_1 =100;
K = 50:1:150;
K_1 = 100;
T = 1;
r = 0.01:0.01:0.16;
r_1 = 0.08;
sigma = 0.05:0.01:0.4;
sigma_1 = 0.2;

%part A
[call_1,put_1] = American_Option(S0_1,T,K_1,r_1,sigma_1,M_1);
fprintf('\nThe call price for the given Initial Values is %f\nThe put price for the given Initial Values is %f\n',call_1,put_1);
call=[];
put=[];
for i=1:length(S0)
    [call(i),put(i)] = American_Option(S0(i),T,K_1,r_1,sigma_1);
end
fprintf('\n Varying S0 \n');
figure;
plot(S0,call);
xlabel('S0')
ylabel('Call option price')
title('')
figure;
plot(S0,put);
xlabel('S0')
ylabel('Put option price')

fprintf('\n Varying K \n');
call=[];
put=[];
for i=1:length(K)
    [call(i),put(i)] = American_Option(S0_1,T,K(i),r_1,sigma_1);
end
figure;
plot(K,call);
xlabel('K')
ylabel('Call option price')
figure;
plot(K,put);
xlabel('K')
ylabel('Put option price')

fprintf('\n Varying r \n');
call=[];
put=[];
for i=1:length(r)
    [call(i),put(i)] = American_Option(S0_1,T,K_1,r(i),sigma_1);
end
figure;
plot(r,call);
xlabel('r')
ylabel('Call option price')
figure;
plot(r,put);
xlabel('r')
ylabel('Put option price')

fprintf('\n Varying sigma \n');
call=[];
put=[];
for i=1:length(sigma)
    [call(i),put(i)] = American_Option(S0_1,T,K_1,r_1,sigma(i));
end
figure;
plot(sigma,call);
xlabel('sigma')
ylabel('Call option price')
figure;
plot(sigma,put);
xlabel('sigma')
ylabel('Put option price')

fprintf('\n Varying M (for k=95,100,105) \n');
call=[];
put=[];
for k=95:5:105
    for i=1:length(M)
        call(i) = asian_options(S0_1,k,r_1,sigma_1,T,M(i),1);
        put(i) = asian_options(S0_1,k,r_1,sigma_1,T,M(i),-1);
    end
    figure;
    plot(M,call);
    xlabel(['M (for K = ',num2str(k),')'])
    ylabel('Call option price')
    figure;
    plot(M,put);
    xlabel(['M (for K = ',num2str(k),')'])
    ylabel('Put option price')
end
function [call,put]=American_Option(S0,T,K,r,sigma,M)    
    delta= T/M;
    u= exp(sigma*sqrt(delta) + (r-0.5*sigma*sigma)*delta);
    d= exp(-sigma*sqrt(delta) + (r-0.5*sigma*sigma)*delta);
   
    p= (exp(r*delta)-d)/(u-d);
    
    stock_price=zeros(1,M+1);
    stock_price(1,1)=S0;
    
    for i=1:M
        for j=1:i
            stock_price(i+1,j)=stock_price(i,j)*d;
            stock_price(i+1,j+1)=stock_price(i,j)*u;
        end
    end
    
    call_vals=zeros(1,M+1);
    put_vals=zeros(1,M+1);
    
    for i=1:M+1
        call_vals(M+1,i)=max(0,stock_price(M+1,i)-K);
        put_vals(M+1,i)=max(0,K-stock_price(M+1,i));
    end
    
    for i=M:-1:1
        for j=1:i
            call_vals(i,j)=max(max(0,stock_price(i,j)-K),exp(-r*delta)*(p*call_vals(i+1,j+1)+(1-p)*call_vals(i+1,j)));
            put_vals(i,j)=max(max(K-stock_price(i,j),0),exp(-r*delta)*(p*put_vals(i+1,j+1)+(1-p)*put_vals(i+1,j)));
        end
    end
    
    call=call_vals(1,1);
    put=put_vals(1,1);
end