-- Fraud Prevention

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.

-- Define views for your intermediate steps here:

CREATE VIEW needDelete AS(
    SELECT PID
    FROM(
        SELECT *, row_number() over (partition by cnumber order by d) AS ranking
        FROM purchase
        WHERE EXISTS(
            SELECT Purchase.PID
            FROM Purchase
            WHERE d >= NOW() - interval '1 day'
        )
    ) AS t1
    WHERE t1.ranking > 5
);

DELETE
FROM LineItem
WHERE EXISTS(
    SELECT needDelete.PID
    FROM needDelete
    WHERE needDelete.PID = LineItem.PID
);

DELETE
FROM Purchase
WHERE EXISTS(
    SELECT needDelete.PID
    FROM needDelete
    WHERE needDelete.PID = Purchase.PID
);