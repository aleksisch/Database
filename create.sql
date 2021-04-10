drop schema stocks cascade ;

create schema if not exists stocks;

create table  stocks.country
(
    id          SERIAL,
    iso         text unique primary key NOT NULL,
    name        text,
    GDP_USD     bigint,
    population  int
);

create table stocks.industry
(
    id        SERIAL,
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
    stock_market text,
    country text,
    name text,
    FOREIGN KEY (stock_market) references stocks.stock_market(MIC),
    FOREIGN KEY (country) REFERENCES stocks.country(iso)
);

create table stocks.credit_rating
(
    id text,
    agency_name text,
    ticker text,
    primary key (id, agency_name),
    FOREIGN KEY (ticker) REFERENCES stocks.instruments(ticker),
    score text
);

create table stocks.stock
(
    ticker            text unique primary key NOT NULL,
    market_cap int,
    FOREIGN KEY (ticker) REFERENCES stocks.instruments(ticker)
);

create table stocks.instrument_industry
(
    ticker text,
    industry_id int,
    primary key (ticker, industry_id),
    foreign key (ticker) REFERENCES stocks.instruments(ticker),
    foreign key (industry_id) REFERENCES stocks.industry(id)
);

create table stocks.bond
(
    ticker              text unique primary key NOT NULL ,
    issuer              text,
    FOREIGN KEY (issuer) REFERENCES stocks.stock(ticker),
    FOREIGN KEY (ticker) references stocks.instruments(ticker)
);

create table stocks.etf
(
    ticker              text unique primary key NOT NULL,
    market_cap          bigint,
    FOREIGN KEY (ticker) references stocks.instruments(ticker)
);

create table stocks.etf_stock
(
    stock_ticker text,
    etf_ticker text,
    primary key (stock_ticker, etf_ticker),
    foreign key (stock_ticker) REFERENCES stocks.stock (ticker),
    foreign key (etf_ticker) REFERENCES stocks.etf (FIGI)
);



create table stocks.price_history
(
    ticker text,
    currency text,
    date_begin timestamp,
    date_end timestamp,
    open_price float,
    close_price float,
    min_price float,
    max_price float,
    FOREIGN KEY (ticker) REFERENCES stocks.instruments(ticker),
    PRIMARY KEY (ticker, date_begin, date_end)
);

commit;
