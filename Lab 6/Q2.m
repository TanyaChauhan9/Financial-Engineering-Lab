clear all
clc
stock_data_table = readtable('nsedata1.csv');
stock_data_table_w = readtable('nsedata1_w.csv');
stock_data_table_m = readtable('nsedata1_m.csv');
stock_names = stock_data_table.Properties.VariableNames(:,3:end);
compute_returns(table2array(stock_data_table(:,2)),table2array(stock_data_table_w(:,2)),table2array(stock_data_table_m(:,2)),'NIFTY');
for i=1:20
  compute_returns(table2array(stock_data_table(:,i+2)),table2array(stock_data_table_w(:,i+2)),table2array(stock_data_table_m(:,i+2)),stock_names(i));  
end
stock_data_table = readtable('bsedata1.csv');
stock_data_table_w = readtable('bsedata1_w.csv');
stock_data_table_m = readtable('bsedata1_m.csv');
stock_names = stock_data_table.Properties.VariableNames(:,3:end);
compute_returns(table2array(stock_data_table(:,2)),table2array(stock_data_table_w(:,2)),table2array(stock_data_table_m(:,2)),'SENSEX');
for i=1:20
  %compute_returns(table2array(stock_data_table(:,i+2)),table2array(stock_data_table_w(:,i+2)),table2array(stock_data_table_m(:,i+2)),stock_names(i));
end
function compute_returns(stock_prices_d,stock_prices_w,stock_prices_m,stock_name)
    returns_daily = (stock_prices_d(2:end)-stock_prices_d(1:end-1))./stock_prices_d(1:end-1);
    returns_weekly=(stock_prices_w(2:end)-stock_prices_w(1:end-1))./stock_prices_w(1:end-1);
    returns_monthly=(stock_prices_m(2:end)-stock_prices_m(1:end-1))./stock_prices_m(1:end-1);
   
    returns_daily_n=(returns_daily - mean(returns_daily))./std(returns_daily);
    returns_weekly_n=(returns_weekly - mean(returns_weekly))./std(returns_weekly);
    returns_monthly_n=(returns_monthly - mean(returns_monthly))./std(returns_monthly);
    figure()
    subplot(1,3,1)
    histfit(returns_daily_n);
    xlabel('For Daily Returns')
    subplot(1,3,2)
    histfit(returns_weekly_n);
    xlabel('For Weekly Returns')
    title("Histogram for Normalized Returns for stock: "+stock_name, 'Interpreter', 'none')
    subplot(1,3,3)
    histfit(returns_monthly_n);
    xlabel('For Monthly Returns')
end