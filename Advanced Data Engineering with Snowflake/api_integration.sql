USE ROLE accountadmin;
CREATE DATABASE course_repo;
USE SCHEMA public;

-- Create credentials
CREATE OR REPLACE SECRET course_repo.public.github_pat
  TYPE = password
  USERNAME = '' <-- github username
  PASSWORD = ''; <-- github password for this api

-- Create the API integration
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/<username>') -- URL to your GitHub profile
  ALLOWED_AUTHENTICATION_SECRETS = (github_pat)
  ENABLED = TRUE;

-- Create the git repository object
CREATE OR REPLACE GIT REPOSITORY course_repo.public.advanced_data_engineering_snowflake
  API_INTEGRATION = git_api_integration -- Name of the API integration defined above
  ORIGIN = 'https://github.com/<username>/advanced-data-engineering-snowflake.git' -- Insert URL of forked repo
  GIT_CREDENTIALS = course_repo.public.github_pat;

-- List the git repositories
SHOW GIT REPOSITORIES;

LIST @advanced_data_engineering_snowflake/branches/main/module-1/hamburg_weather/pipeline/data/;

CREATE OR REPLACE FILE FORMAT COURSE_REPO.PUBLIC.tmp_raw_ff
  TYPE = 'CSV'
  FIELD_DELIMITER = NONE
  RECORD_DELIMITER = '\n'
  PARSE_HEADER = FALSE;

SELECT $1
FROM @advanced_data_engineering_snowflake/branches/main/module-1/hamburg_weather/pipeline/data/load_tasty_bytes.sql
(FILE_FORMAT => 'COURSE_REPO.PUBLIC.tmp_raw_ff')
LIMIT 25;

SHOW DATABASES LIKE 'SNOWFLAKE';
DESCRIBE DATABASE SNOWFLAKE;

SHOW SCHEMAS LIKE 'SNOWPARK' IN DATABASE SNOWFLAKE;
SHOW ARTIFACT REPOSITORIES IN SCHEMA SNOWFLAKE.SNOWPARK;