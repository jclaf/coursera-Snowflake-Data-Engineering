use warehouse compute_wh;
use database tasty_bytes;

// Time Travel
CREATE TABLE tasty_bytes.raw_pos.truck_dev
    CLONE tasty_bytes.raw_pos.truck;
SELECT * FROM tasty_bytes.raw_pos.truck_dev;
SET saved_query_id = LAST_QUERY_ID();
SET saved_timestamp = CURRENT_TIMESTAMP;
UPDATE tasty_bytes.raw_pos.truck_dev t
    SET t.year = (YEAR(CURRENT_DATE()) -1000);

SHOW VARIABLES;
SELECT * FROM tasty_bytes.raw_pos.truck_dev AT(TIMESTAMP => $saved_timestamp);
SELECT * FROM tasty_bytes.raw_pos.truck_dev BEFORE(STATEMENT => $saved_query_id);

//cloning ans resource monitors

CREATE DATABASE tasty_bytes_clone CLONE tasty_bytes;

create table tasty_bytes.raw_pos.truck_clone clone tasty_bytes.raw_pos.truck;

SELECT * FROM tasty_bytes.INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE (TABLE_NAME = 'TRUCK_CLONE' OR TABLE_NAME = 'TRUCK')
AND TABLE_CATALOG = 'TASTY_BYTES';

create resource monitor tasty_test_rm
with 
    CREDIT_QUOTA = 15
    FREQUENCY = DAILY
    START_TIMESTAMP = IMMEDIATELY
  TRIGGERS
    ON 90 PERCENT DO NOTIFY;

SHOW resource monitors;

create warehouse tasty_test_wh;

ALTER WAREHOUSE tasty_test_wh 
  SET RESOURCE_MONITOR = tasty_test_rm;

SHOW resource monitors;

alter resource monitor tasty_test_rm SET credit_quota = 20;

// User-Defined Functions (UDFs)

SHOW FUNCTIONS;

Create function min_menu_price ()
returns NUMBER(5,2)
  AS 'SELECT MIN(SALE_PRICE_USD) FROM TASTY_BYTES.RAW_POS.MENU';

SELECT min_menu_price();

show functions ;

create function  menu_prices_below(price_ceiling NUMBER)
returns TABLE (item VARCHAR, price NUMBER)
as 'SELECT MENU_ITEM_NAME, SALE_PRICE_USD
    FROM TASTY_BYTES.RAW_POS.MENU
    WHERE SALE_PRICE_USD < price_ceiling
    ORDER BY 2 DESC';

select * from table(menu_prices_below(3));


// Stored Procedures

create procedure increase_prices ()
returns BOOLEAN
language sql
as 'UPDATE tasty_bytes_clone.raw_pos.menu
  SET SALE_PRICE_USD = menu.SALE_PRICE_USD + 1;'

call increase_prices();

DESCRIBE procedure increase_prices();

create procedure decrease_mango_sticky_rice_price()
returns BOOLEAN
language sql 
as 'UPDATE tasty_bytes_clone.raw_pos.menu set SALE_PRICE_USD = menu.SALE_PRICE_USD -1 where MENU_ITEM_NAME="Mango Sticky Rice";';

SHOW PROCEDURES;

//ROle-based Access Control (RBAC)
create role tasty_role;
show grants to role tasty_role;

grant create database on account TO ROLE tasty_role;

select current_user;

grant role tasty_role to user <user_name>;

use role tasty_role;

create warehouse tasty_test_wh;

use role accountadmin;

show grants to user <user_name>;

show grants to role useradmin;