clear all
clc
stock_data_table = readtable('nsedata1.csv');
stock_data_table_w = readtable('nsedata1_w.csv');
stock_data_table_m = readtable('nsedata1_m.csv');
stock_names = stock_data_table.Properties.VariableNames(:,3:end);
plots(table2array(stock_data_table(:,1)),table2array(stock_data_table_w(:,1)),table2array(stock_data_table_m(:,1)),table2array(stock_data_table(:,2)),table2array(stock_data_table_w(:,2)),table2array(stock_data_table_m(:,2)),'NIFTY 50');
for i=1:20
    plots(table2array(stock_data_table(:,1)),table2array(stock_data_table_w(:,1)),table2array(stock_data_table_m(:,1)),table2array(stock_data_table(:,i+2)),table2array(stock_data_table_w(:,i+2)),table2array(stock_data_table_m(:,i+2)),stock_names(i));
end

stock_data_table = readtable('bsedata1.csv');
stock_data_table_w = readtable('bsedata1_w.csv');
stock_data_table_m = readtable('bsedata1_m.csv');
stock_names = stock_data_table.Properties.VariableNames(:,3:end);
plots(table2array(stock_data_table(:,1)),table2array(stock_data_table_w(:,1)),table2array(stock_data_table_m(:,1)),table2array(stock_data_table(:,2)),table2array(stock_data_table_w(:,2)),table2array(stock_data_table_m(:,2)),'SENSEX');
for i=1:20
    %plots(table2array(stock_data_table(:,1)),table2array(stock_data_table_w(:,1)),table2array(stock_data_table_m(:,1)),table2array(stock_data_table(:,i+2)),table2array(stock_data_table_w(:,i+2)),table2array(stock_data_table_m(:,i+2)),stock_names(i));
end
function plots(date_array,date_w,date_m,stock_price_d,stock_price_w,stock_price_m,stock_name)
    figure()
    subplot(1,3,1)
    %daily
    plot(date_array,stock_price_d);
    xlabel('Date')
    ylabel('Stock Price')
    title("Daily ("+(stock_name)+")", 'Interpreter', 'none')
    %Weekly
    subplot(1,3,2)
    plot(date_w,stock_price_w);
    xlabel('Date')
    ylabel('Stock Price')
    title("Weekly ("+(stock_name)+")", 'Interpreter', 'none')
    %Monthly
    subplot(1,3,3)
    plot(date_m,stock_price_m);
    xlabel('Date')
    ylabel('Stock Price')
    title("Monthly ("+(stock_name)+")", 'Interpreter', 'none')
end