clear all
clc
clf

m = [0.1 0.2 0.15];
c = [0.005,-0.010,0.004;
  -0.010,0.040,-0.002;
   0.004,-0.002,0.023];
u = ones(1,length(m));
u_1 = ones(1,2);
m_1 = [0.2 0.15];
c_1 = [0.040 -0.002; -0.002 0.023];
m_2 = [0.1 0.15];
c_2 = [0.005 0.004; 0.004 0.023];
m_3 = [0.1 0.2];
c_3 = [0.005 -0.010; -0.010 0.040];

mu_v = 0.0001:0.0001:0.3;
[w,sd] = MVL(m,c,mu_v);
figure(1)
for i = 1:100000
    r = rand(1,3);
    weight_sample = r/sum(r);
    return_sample(i) = weight_sample*transpose(m);
    sigma_sample(i) = sqrt(weight_sample*c*transpose(weight_sample));
end
hold on
plot(sd,mu_v,'lineWidth',3);
xlabel('Risk (\sigma)')
ylabel('Return (\mu)')
scatter(sigma_sample, return_sample, 10,'filled');
[w_1,sd_1] = MVL(m_1,c_1,mu_v);
plot(sd_1,mu_v);
[w_2,sd_2] = MVL(m_2,c_2,mu_v);
plot(sd_2,mu_v);
[w_3,sd_3] = MVL(m_3,c_3,mu_v);
plot(sd_3,mu_v);
legend('All three assets','Feasible region for no short selling','Only asset 2 and 3', 'Only asset 1 and 3', 'Only asset 1 and 2');
hold off
figure(2);
f = @(x) (1-x);
x = [0:0.01:1];
plot(x, f(x),'LineWidth', 2);
hold on;
x = 0:0.01:1;
y = zeros(size(x));
plot(x,y,'r','LineWidth', 2);
hold on;
y = 0:0.01:1;
x = zeros(size(y));
plot(x,y,'k','LineWidth', 2);
hold on;
plot(w(:,1),w(:,2),'m','LineWidth', 2);
xlim([-0.5 1.5]);
ylim([-0.5 1.5]);
xlabel('Weight of first asset')
ylabel('Weight of second asset')

syms mu
u = ones(1,length(m));
ucinv = u/c;
mcinv = m/c;
w1 = det([1,ucinv*transpose(m);mu,mcinv*transpose(m)])*ucinv;
w2 = det([ucinv*transpose(u),1;mcinv*transpose(u),mu])*mcinv;
w3 = det([ucinv*transpose(u),ucinv*transpose(m);mcinv*transpose(u),mcinv*transpose(m)]);
w_i = (w1 +w2)/w3;
fprintf('Equations for the weights are \n');
disp(vpa(w_i,4))
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

