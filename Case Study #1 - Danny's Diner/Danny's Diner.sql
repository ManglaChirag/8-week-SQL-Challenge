CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

  select * 
  from sales;

  /* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

-- Join sales and menu table to fetch price and customer id
-- group the data by customer id
SELECT S.CUSTOMER_ID,
	SUM(PRICE) AS TOTAL_SPEND
FROM SALES S
JOIN MENU M 
ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY CUSTOMER_ID
ORDER BY S.CUSTOMER_ID;

-- 2. How many days has each customer visited the restaurant?

-- select customer_id and count distinct order_date
-- group the result by customer_id

SELECT CUSTOMER_ID,
	COUNT(DISTINCT(ORDER_DATE)) AS VISITS
FROM SALES
GROUP BY CUSTOMER_ID;

-- 3. What was the first item from the menu purchased by each customer?

-- Rank the orders using row_number function by customer_id
-- Join the query on menu to get the product_name
-- Display the result where rank=1

SELECT CUSTOMER_ID,PRODUCT_NAME
FROM
	(SELECT *,
			ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID
				       	       ORDER BY ORDER_DATE) AS RANK
		FROM SALES) AS R
JOIN MENU M 
ON R.PRODUCT_ID = M.PRODUCT_ID
WHERE RANK = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
