update stocks.country set name = null where name = 'US';
update stocks.industry set name = null where name = 'Technology';

delete from stocks.country where true;

update stocks.price_history set min_price = -1 where true;
update stocks.stock set market_cap = -1 where true;
update stocks.price_history set min_price = 10, max_price = 1 where true;

insert into stocks.stock (ticker, market_cap) VALUES ('not_exist', 1);
insert into stocks.instruments (ticker, stock_market, country, name) VALUES ('test_new', null, 'US', 'new');
insert into stocks.instruments (ticker, stock_market, country, name) VALUES ('test_new', 'NYSE', null, 'new');

insert into stocks.industry (name) VALUES (null);
insert into stocks.bond(ticker, issuer, yield) VALUES ('asd', 'asd', 1);
insert into stocks.etf_stock(stock_ticker, etf_ticker) VALUES (null, null);
