import pandas as pd
from sql_help import Insert

def read_data(path_to_file):
    return pd.read_csv(path_to_file)


def generate_markets(path_to_file):
    df = read_data(path_to_file)
    with open("insert/markets.sql", "w") as f:
        for index, row in df.iterrows():
            MIC = row["MIC"]
            name = row["NAME-INSTITUTION DESCRIPTION"]
            country = row["ISO COUNTRY CODE (ISO 3166)"]
            print(Insert.get_market_insert(MIC, name, country), file=f)


def generate_countries_insert(path_to_file):
    df = read_data(path_to_file)
    with open("insert/countries.sql", "w") as f:
        for index, row in df.iterrows():
            iso = row["ISO-3166Code"]
            name = row["Country"]
            gdp = float(row["GDPp.c.(USD)"][1:])
            population = row["Population"]
            print(Insert.get_country_insert(name, gdp, population, iso), file=f)

all_industry = dict()

def generate_us_insert(path_to_file, exchange):
    df = read_data(path_to_file)
    with open("insert/stock.sql", "a+") as s, open("insert/industries.sql", "a+") as ind, open("insert/instruments.sql", "a+") as ins:
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
            if industry not in all_industry:
                all_industry[industry] = len(all_industry)
                print(Insert.get_industry_insert(industry), file=ind)
            print(Insert.get_instrument_insert(ticker, exchange, "US", name), file=ins)
            print(Insert.get_us_insert(ticker, market_cap), file=s)

def generate_etf_insert(path_to_file, etf_name, etf_ticker):
    df = read_data(path_to_file)
    with open("insert/etfs.sql", "a+") as etf, open("insert/industries.sql", "w+") as ind:
        print(Insert.get_instrument_insert(etf_ticker, "NULL", "NULL", etf_name), file=etf)
        for index, row in df.iterrows():
            ticker = row["Symbol"]
            industry = row["Sector"]
            if industry not in all_industry:
                all_industry[industry] = len(industry)
                print(Insert.get_industry_insert(industry), file=ind)
            print(Insert.get_etf_stock_insert(etf_ticker, ticker), file=etf)
            print(Insert.get_instrument_industry_insert(etf_ticker, all_industry[industry]), file=etf)


if __name__ == "__main__":
    generate_markets("datasets/MICs.csv")
    generate_countries_insert("datasets/country.csv")
    generate_us_insert("datasets/usa/nyse-company-list.csv", "XNYS")
    generate_us_insert("datasets/usa/nasdaq-company-list.csv", "XNAS")
    generate_etf_insert("datasets/sp500.csv", "S&P500", "SPY")

