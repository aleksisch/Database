create index new_prices on stocks.price_history (date_begin) where date_begin > '2015-10-10';
create index bond_issuer on stocks.bond (issuer);
create index top_gdp_country on stocks.country(gdp_usd) where gdp_usd > 1000000000;
create index undistry_name on stocks.industry(name);
create index market_country on stocks.stock_market(country_code);
create index instruments_by_market on stocks.instruments(stock_market);
create index agency_name on stocks.credit_rating(agency_name);
commit ;