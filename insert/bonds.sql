INSERT INTO stocks.instruments (ticker, stock_market, country, name) 
						VALUES ('US38259PAD42', 'XNAS', 'US', 'Google bond')
						ON CONFLICT DO NOTHING ;
INSERT INTO stocks.bond (ticker, issuer, yield) 
                      	VALUES ('US38259PAD42', 'GOOG', 3.37)
                      	ON CONFLICT DO NOTHING ;

INSERT INTO stocks.instruments (ticker, stock_market, country, name) 
						VALUES ('US037833BX70', 'XNAS', 'US', 'Apple bond');
						ON CONFLICT DO NOTHING ;
INSERT INTO stocks.bond (ticker, issuer, yield) 
                      	VALUES ('US037833BX70', 'AAPL', 4.65)
                      	ON CONFLICT DO NOTHING ;

INSERT INTO stocks.instruments (ticker, stock_market, country, name) 
						VALUES ('US143658AF97', 'XNYS', 'US', 'Carnival bonds')
						ON CONFLICT DO NOTHING ;
INSERT INTO stocks.bond (ticker, issuer, yield) 
                      	VALUES ('US143658AF97', 'CCL', 7.2)
                      	ON CONFLICT DO NOTHING ;


INSERT INTO stocks.instruments (ticker, stock_market, country, name) 
						VALUES ('US302570AY26', 'XNYS', 'US', 'NEE bonds')
						ON CONFLICT DO NOTHING ;
INSERT INTO stocks.bond (ticker, issuer, yield) 
                      	VALUES ('US302570AY26', 'NEE', 5.14)
                      	ON CONFLICT DO NOTHING ;


INSERT INTO stocks.instruments (ticker, stock_market, country, name) 
						VALUES ('HK0000424330', 'XNYS', 'US', 'CSI bonds')
						ON CONFLICT DO NOTHING ;
INSERT INTO stocks.bond (ticker, issuer, yield) 
                      	VALUES ('HK0000424330', 'CSI', 5.9)
                      	ON CONFLICT DO NOTHING ;

INSERT INTO stocks.instruments (ticker, stock_market, country, name) 
						VALUES ('US85917AAC45', 'XNYS', 'US', 'STL bonds')
						ON CONFLICT DO NOTHING ;
INSERT INTO stocks.bond (ticker, issuer, yield) 
                      	VALUES ('US85917AAC45', 'STL', 3.8)
                      	ON CONFLICT DO NOTHING ;

INSERT INTO stocks.instruments (ticker, stock_market, country, name) 
						VALUES ('US637844AE11', 'XNYS', 'US', 'SID bonds')
						ON CONFLICT DO NOTHING ;
INSERT INTO stocks.bond (ticker, issuer, yield) 
                      	VALUES ('US637844AE11', 'SID', 8.37)
                      	ON CONFLICT DO NOTHING ;

INSERT INTO stocks.instruments (ticker, stock_market, country, name) 
						VALUES ('US670346AM72', 'XNYS', 'US', 'NUE bonds')
						ON CONFLICT DO NOTHING ;
INSERT INTO stocks.bond (ticker, issuer, yield) 
                      	VALUES ('US670346AM72', 'NUE', 4)
                      	ON CONFLICT DO NOTHING ;

INSERT INTO stocks.instruments (ticker, stock_market, country, name) 
						VALUES ('US6914973093', 'XNYS', 'US', 'OXM bonds')
						ON CONFLICT DO NOTHING ;
INSERT INTO stocks.bond (ticker, issuer, yield) 
                      	VALUES ('US6914973093', 'OXM', 6.2)
                      	ON CONFLICT DO NOTHING ;

INSERT INTO stocks.instruments (ticker, stock_market, country, name) 
						VALUES ('USU72284AF69', 'XNYS', 'US', 'PF bonds')
						ON CONFLICT DO NOTHING ;
INSERT INTO stocks.bond (ticker, issuer, yield) 
                      	VALUES ('USU72284AF69', 'PF', 5.875)
                      	ON CONFLICT DO NOTHING ;

