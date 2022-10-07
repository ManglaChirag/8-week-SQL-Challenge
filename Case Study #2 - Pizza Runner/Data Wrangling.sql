-- Data Wrangling --
-- Before starting this week's challenge we need to perform some data wrangling operations on the data to standardaize and clean the data to perform meaningful analysis

-- custmer_orders --
-- Remove null values from columns : exclusions, extras

update customer_orders
set exclusions='' where exclusions= 'null' or exclusions is null

update customer_orders
set extras='' where extras= 'null' or extras is null

-- Verify the clean table
select *
from customer_orders

-- runner_orders --
-- Remove null values from:
	-- pickup_time
	--distance
	-- duration
	--cancellation

update runner_orders
set cancellation='' where cancellation= 'null' or cancellation is null

update runner_orders
set distance=null where distance='null'

update runner_orders
set duration=null where duration='null'

update runner_orders
set pickup_time= null where pickup_time='null'

-- Remove extra text from colums:
	-- distance
	-- duration

update runner_orders
set distance=trim('km' from distance)

update runner_orders
set duration=trim('minutes' from duration)

--Alter column data types for:
	--pickup_time -> timestamp without time zone (DATETIME)
	-- distance -> float
	-- duration -> int

ALTER TABLE RUNNER_ORDERS
ALTER COLUMN PICKUP_TIME type timestamp WITHOUT TIME ZONE
using PICKUP_TIME::timestamp without time zone

ALTER TABLE RUNNER_ORDERS
ALTER COLUMN distance type double precision
using distance::double precision

ALTER TABLE RUNNER_ORDERS
ALTER COLUMN duration type int
using duration::integer

-- Verify the clean table
select *
from runner_orders