-- выбираем страны, по которым есть больше 1000 компании в таблице
select
       country, count(*) as stock_num
from stocks.instruments
group by country
having count(*) > 1000;


-- Выбираем дни, в которые изменение цены по всем акциям в таблице составляет больше 2 процентов
select
       avg((close_price - open_price) / open_price) as delta,
       date_begin
from stocks.price_history
where open_price is not null and close_price is not null and date_begin = date_end
group by date_begin
having avg((close_price - open_price) / open_price) > 0.02
order by delta desc;


-- Выбираем компании с рейтингом не хуже A, после чего упорядочиваем их по рейтингу.
with stock_rating as (
    select
        ticker,
        score,
        agency_name
    from stocks.instruments as stock
        join stocks.credit_rating as rating
    using (ticker)
    where score like 'A%'
    group by ticker, score, agency_name
)
select
       *,
       rank() over (order by score DESC ) as max_delt
from stocks.stock as stock
    inner join stock_rating as scores
    using (ticker)
where market_cap is not null;


-- добавляем к каждой компании капитализацию ее индустрии
with instrument_industry as (
    select
        ticker,
        industry_id,
        name as industry_name
    from stocks.instrument_industry as a
    join stocks.industry b
    on b.id = a.industry_id
)
select
    ticker,
    market_cap,
    industry_name,
    sum(market_cap) over (partition by industry_id) as industry_capitalization
from instrument_industry
inner join stocks.stock
using(ticker);

-- считаем статистику по ввп в странах соседях по населению
select
    name,
    population,
    gdp_usd,
    avg(gdp_usd) over(order by population rows between 5 preceding and 5 following) as avg_neighbour_gdp,
    max(gdp_usd) over(order by population rows between 5 preceding and 5 following) as max_neighbour_gdp,
    min(gdp_usd) over(order by population rows between 5 preceding and 5 following) as min_neighbour_gdp
from stocks.country;

