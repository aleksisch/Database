from psycopg2 import sql
import math


class Insert:
    @staticmethod
    def prepare_arg_(arg):
        if type(arg) is float and math.isnan(arg):
            return "NULL"
        if type(arg) is str:
            return sql.Identifier(arg).string
        return arg


    @staticmethod
    def get_market_insert(MIC: str, name: str, ISO3166: str):
        return """INSERT INTO {table_name} (MIC, name, country_code) VALUES ('{MIC}', '{name}', '{country_code}');""" \
            .format(MIC=Insert.prepare_arg_(MIC), name=Insert.prepare_arg_(name), country_code=Insert.prepare_arg_(ISO3166),
                    table_name="stocks.stock_market")

    @staticmethod
    def get_country_insert(name: str, GDP: float, population: int, ISO3166: str):
        return """INSERT INTO {table_name} (iso, name, GDP_USD, population) VALUES ('{iso}', '{name}', {GDP_USD}, {population});""" \
            .format(iso=Insert.prepare_arg_(ISO3166),
                    name=Insert.prepare_arg_(name),
                    GDP_USD=Insert.prepare_arg_(GDP),
                    population=Insert.prepare_arg_(population),
                    table_name="stocks.country")

    @staticmethod
    def get_industry_insert(name: str):
        return """INSERT INTO {table_name} (name) VALUES ('{name}');""" \
            .format(name=Insert.prepare_arg_(name),
                    table_name="stocks.industry")

    @staticmethod
    def get_instrument_insert(ticker, stock_market, country, name):
        return """INSERT INTO {table_name} (ticker, stock_market, country, name) VALUES ('{ticker}', '{stock_market}', '{country}', '{name}');""" \
            .format(ticker=Insert.prepare_arg_(ticker),
                    stock_market=Insert.prepare_arg_(stock_market),
                    country=Insert.prepare_arg_(country),
                    name=Insert.prepare_arg_(name),
                    table_name="stocks.industry")

    @staticmethod
    def get_us_insert(ticker: str, market_cap: int):
        return """INSERT INTO {table_name} (ticker, market_cap) VALUES ('{ticker}', {market_cap});""" \
            .format(ticker=Insert.prepare_arg_(ticker),
                    market_cap=Insert.prepare_arg_(market_cap),
                    table_name="stocks.stock")

    @staticmethod
    def get_etf_insert(ticker: str):
        return """INSERT INTO {table_name} (ticker, market_cap) VALUES ('{ticker}');""" \
            .format(ticker=Insert.prepare_arg_(ticker),
                    table_name="stocks.etf")

    @staticmethod
    def get_etf_stock_insert(etf_ticker, stock_ticker):
        return """INSERT INTO {table_name} (etf_ticker, stock_ticker) VALUES ('{etf_ticker}', '{stock_ticker}');""" \
            .format(etf_ticker=Insert.prepare_arg_(etf_ticker),
                    stock_ticker=Insert.prepare_arg_(stock_ticker),
                    table_name="stocks.etf_stock")

    @staticmethod
    def get_instrument_industry_insert(ticker, industry_id):
        return """INSERT INTO {table_name} (ticker, industry_id) VALUES ('{ticker}', '{industry_id}');""" \
            .format(ticker=Insert.prepare_arg_(ticker),
                    industry_id=Insert.prepare_arg_(industry_id),
                    table_name="stocks.instrument_industry")
