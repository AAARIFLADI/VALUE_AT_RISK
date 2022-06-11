select DATE1 AS DATE,[Adj Close] as PRICE_CLOSED from RISK..AAPL

---------------------------------------------------------------
--We use Lag function to add the previous price column


select DATE1 AS DATE,[Adj Close] as CLOSED_PRICE, LAG([Adj Close]) over(order by DATE1) as PREVIOUS_CLOSED_PRICE from RISK..AAPL


-- CALCULATE THE VARIATION of price

WITH CTE as (select DATE1 AS DATE,[Adj Close] as CLOSED_PRICE, LAG([Adj Close]) over(order by DATE1) as PREVIOUS_CLOSED_PRICE from RISK..AAPL)
select DATE,CLOSED_PRICE,PREVIOUS_CLOSED_PRICE,(CLOSED_PRICE-PREVIOUS_CLOSED_PRICE)*100/CLOSED_PRICE as VARIATION from CTE

---We use NTILE function in order to partition our dataset by percentile

WITH CTE as (select DATE1 AS DATE,[Adj Close] as CLOSED_PRICE, LAG([Adj Close]) over(order by DATE1) as PREVIOUS_CLOSED_PRICE from RISK..AAPL)
select DATE,CLOSED_PRICE,PREVIOUS_CLOSED_PRICE,(CLOSED_PRICE-PREVIOUS_CLOSED_PRICE)*100/CLOSED_PRICE as VARIATION,NTILE(100) over (order by (CLOSED_PRICE-PREVIOUS_CLOSED_PRICE)*100/CLOSED_PRICE) as NT
from CTE
WHERE PREVIOUS_CLOSED_PRICE is not null

---VaR 99% correspond to the MAX value of percentile 1 (NT=1)

WITH CTE as (select DATE1 AS DATE,[Adj Close] as CLOSED_PRICE, LAG([Adj Close]) over(order by DATE1) as PREVIOUS_CLOSED_PRICE from RISK..AAPL),
CTE2 as(select DATE,CLOSED_PRICE,PREVIOUS_CLOSED_PRICE,(CLOSED_PRICE-PREVIOUS_CLOSED_PRICE)*100/CLOSED_PRICE as VARIATION,NTILE(100) over (order by (CLOSED_PRICE-PREVIOUS_CLOSED_PRICE)*100/CLOSED_PRICE) as NT
from CTE
WHERE PREVIOUS_CLOSED_PRICE is not null)
select ROUND(MAX(variation),4) as VaR from CTE2
where NT=1

---VaR 99% is MAX varitation where NT =5
WITH CTE as (select DATE1 AS DATE,[Adj Close] as CLOSED_PRICE, LAG([Adj Close]) over(order by DATE1) as PREVIOUS_CLOSED_PRICE from RISK..AAPL),
CTE2 as(select DATE,CLOSED_PRICE,PREVIOUS_CLOSED_PRICE,(CLOSED_PRICE-PREVIOUS_CLOSED_PRICE)*100/CLOSED_PRICE as VARIATION,NTILE(100) over (order by (CLOSED_PRICE-PREVIOUS_CLOSED_PRICE)*100/CLOSED_PRICE) as NT
from CTE
WHERE PREVIOUS_CLOSED_PRICE is not null)
select ROUND(MAX(variation),4) as VaR from CTE2
where NT=5

