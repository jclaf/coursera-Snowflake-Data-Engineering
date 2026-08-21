use warehouse compute_wh;
use database tasty_bytes;

SELECT
    t.make,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id
where franchisee_first_name = 'Sara' and franchisee_last_name = 'Nicholson';


DESCRIBE view tasty_bytes.raw_pos.truck;

SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id;

CREATE or replace dynamic table truck_franchise_dynamic 
    TARGET_LAG = '1 minute'
    WAREHOUSE = compute_wh
AS
SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id;

CREATE OR REPLACE DYNAMIC TABLE test_database.test_schema.nissan 
    TARGET_LAG = '5 minutes' 
    WAREHOUSE = compute_wh 
AS 
SELECT t.* 
FROM tasty_bytes.raw_pos.truck t 
WHERE t.make = 'Nissan';

DROP DYNAMIC TABLE test_database.test_schema.nissan;