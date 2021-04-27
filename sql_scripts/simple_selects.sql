select name, ticker from stocks.instruments where stock_market = 'XNYS';

select count(*) from stocks.etf_stock where etf_ticker = 'SPY';

select country, count(*) from stocks.instruments group by country;

select * from stocks.price_history where date_begin > '2013-03-03' and date_end < '2013-03-05';

select count(*) as number_market, country_code from stocks.stock_market group by country_code order by number_market desc;

select GDP_USD, name from stocks.country order by gdp_usd DESC;

select
       (close_price - open_price) / open_price as delta,
       ticker,
       date_begin
from stocks.price_history
where open_price is not null and close_price is not null
order by delta desc;

select count(*) as stock_num, industry_id from stocks.instrument_industry group by industry_id order by stock_num desc;

select distinct a.agency_name, a.ticker, b.market_cap FROM stocks.credit_rating as a inner join stocks.stock as b
using (ticker)
where score = 'CCC'
order by b.market_cap DESC;

select * from stocks.bond