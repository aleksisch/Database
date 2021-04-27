from psycopg2 import sql
import math


class Insert:
    @staticmethod
    def prepare_arg_(arg):
        if arg is None:
            return "NULL"
        if type(arg) is float and math.isnan(arg):
            return "NULL"
        if type(arg) is str:
            return "'" + sql.Identifier(arg).string + "'"
        return arg


    @staticmethod
    def get_market_insert(MIC: str, name: str, ISO3166: str):
        return """INSERT INTO {table_name} (MIC, name, country_code) VALUES ({MIC}, {name}, {country_code})ON CONFLICT DO NOTHING ;""" \
            .format(MIC=Insert.prepare_arg_(MIC), name=Insert.prepare_arg_(name), country_code=Insert.prepare_arg_(ISO3166),
                    table_name="stocks.stock_market")

    @staticmethod
    def get_country_insert(name: str, GDP: float, population: int, ISO3166: str):
        if Insert.prepare_arg_(ISO3166) == 'NULL':
            print(ISO3166)
            raise 1
        return """INSERT INTO {table_name} (iso, name, GDP_USD, population) VALUES ({iso}, {name}, {GDP_USD}, {population})ON CONFLICT DO NOTHING ;""" \
            .format(iso=Insert.prepare_arg_(ISO3166),
                    name=Insert.prepare_arg_(name),
                    GDP_USD=Insert.prepare_arg_(GDP),
                    population=Insert.prepare_arg_(population),
                    table_name="stocks.country")

    @staticmethod
    def get_industry_insert(name: str):
        return """INSERT INTO {table_name} (name) VALUES ({name})ON CONFLICT DO NOTHING ;""" \
            .format(name=Insert.prepare_arg_(name),
                    table_name="stocks.industry")

    @staticmethod
    def get_instrument_insert(ticker, stock_market, country, name):
        return """INSERT INTO {table_name} (ticker, stock_market, country, name) VALUES ({ticker}, {stock_market}, {country}, {name})ON CONFLICT DO NOTHING ;""" \
            .format(ticker=Insert.prepare_arg_(ticker),
                    stock_market=Insert.prepare_arg_(stock_market),
                    country=Insert.prepare_arg_(country),
                    name=Insert.prepare_arg_(name),
                    table_name="stocks.instruments")

    @staticmethod
    def get_us_insert(ticker: str, market_cap: int):
        return """INSERT INTO {table_name} (ticker, market_cap) VALUES ({ticker}, {market_cap})ON CONFLICT DO NOTHING ;""" \
            .format(ticker=Insert.prepare_arg_(ticker),
                    market_cap=Insert.prepare_arg_(market_cap),
                    table_name="stocks.stock")

    @staticmethod
    def get_etf_insert(ticker: str):
        return """INSERT INTO {table_name} (ticker, market_cap) VALUES ({ticker}, NULL) ON CONFLICT DO NOTHING ;""" \
            .format(ticker=Insert.prepare_arg_(ticker),
                    table_name="stocks.etf")

    @staticmethod
    def get_etf_stock_insert(etf_ticker, stock_ticker):
        return """INSERT INTO {table_name} (etf_ticker, stock_ticker) VALUES ({etf_ticker}, {stock_ticker})ON CONFLICT DO NOTHING ;""" \
            .format(etf_ticker=Insert.prepare_arg_(etf_ticker),
                    stock_ticker=Insert.prepare_arg_(stock_ticker),
                    table_name="stocks.etf_stock",
                    instruments="stocks.instruments")

    @staticmethod
    def get_instrument_industry_insert(ticker, industry_id):
        return """INSERT INTO {table_name} (ticker, industry_id) VALUES ({ticker}, {industry_id}) ON CONFLICT DO NOTHING ;""" \
            .format(ticker=Insert.prepare_arg_(ticker),
                    industry_id=Insert.prepare_arg_(industry_id),
                    table_name="stocks.instrument_industry")

    @staticmethod
    def get_prices_insert(currency, ticker, date_begin, date_end, mi, ma, open, close):
        return """INSERT INTO {table_name} (ticker, currency, date_begin, date_end, open_price, close_price, min_price, max_price) 
                  VALUES ({ticker}, {currency}, {date_begin}, {date_end}, {open_price}, {close_price}, {min_price}, {max_price}) 
                  ON CONFLICT DO NOTHING ;""" \
            .format(ticker=Insert.prepare_arg_(ticker),
                    currency=Insert.prepare_arg_(currency),
                    date_begin=Insert.prepare_arg_(date_begin),
                    date_end=Insert.prepare_arg_(date_end),
                    min_price=Insert.prepare_arg_(mi),
                    max_price=Insert.prepare_arg_(ma),
                    open_price=Insert.prepare_arg_(open),
                    close_price=Insert.prepare_arg_(close),
                    table_name="stocks.price_history")

    @staticmethod
    def get_rating_insert(ticker, rating, agency_name):
        return """INSERT INTO {table_name} (ticker, agency_name, score) 
                      VALUES ({ticker}, {agency_name}, {score}) 
                      ON CONFLICT DO NOTHING ;""" \
            .format(ticker=Insert.prepare_arg_(ticker),
                    score=Insert.prepare_arg_(rating),
                    agency_name=Insert.prepare_arg_(agency_name),
                    table_name="stocks.credit_rating")
