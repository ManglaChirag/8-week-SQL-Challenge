-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT (((REGISTRATION_DATE - '2020-12-31') / 7) + 1) AS WEEK,
	COUNT(*) AS RUNNERS
FROM RUNNERS
GROUP BY 1
ORDER BY 1


-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH CTE AS
	(SELECT AVG(EXTRACT(MIN FROM(PICKUP_TIME - ORDER_TIME))) AS PICKUP_TIME
		FROM RUNNER_ORDERS R
		INNER JOIN CUSTOMER_ORDERS C ON R.ORDER_ID = C.ORDER_ID
		GROUP BY R.ORDER_ID)
SELECT AVG(PICKUP_TIME) AS AVG_PICKUP_TIME
FROM CTE


-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH CTE AS
	(SELECT C.ORDER_ID,
			COUNT(C.ORDER_ID) AS NO_OF_PIZZA,
			AVG(EXTRACT(MIN FROM(PICKUP_TIME - ORDER_TIME))) AS PICK_TIME
		FROM RUNNER_ORDERS R
		INNER JOIN CUSTOMER_ORDERS C ON R.ORDER_ID = C.ORDER_ID
		GROUP BY C.ORDER_ID)
SELECT NO_OF_PIZZA,
	AVG(PICK_TIME)::int AS PREPARATION_TIME
FROM CTE
GROUP BY 1

-- 4. What was the average distance travelled for each customer?

select customer_id, avg(distance)::decimal
FROM RUNNER_ORDERS R
		INNER JOIN CUSTOMER_ORDERS C ON R.ORDER_ID = C.ORDER_ID
group by 1
order by 1

-- 5. What was the difference between the longest and shortest delivery times for all orders?

SELECT MAX(DURATION) - MIN(DURATION) AS DELIVERY_TIME_DIFF
FROM RUNNER_ORDERS

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

WITH CTE AS
	(SELECT RUNNER_ID,
			AVG(DISTANCE / DURATION * 60)::int AS RUNNER_AVG_SPEED
		FROM RUNNER_ORDERS
		GROUP BY 1)
SELECT R.RUNNER_ID,
	ORDER_ID,
	(DISTANCE / DURATION * 60)::int AS DELIVERY_SPEED,
	RUNNER_AVG_SPEED
FROM RUNNER_ORDERS R
JOIN CTE C ON R.RUNNER_ID = C.RUNNER_ID
WHERE DISTANCE IS NOT NULL
ORDER BY 1

-- 7. What is the successful delivery percentage for each runner?

SELECT 
  runner_id, 
  SUM(
    CASE WHEN distance is null THEN 0
    ELSE 100 END) / COUNT(*) AS successful_delivery_perc
FROM runner_orders
GROUP BY runner_id;
