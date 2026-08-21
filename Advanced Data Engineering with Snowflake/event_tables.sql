use database snowflake;
use schema telemetry;
select * from events;


describe table events;

use database staging_tasty_bytes;
create or replace schema telemetry;
create or replace event table pipeline_events;

describe table pipeline_events;

alter account set EVENT_TABLE = staging_tasty_bytes.telemetry.pipeline_events;

