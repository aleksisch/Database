import pandas as pd
from sql_help import Insert


def read_data(path_to_file):
    return pd.read_csv(path_to_file)


all_industry = []


def get_industry_index(industry):
    if industry not in all_industry:
        ind_index = len(all_industry)
        all_industry.append(industry)
    else:
        ind_index = all_industry.index(industry)
    return ind_index + 1


def generate_markets(path_to_file):
    df = read_data(path_to_file)
    with open("insert/markets.sql", "w") as f:
        for index, row in df.iterrows():
            MIC = row["MIC"]
            name = row["NAME-INSTITUTION DESCRIPTION"]
            country = row["ISO COUNTRY CODE (ISO 3166)"]
            print(Insert.get_market_insert(MIC, name, country), file=f)
        print("commit;", file=f)


def generate_countries_insert(path_to_file):
    df = read_data(path_to_file)
    with open("insert/countries.sql", "w") as f:
        for index, row in df.iterrows():
            iso = row["ISO-3166Code"]
            name = row["Country"]
            gdp = float(row["GDPp.c.(USD)"][1:].replace('.', ''))
            population = row["Population"]
            print(Insert.get_country_insert(name, gdp, population, iso), file=f)
        print("commit;", file=f)


def generate_us_insert(path_to_file, exchange):
    df = read_data(path_to_file)
    with open("insert/stock.sql", "a+") as s, open("insert/instruments.sql", "a+") as ins:
        for index, row in df.iterrows():
            ticker = row["Symbol"]
            name = row["Name"]
            market_cap = row["MarketCap"]
            if type(market_cap) is str:
                n = float(market_cap[1:-1])
                if market_cap[-1] == "M":
                    n *= 1000000
                else:
                    n *= 1000000000
                market_cap = n
            industry = row["Sector"]
            print(Insert.get_instrument_insert(ticker, exchange, "US", name), file=ins)
            print(Insert.get_us_insert(ticker, market_cap), file=s)
            print(Insert.get_instrument_industry_insert(ticker, get_industry_index(industry)), file=ins)
        print("commit;", file=ins)
        print("commit;", file=s)


def generate_etf_insert(path_to_file, etf_name, etf_ticker, country, market):
    df = read_data(path_to_file)
    with open("insert/etfs.sql", "a+") as etf:
        print(Insert.get_instrument_insert(etf_ticker, market, country, etf_name), file=etf)
        print(Insert.get_etf_insert(etf_ticker), file=etf)
        for index, row in df.iterrows():
            ticker = row["Symbol"]
            industry = row["Sector"]
            print(Insert.get_etf_stock_insert(etf_ticker, ticker), file=etf)
            print(Insert.get_instrument_industry_insert(etf_ticker, get_industry_index(industry)), file=etf)
        print("commit;", file=etf)


def generate_industry_insert():
    with open("insert/industry.sql", "w") as industry:
        for ind in all_industry:
            print(Insert.get_industry_insert(ind), file=industry)
        print("commit;", file=industry)


def generate_price_insert(path_to_file):
    df = read_data(path_to_file)
    with open("insert/prices.sql", "w") as prices:
        for index, row in df.iterrows():
            ticker = row["Name"]
            date_begin = row["date"]
            date_end = row["date"]
            open_ = row["open"]
            close = row["close"]
            high = row["high"]
            low = row["low"]
            print(Insert.get_prices_insert('USD', ticker, date_begin, date_end, low, high, open_, close), file=prices)
        print("commit;", file=prices)


def generate_rating_insert(path_to_file):
    df = read_data(path_to_file)
    with open("insert/corporate_index.sql", "w") as prices:
        for index, row in df.iterrows():
            ticker = row["Symbol"]
            rating = row["Rating"]
            agency_name = row["Rating Agency Name"]
            print(Insert.get_rating_insert(ticker, rating, agency_name), file=prices)
        print("commit;", file=prices)


if __name__ == "__main__":
    generate_markets("datasets/MICs.csv")
    generate_countries_insert("datasets/country.csv")
    generate_us_insert("datasets/usa/nyse-company-list.csv", "XNYS")
    generate_us_insert("datasets/usa/nasdaq-company-list.csv", "XNAS")
    generate_etf_insert("datasets/sp500.csv", "S&P500", "SPY", "US", "XNYS")
    generate_price_insert("datasets/prices.csv")
    generate_rating_insert("datasets/corporate_rating.csv")
    generate_industry_insert()
