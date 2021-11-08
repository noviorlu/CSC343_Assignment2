-- Best and Worst Categories

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q4 CASCADE;

CREATE TABLE q4 (
    month TEXT NOT NULL,
    highestCategory TEXT NOT NULL,
    highestSalesValue FLOAT NOT NULL,
    lowestCategory TEXT NOT NULL,
    lowestSalesValue FLOAT NOT NULL
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS IIDVALUE CASCADE;
DROP VIEW IF EXISTS CategoryValue CASCADE;
DROP VIEW IF EXISTS RESULT CASCADE;
DROP VIEW IF EXISTS tempMonth CASCADE;
DROP VIEW IF EXISTS MonthTable CASCADE;

CREATE VIEW tempMonth AS
    SELECT to_char(DATE '2020-01-01' + (interval '1 month' * generate_series(0, 11)), 'MM') AS mo;

CREATE VIEW MonthTable AS
SELECT tempMonth.mo AS month, c1.category, 0 AS val
FROM tempMonth, (SELECT distinct category FROM Item) AS c1
ORDER BY tempMonth.mo;

-- Define views for your intermediate steps here:
CREATE VIEW CategoryValue AS
SELECT month, category, SUM(IIDSum) AS val
FROM
    (
    SELECT Item.IID, SUM(quantity) * price AS IIDSum, Item.category, month
    FROM 
    (
        SELECT PID, to_char(DATE '2020-01-01' + (interval '1 month' * (EXTRACT(MONTH FROM d) - 1)), 'MM') AS month
        FROM Purchase
        WHERE EXTRACT(YEAR FROM d) = 2020
    ) AS Is2020
    JOIN LineItem ON Is2020.PID = LineItem.PID
    JOIN Item ON LineItem.IID = Item.IID
    GROUP BY (month, Item.IID)
    ) AS IIDVALUE
GROUP BY (month, category);

CREATE VIEW validMonthTable AS
SELECT MonthTable.month, MonthTable.category, 
CASE    
    WHEN CategoryValue.val IS NULL THEN MonthTable.val
    WHEN CategoryValue.val IS NOT NULL THEN CategoryValue.val
END AS val
FROM MonthTable LEFT JOIN CategoryValue
ON MonthTable.month = CategoryValue.month AND MonthTable.category = CategoryValue.category;

CREATE VIEW completeTable AS
SELECT V1.month, V1.category AS cat1, V1.val AS val1, V2.category AS cat2, V2.val AS val2
FROM validMonthTable AS V1 JOIN validMonthTable AS V2
ON V1.month = V2.month;

CREATE VIEW result As
    SELECT *
    FROM completeTable C1 
    WHERE C1.val1 >= ALL(
        SELECT val1
        FROM completeTable C2 
        WHERE C1.month = C2.month
    ) 
    INTERSECT
    SELECT *
    FROM completeTable C1 
    WHERE C1.val2 <= ALL(
        SELECT val2
        FROM completeTable C2 
        WHERE C1.month = C2.month
    );

-- Your query that answers the question goes below the "insert into" line:
insert into q4
SELECT month, cat1, val1, cat2, val2
FROM result;