clear all;
clc;

S0 = 100;
K = 100;
T = 1;
r = 0.08;
sigma = 0.2;

calculate_price_varying_M([25 10 5], S0, K, T, r, sigma)
calculate_price(5, S0, K, T, r, sigma);

function [] = calculate_price(M , S0, K, T, r, sigma)
    del_t = T/M;
    u = exp(sigma*sqrt(del_t) + (r - ((sigma)^2)/2)*del_t);
    d = exp(-sigma*sqrt(del_t) + (r - ((sigma)^2)/2)*del_t);
    risk_nt_p = (exp(r*del_t) - d)/(u - d);
    a(1) = S0;
    for i = 2:(2^(M+1) - 1)
        if mod(i,2) == 0
            a(i) = a(i/2)*d;
        else
            a(i) = a((i-1)/2)*u;
        end
    end
    for i = (2^M):(2^(M+1) - 1)
        b = i;
        mx = a(i);
        while floor(b/2) > 0
           b = floor(b/2);
           mx = max(mx,a(b));
        end
        a(i) = mx - a(i);
    end
    if ~(d <= exp(r*(del_t)) && exp(r*(del_t)) <= u)
            fprintf('Arbitrage!\n')
    else
         for i = 1:M
             fprintf('\nFor time step = %d, the values of the option are:\n', M+1-i);
             disp(a(2^(M+1-i):2^(M+2-i)-1)')
             for j = 2^(M-i):(2^(M+1-i)-1)
                 a(j) = exp(-r*del_t)*((1-risk_nt_p)*a(2*j) + (risk_nt_p)*a(2*j+1));
             end
         end
         fprintf('\nFor time step = 0, the value of the option is: %f\n', a(1));
    end
end

function [] = calculate_price_varying_M(M_values, S0, K, T, r, sigma)
    for M = M_values
       tic
       del_t = T/M;
       u = exp(sigma*sqrt(del_t) + (r - ((sigma)^2)/2)*del_t);
       d = exp(-sigma*sqrt(del_t) + (r - ((sigma)^2)/2)*del_t);
       risk_nt_p = (exp(r*del_t) - d)/(u - d);
       a(1) = S0;
       for i = 2:(2^(M+1) - 1)
           if mod(i,2) == 0
               a(i) = a(i/2)*d;
           else
               a(i) = a((i-1)/2)*u;
           end
       end
       a = a;
       for i = (2^M):(2^(M+1) - 1)
           b = i;
           mx = a(i);
           while floor(b/2) > 0
              b = floor(b/2);
              mx = max(mx, a(b));
           end
           a(i) = mx - a(i);
       end
       if ~(d <= exp(r*(del_t)) && exp(r*(del_t)) <= u)
               fprintf('Arbitrage!\n')
       else
          for i = 1:M
              for j = 2^(M-i):(2^(M+1-i)-1)
                  a(j) = exp(-r*del_t)*(risk_nt_p*a(2*j + 1) + (1 - risk_nt_p)*a(2*j));
              end
          end
          option_price = a(1);
          fprintf('Initial price for M = %d is %f.\n', M, option_price);
       end
       toc
    end
end