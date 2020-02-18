clear all;
clc;

M=20;
S0=100;
T=5;
K=105;
r=0.05;
sigma=0.3;

european_option(S0,T,K,r,sigma,M,1);

function [call_p,put_p]=european_option(S0,T,K,r,sigma,M,print)    
    delta= T/M;
    u= exp(sigma*sqrt(delta) + (r-0.5*sigma*sigma)*delta);
    d= exp(-sigma*sqrt(delta) + (r-0.5*sigma*sigma)*delta);
    p= (exp(r*delta)-d)/(u-d);
    
    %checking arbutrage possibility
    if d<exp(r*delta) && exp(r*delta)<u
       %disp('There is no arbitrage possible. Proceeding to calculate option prices');
    else
        disp('There is an arbitrage opportunity possible. The program will terminate');
        return;
    end
    
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
            call_vals(i,j)=exp(-r*delta)*(p*call_vals(i+1,j+1)+(1-p)*call_vals(i+1,j));
            put_vals(i,j)=exp(-r*delta)*(p*put_vals(i+1,j+1)+(1-p)*put_vals(i+1,j));
        end
    end
    
    call_p=call_vals(1,1);
    put_p=put_vals(1,1);
    
    %part c
    if(M==20 && print==1)
        t=[0 0.5 1 1.5 3 4.5]; 

        for i=1:6
            fprintf('At t=%f call values are \n', t(i));
            disp(call_vals(t(i)/delta + 1,1:t(i)/delta + 1));
            fprintf('At t=%f put values are \n', t(i));
            disp(put_vals(t(i)/delta + 1,1:t(i)/delta + 1));
            fprintf('\n');
        end
        
    end
end
