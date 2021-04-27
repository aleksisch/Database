drop schema stocks cascade ;

create schema if not exists stocks;

create table  stocks.country
(
    id          SERIAL not null,
    iso         text unique primary key NOT NULL,
    name        text not null,
    GDP_USD     bigint,
    population  int,
    check(coalesce(GDP_USD, 0) >= 0),
    check(coalesce(population, 0) >= 0)
);

create table stocks.industry
(
    id        SERIAL primary key,
    name      text
);

create table stocks.stock_market
(
    MIC             text unique primary key NOT NULL,
    name            text,
    country_code    text,
    foreign key (country_code) references stocks.country (iso)
);

create table stocks.instruments
(
    ticker text unique primary key,
    stock_market text not null,
    country text not null,
    name text not null,
    FOREIGN KEY (stock_market) references stocks.stock_market(MIC),
    FOREIGN KEY (country) REFERENCES stocks.country(iso)
);

create table stocks.credit_rating
(
    id serial not null,
    agency_name text,
    ticker text,
    primary key (id, agency_name),
    FOREIGN KEY (ticker) REFERENCES stocks.instruments(ticker),
    score text
);

create table stocks.stock
(
    ticker     text unique primary key NOT NULL,
    market_cap bigint,
    check(market_cap >= 0 or market_cap is null),
    FOREIGN KEY (ticker) REFERENCES stocks.instruments(ticker)
);

create table stocks.instrument_industry
(
    ticker text,
    industry_id int not null,
    primary key (ticker, industry_id),
    foreign key (ticker) REFERENCES stocks.instruments(ticker),
    foreign key (industry_id) REFERENCES stocks.industry(id)
);

create table stocks.bond
(
    ticker              text unique primary key NOT NULL ,
    issuer              text,
    yield               int not null,
    check ( yield > 0),
    FOREIGN KEY (issuer) REFERENCES stocks.stock(ticker),
    FOREIGN KEY (ticker) references stocks.instruments(ticker)
);

create table stocks.etf
(
    ticker              text unique primary key NOT NULL,
    market_cap          bigint,
    check ( coalesce(market_cap, 0) >= 0),
    FOREIGN KEY (ticker) references stocks.instruments(ticker)
);

create table stocks.etf_stock
(
    stock_ticker text not null,
    etf_ticker text not null,
    primary key (stock_ticker, etf_ticker),
    foreign key (stock_ticker) REFERENCES stocks.stock (ticker),
    foreign key (etf_ticker) REFERENCES stocks.etf (ticker)
);



create table stocks.price_history
(
    ticker text not null,
    currency text not null,
    date_begin timestamp,
    date_end timestamp,
    open_price float,
    close_price float,
    min_price float,
    max_price float,
    check (coalesce(min_price, 0) >= 0 ),
    check (coalesce(max_price, 0) >= 0 ),
    check (coalesce(close_price, 0) >= 0 ),
    check (coalesce(open_price, 0) >= 0 ),
    check (coalesce(max_price, 0) - coalesce(min_price, 0) >= 0),
    FOREIGN KEY (ticker) REFERENCES stocks.instruments(ticker),
    PRIMARY KEY (ticker, date_begin, date_end)
);

commit;
