set search_path = 'stocks';

drop table if exists countries_log;
create table countries_log
(
    number SERIAL,
    iso text,
    timestamp timestamp,
    gdp bigint,
    operation text
);

drop table if exists bonds_history;
create table bonds_history
(
    ticker text,
    issuer text,
    yield double precision
);

create or replace function add_log_country() returns trigger as $$
begin
    if (tg_op = 'UPDATE') or (tg_op = 'INSERT') then
        insert into countries_log (iso, timestamp, gdp, operation) values (new.iso, now(), new.gdp_usd, tg_op);
    else
        raise exception 'Expected only insert or update';
    end if;
    return old;
end;
$$ language plpgsql;

drop trigger if exists country_log on stocks.country;
create trigger country_log
    after update or insert on stocks.country
    for each row
    execute procedure add_log_country();

create or replace function save_bond() returns trigger as $$
begin
    INSERT INTO bonds_history (ticker, issuer, yield) VALUES (old.*);
    return old;
end;
$$ language plpgsql;

drop trigger if exists add_bonds_history on stocks.bond;
create trigger add_bonds_history
    after delete on stocks.bond
    for each row
    execute procedure save_bond();

insert into stocks.bond (ticker, issuer, yield) VALUES ('NMBL', 'NMBL', 0.1);
delete from stocks.bond where ticker = 'NMBL';
select * from bonds_history;

select * from countries_log;
insert into stocks.country (iso, name, gdp_usd, population) VALUES ('yy', 'not_existing_country', 1, 1);
select * from countries_log;
delete from stocks.country where iso = 'yy';



