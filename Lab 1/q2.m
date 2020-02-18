clear all;
clc;

f(1,100);
f(5,100);


function f(step_size,steps)
    i=1;
    S0 = 100;
    M = 1;
    K = 105;
    T = 5;
    r = 0.05;
    sigma = 0.3;
    while (i<steps)
        t = T/M;
        u = exp(sigma*sqrt(t) + (r - 0.5*sigma*sigma)*t);
        d = exp(-sigma*sqrt(t) + (r - 0.5*sigma*sigma)*t);
        p = (exp(r*t) -d)/(u-d);
        for j=1:M + 1
            C(j) = max(0,S0*(u^(M-j+1))*(d^(j-1)) - K);
            P(j) = max(0,K-S0*(u^(M-j+1))*(d^(j-1)));
        end
        for j=M:-1:1
            
                for k=1:j
                    C(k) = exp(-r*t)*(p*C(k) + (1-p)*C(k+1));
                end
                call(i) = C(1);
            
           
                for k=1:j
                    P(k) = exp(-r*t)*(p*P(k) + (1-p)*P(k+1));
                end
                put(i) = P(1);
            
        end
        i=i+1;
        M=M+step_size;
    end
    figure
    plot(call);
    xlabel('M')
    ylabel('Call option prices')
    figure
    plot(put)
    xlabel('M')
    ylabel('Put option prices')
    end

