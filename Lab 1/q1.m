clear all;
clc;

S0 = 100;
M = [1,5,10,20,50,100,200,400];
K = 105;
T = 5;
r = 0.05;
sigma = 0.3;

for i=1:length(M)
    t = T/M(i);
    u = exp(sigma*sqrt(t) + (r - 0.5*sigma*sigma)*t);
    d = exp(-sigma*sqrt(t) + (r - 0.5*sigma*sigma)*t); 
    p = (exp(r*t) -d)/(u-d);
    x = check_arbitrage(r,t,u,d);
%     if x==0
%         fprintf('\n%d: No Arbitrage \n',M(i));
%     else
%         fprintf('\n%d: Arbitrage\n',M(i))
%     end
    for j=1:M(i) + 1
        C(j) = max(0,S0*(u^(M(i)-j+1))*(d^(j-1)) - K);
        P(j) = max(0,K-S0*(u^(M(i)-j+1))*(d^(j-1)));
    end
    for j=M(i):-1:1
        for k=1:j
            C(k) = exp(-r*t)*(p*C(k) + (1-p)*C(k+1));
        end
        for k=1:j
            P(k) = exp(-r*t)*(p*P(k) + (1-p)*P(k+1));
        end
    end
    call(i) = C(1);
    put(i) = P(1);
end

fprintf('M \t\t  Call Option Price\n');
for i=1:8
    fprintf('%d \t\t  %f\n',M(i),call(i));
end
fprintf('\nM \t\t  Put Option Price\n');
for i=1:8
    fprintf('%d \t\t  %f\n',M(i),put(i));
end

function x = check_arbitrage(r,t,u,d)
    x = 0;
    if (d>exp(r*t)) || (u<exp(r*t)) 
        x=1;
    end
end