--Year-over-year sales

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q6 CASCADE;

CREATE TABLE q6 (
    IID INT NOT NULL,
    Year1 INT NOT NULL,
    Year1Average FLOAT NOT NULL,
    Year2 INT NOT NULL,
    Year2Average FLOAT NOT NULL,
    YearOverYearChange FLOAT NOT NULL
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS totalUnitTable CASCADE;
DROP VIEW IF EXISTS helperYearIID CASCADE;
DROP VIEW IF EXISTS completeTable CASCADE;
DROP VIEW IF EXISTS result CASCADE;
-- Define views for your intermediate steps here:

CREATE VIEW helperYearIID AS(
    SELECT y1 AS year, IID
    FROM generate_series(
        (SELECT MIN(EXTRACT(YEAR FROM d)) FROM Purchase)::int,
        (SELECT MAX(EXTRACT(YEAR FROM d)) FROM Purchase)::int
    ) AS y1, Item
);

CREATE VIEW totalUnitTable AS (
    SELECT (EXTRACT(YEAR FROM d))::int AS year, IID, (SUM(quantity)::FLOAT / 12) AS monthlyAvg
    FROM Purchase
    JOIN LineItem ON Purchase.PID = LineItem.PID
    GROUP BY(year, IID)
);

CREATE VIEW completeTable AS (
    SELECT helperYearIID.year, helperYearIID.IID,
    CASE 
        WHEN monthlyAvg IS NULL THEN 0
        ELSE monthlyAvg
    END
    FROM helperYearIID LEFT JOIN totalUnitTable 
    ON helperYearIID.year = totalUnitTable.year AND helperYearIID.IID = totalUnitTable.IID 
);

CREATE VIEW result AS(
    SELECT t1.IID, t1.year AS Year1, t1. monthlyAvg AS Year1Average,
    t2.year AS Year2, t2. monthlyAvg AS Year2Average,
    CASE
        WHEN t1. monthlyAvg = 0 AND t2. monthlyAvg <> 0 THEN 'Infinity'
        WHEN t1. monthlyAvg = 0 AND t2.monthlyAvg = 0 THEN 0
        ELSE ((t2.monthlyAvg - t1. monthlyAvg) / t1. monthlyAvg) * 100
    END AS YearOverYearChange
    FROM(
        SELECT *
        FROM completeTable
        WHERE year < SOME(SELECT c.year FROM completeTable AS c)
    )AS t1 JOIN (
        SELECT *
        FROM completeTable
        WHERE year > SOME(SELECT c.year FROM completeTable AS c)
    )AS t2 
    ON t1.year = t2.year - 1 AND t1.IID = t2.IID
    ORDER BY t1.IID
);

-- Your query that answers the question goes below the "insert into" line:
insert into q6
SELECT IID, Year1, Year1Average, Year2, Year2Average, YearOverYearChange 
FROM result;