clear all;
clc;

S0 = 50:5:150;
S0_1 = 100;
M = 50:1:150;
M_1 =100;
K = 50:1:150;
K_1 = 100;
T = 1;
r = 0.01:0.01:0.16;
r_1 = 0.08;
sigma = 0.05:0.01:0.4;
sigma_1 = 0.2;

%part A
fprintf('\n SET A \n');
[call_1,put_1] = call_option(S0_1,M_1,T,r_1,sigma_1,K_1,'A');
fprintf('\nThe call price for the given Values is %f\nThe put price for the given Values is %f\n',call_1,put_1);
call=[];
put=[];
for i=1:length(S0)
    [call(i),put(i)] = call_option(S0(i),M_1,T,r_1,sigma_1,K_1,'A');
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
    [call(i),put(i)] = call_option(S0_1,M_1,T,r_1,sigma_1,K(i),'A');
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
    [call(i),put(i)] = call_option(S0_1,M_1,T,r(i),sigma_1,K_1,'A');
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
    [call(i),put(i)] = call_option(S0_1,M_1,T,r_1,sigma(i),K_1,'A');
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
        [call(i),put(i)] = call_option(S0_1,M(i),T,r_1,sigma_1,k,'A');
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


%part B
fprintf('\n SET B \n');
[call_2,put_2] = call_option(S0_1,M_1,T,r_1,sigma_1,K_1,'B');
fprintf('\nThe call price for the given Values is %f\nThe put price for the given Values is %f\n',call_2,put_2);
fprintf('\n Varying S0 \n');
call=[];
put=[];
for i=1:length(S0)
    [call(i),put(i)] = call_option(S0(i),M_1,T,r_1,sigma_1,K_1,'B');
end
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
    [call(i),put(i)] = call_option(S0_1,M_1,T,r_1,sigma_1,K(i),'B');
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
    [call(i),put(i)] = call_option(S0_1,M_1,T,r(i),sigma_1,K_1,'B');
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
    [call(i),put(i)] = call_option(S0_1,M_1,T,r_1,sigma(i),K_1,'B');
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
        [call(i),put(i)] = call_option(S0_1,M(i),T,r_1,sigma_1,k,'B');
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



function [call,put]=call_option(S0,M,T,r,sigma,K,part)
    t = T/M;
    if (part=='A')
        u = exp(sigma*sqrt(t));
        d = exp(-sigma*sqrt(t));
    elseif (part=='B')
        u = exp(sigma*sqrt(t) + (r - 0.5*sigma*sigma)*t);
        d = exp(-sigma*sqrt(t) + (r - 0.5*sigma*sigma)*t);
    end
    p = (exp(r*t) -d)/(u-d);
    C=zeros(M+1);
    P=zeros(M+1);
    for j=1:M+1
        C(j) = max(0,S0*(u^(M-j+1))*(d^(j-1)) - K);
        P(j) = max(0,K-S0*(u^(M-j+1))*(d^(j-1)));
    end
    for j=M:-1:1
        for k=1:j
            C(k) = exp(-r*t)*(p*C(k) + (1-p)*C(k+1));
        end
        for k=1:j
            P(k) = exp(-r*t)*(p*P(k) + (1-p)*P(k+1));
        end
    end
    call = C(1);
    put = P(1);
end
