clear all
clc
stock_data_table = readtable('bsedata1_w.csv');
stock_names = stock_data_table.Properties.VariableNames(:,3:end);
for i=1:20
    stock_prices = table2array(stock_data_table(1:end-52,i+2));
    s0 = table2array(stock_data_table(end-52,i+2));
    s_actual = table2array(stock_data_table(end-51:end,i+2));
    s = predict_path_w(s0,stock_prices);
    dates = table2array(stock_data_table(end-51:end,1));
    figure()
    plot(dates,s_actual,dates,s)
    xlabel('Time')
    ylabel('Stock Price')
    title("Actual Price vs Predicted Price for Stock(Weekly Prices):"+stock_names(i), 'Interpreter', 'none')
    legend('Actual Price','Predicted Price')
end
stock_prices = table2array(stock_data_table(1:end-52,2));
s0 = table2array(stock_data_table(end-52,2));
s_actual = table2array(stock_data_table(end-51:end,2));
s = predict_path_w(s0,stock_prices);
dates = table2array(stock_data_table(end-51:end,1));
figure()
plot(dates,s_actual,dates,s)
xlabel('Time')
ylabel('Index Price')
title("Actual Index Value vs Predicted Index Value for Index(Weekly Prices): SENSEX", 'Interpreter', 'none')
legend('Actual Index Value','Predicted Index Value')
 stock_data_table = readtable('nsedata1_w.csv');
 stock_prices = table2array(stock_data_table(1:end-52,2));
s0 = table2array(stock_data_table(end-52,2));
s_actual = table2array(stock_data_table(end-51:end,2));
s = predict_path_w(s0,stock_prices);
dates = table2array(stock_data_table(end-51:end,1));
figure()
plot(dates,s_actual,dates,s)
xlabel('Time')
ylabel('Index Price')
title("Actual Index Value vs Predicted Index Value for Index(Weekly Prices): NIFTY", 'Interpreter', 'none')
legend('Actual Index Value','Predicted Index Value')
% stock_names = stock_data_table.Properties.VariableNames(:,3:end);
% for i=1:20
%     stock_prices = table2array(stock_data_table(1:end-52,i+2));
%     s0 = table2array(stock_data_table(end-52,i+2));
%     s_actual = table2array(stock_data_table(end-51:end,i+2));
%     s = predict_path_w(s0,stock_prices);
%     dates = table2array(stock_data_table(end-51:end,1));
%     figure()
%     plot(dates,s_actual,dates,s)
%     xlabel('Time')
%     ylabel('Stock Price')
%     title("Actual Price vs Predicted Price for Stock(Weekly Prices):"+stock_names(i), 'Interpreter', 'none')
%     legend('Actual Price','Predicted Price')
% end

stock_data_table = readtable('bsedata1_m.csv');
stock_names = stock_data_table.Properties.VariableNames(:,3:end);
for i=1:20
    stock_prices = table2array(stock_data_table(1:end-12,i+2));
    s0 = table2array(stock_data_table(end-12,i+2));
    s_actual = table2array(stock_data_table(end-11:end,i+2));
    s = predict_path_m(s0,stock_prices);
    dates = table2array(stock_data_table(end-11:end,1));
    figure()
    plot(dates,s_actual,dates,s)
    xlabel('Time')
    ylabel('Stock Price')
    title("Actual Price vs Predicted Price for Stock(Monthly Prices):"+stock_names(i), 'Interpreter', 'none')
    legend('Actual Price','Predicted Price')
end
stock_prices = table2array(stock_data_table(1:end-12,2));
s0 = table2array(stock_data_table(end-12,2));
s_actual = table2array(stock_data_table(end-11:end,2));
s = predict_path_m(s0,stock_prices);
dates = table2array(stock_data_table(end-11:end,1));
figure()
plot(dates,s_actual,dates,s)
xlabel('Time')
ylabel('Index Price')
title("Actual Index Value vs Predicted Index Value for Index(Monthly Prices): SENSEX", 'Interpreter', 'none')
legend('Actual Index Value','Predicted Index Value')

stock_data_table = readtable('nsedata1_m.csv');
stock_prices = table2array(stock_data_table(1:end-12,2));
s0 = table2array(stock_data_table(end-12,2));
s_actual = table2array(stock_data_table(end-11:end,2));
s = predict_path_m(s0,stock_prices);
dates = table2array(stock_data_table(end-11:end,1));
figure()
plot(dates,s_actual,dates,s)
xlabel('Time')
ylabel('Index Price')
title("Actual Index Value vs Predicted Index Value for Index(Monthly Prices): NIFTY", 'Interpreter', 'none')
legend('Actual Index Value','Predicted Index Value')
% stock_names = stock_data_table.Properties.VariableNames(:,3:end);
% for i=1:20
%     stock_prices = table2array(stock_data_table(1:end-12,i+2));
%     s0 = table2array(stock_data_table(end-12,i+2));
%     s_actual = table2array(stock_data_table(end-11:end,i+2));
%     s = predict_path_m(s0,stock_prices);
%     dates = table2array(stock_data_table(end-11:end,1));
%     figure()
%     plot(dates,s_actual,dates,s)
%     xlabel('Time')
%     ylabel('Stock Price')
%     title("Actual Price vs Predicted Price for Stock(Monthly Prices):"+stock_names(i), 'Interpreter', 'none')
%     legend('Actual Price','Predicted Price')
% end

function s=predict_path_w(s0,stock_prices)
    log_returns_daily = log((stock_prices(2:end)./stock_prices(1:end-1)));
    mu = mean(log_returns_daily);
    sigma = sqrt(var(log_returns_daily));
    t=1/52:1/52:1;
    s=[];
    for i=1:52
        temp=exp(sigma*normrnd(0,t(i)) + (mu-((sigma^2)/2))*t(i));
        s=[s s0*temp];
    end
end
function s=predict_path_m(s0,stock_prices)
    log_returns_daily = log((stock_prices(2:end)./stock_prices(1:end-1)));
    mu = mean(log_returns_daily);
    sigma = sqrt(var(log_returns_daily));
    t=1/12:1/12:1;
    s=[];
    for i=1:12
        temp=exp(sigma*normrnd(0,t(i)) + (mu-((sigma^2)/2))*t(i));
        s=[s s0*temp];
    end
end