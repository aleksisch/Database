set search_path = 'stocks';

-- Join to stock information market and industry
create or replace view stock_info_view (ticker, market_cap, industry, country, stock_market)
as (
    select
        ticker,
        market_cap,
        industry_name,
        country,
        stock_market
    from stock as stock
    join (
        select
            ticker,
            name as industry_name,
            country,
            stock_market
        from stocks.instruments
        inner join instrument_industry
        using(ticker)
    ) as instrument
    using(ticker)
);

create or replace view country_without_id (name, gdp_usd, population)
as select name, gdp_usd, population from country;

-- Join to stock number of days with prices in database
create or replace view instrument_prices_info (ticker, number_of_day_price)
as select instrument.ticker as ticker, count(price.date_begin) as days_with_prices from instruments as instrument
left join price_history as price
using(ticker)
group by instrument.ticker;


create or replace view hide_credit_rating(agency_name, ticker, score)
as select agency_name, overlay(score placing '**' from 2 for 4) as score, ticker from credit_rating;


-- Join bonds with issuer capitalization
create or replace view stock_with_bonds(bond_ticker, yield, issuer, market_cap)
as
    select
           bond.ticker as bond_ticker,
           bond.yield as yield,
           s.market_cap as market_cap,
           bond.issuer as issuer
    from bond as bond
    inner join stock s on bond.issuer = s.ticker;


create or replace view top_industries(stock_num, name)
as
    select
        count(*) as stock_num,
        i.name as name
    from instrument_industry as ind
    inner join industry i on ind.industry_id = i.id
    group by name
    order by stock_num desc;


select * from top_industries;
select * from stock_with_bonds limit 100;
select * from stock_info_view limit 100;
select * from instrument_prices_info limit 200;
select * from country_without_id limit 100;
select * from hide_credit_rating limit 100;