-- Hyperconsumers

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q5 CASCADE;

CREATE TABLE q5 (
    year TEXT NOT NULL,
    name TEXT NOT NULL,
    email TEXT,
    items INTEGER NOT NULL
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS QuantityTable CASCADE;
DROP VIEW IF EXISTS intermediate_step CASCADE;
-- Define views for your intermediate steps here:
CREATE VIEW QuantityTable AS(
    SELECT EXTRACT(YEAR FROM d) AS year, CID, SUM(quantity) AS quantity
    FROM Purchase JOIN LineItem ON Purchase.PID = LineItem.PID
    GROUP BY (year, cid)
);

CREATE VIEW intermediate_step AS(
    SELECT *
    FROM QuantityTable AS q1
    WHERE EXISTS (
        SELECT q1.year, q1.CID, q1.quantity
        FROM
            (SELECT distinct q1.year, q1.CID, q2.quantity
            FROM QuantityTable AS q2
            WHERE q1.year = q2.year AND q1.quantity <= q2.quantity
            ) AS tubeGreater
        GROUP BY (tubeGreater.year, tubeGreater.CID)
        HAVING count(*) <= 5
    ) ORDER BY year
);

-- Your query that answers the question goes below the "insert into" line:
insert into q5
SELECT year, firstName || ' ' || lastName, email, quantity
FROM intermediate_step JOIN Customer ON intermediate_step.CID = Customer.CID;