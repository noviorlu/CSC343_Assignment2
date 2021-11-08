-- SALE!SALE!SALE!

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;

UPDATE ITEM 
SET price = CASE
                WHEN price >= 10 AND price <=50 THEN price*0.8
                WHEN price > 50 AND price <=100 THEN price*0.7 
                WHEN price > 100 THEN price*0.5 
                ELSE price
            END
WHERE IID IN (
    SELECT IID
    FROM LineItem
    Group By IID
    Having SUM(quantity) >= 10 
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.

-- Define views for your intermediate steps here:

-- Your SQL code that performs the necessary updates goes here:
