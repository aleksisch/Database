-- Get country with capitalization between min and max
create or replace function constraint_market_cap(max bigint, min bigint)
returns table(ticker text, market_cap bigint, country text) AS
$$
    begin
         return query
            select a.ticker, b.market_cap, a.country from stocks.instruments as a
            inner join stocks.stock as b
            using(ticker)
            where b.market_cap BETWEEN min and max;
    end;
$$ language plpgsql;

select * from constraint_market_cap(1000000, 100);

-- Get average yield by bond ticker
create or replace function get_yield_by_ticker(ticker_stock text) returns double precision as
$$
    declare
        x double precision;
    begin
        select avg(bond.yield) into x from stocks.bond as bond
        where issuer = ticker_stock;
        return x;
    end;
$$ language plpgsql;

select * from get_yield_by_ticker('GOOG');