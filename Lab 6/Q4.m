clear all
clc
stock_data_table = readtable('bsedata1.csv');
stock_names = stock_data_table.Properties.VariableNames(:,3:end);
for i=1:20
    stock_prices = table2array(stock_data_table(1:end-246,i+2));
    s0 = table2array(stock_data_table(end-246,i+2));
    s_actual = table2array(stock_data_table(end-245:end,i+2));
    s = predict_path(s0,stock_prices);
    dates = table2array(stock_data_table(end-245:end,1));
    figure()
    plot(dates,s_actual,dates,s)
    xlabel('Time')
    ylabel('Stock Price')
    title("Actual Price vs Predicted Price for Stock(Daily Prices):"+stock_names(i), 'Interpreter', 'none')
    legend('Actual Price','Predicted Price')
end
stock_prices = table2array(stock_data_table(1:end-246,2));
s0 = table2array(stock_data_table(end-246,2));
s_actual = table2array(stock_data_table(end-245:end,2));
s = predict_path(s0,stock_prices);
dates = table2array(stock_data_table(end-245:end,1));
figure()
plot(dates,s_actual,dates,s)
xlabel('Time')
ylabel('Index Price')
title("Actual Index Value vs Predicted Index Value for Index(Daily Prices): SENSEX", 'Interpreter', 'none')
legend('Actual Index Value','Predicted Index Value')
 stock_data_table = readtable('nsedata1.csv');
stock_prices = table2array(stock_data_table(1:end-246,2));
s0 = table2array(stock_data_table(end-246,2));
s_actual = table2array(stock_data_table(end-245:end,2));
s = predict_path(s0,stock_prices);
dates = table2array(stock_data_table(end-245:end,1));
figure()
plot(dates,s_actual,dates,s)
xlabel('Time')
ylabel('Index Price')
title("Actual Index Value vs Predicted Index Value for Index(Daily Prices): NIFTY", 'Interpreter', 'none')
legend('Actual Index Value','Predicted Index Value')
% stock_names = stock_data_table.Properties.VariableNames(:,3:end);
% for i=1:20
%     stock_prices = table2array(stock_data_table(1:end-246,i+2));
%     s0 = table2array(stock_data_table(end-246,i+2));
%     s_actual = table2array(stock_data_table(end-245:end,i+2));
%     s = predict_path(s0,stock_prices);
%     dates = table2array(stock_data_table(end-245:end,1));
%     figure()
%     plot(dates,s_actual,dates,s)
%     xlabel('Time')
%     ylabel('Stock Price')
%     title("Actual Price vs Predicted Price for Stock(Daily Prices):"+stock_names(i), 'Interpreter', 'none')
%     legend('Actual Price','Predicted Price')
% end

function s=predict_path(s0,stock_prices)
    log_returns_daily = log((stock_prices(2:end)./stock_prices(1:end-1)));
    mu = mean(log_returns_daily);
    sigma = sqrt(var(log_returns_daily));
    t=1/246:1/246:1;
    s=[];
    for i=1:246
        temp=exp(sigma*normrnd(0,t(i)) + (mu-((sigma^2)/2))*t(i));
        s=[s s0*temp];
    end
end