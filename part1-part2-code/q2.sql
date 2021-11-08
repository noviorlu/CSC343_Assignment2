-- Helpfulness

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q2 CASCADE;

create table q2(
    CID INTEGER,
    firstName TEXT NOT NULL,
    helpfulness_category TEXT
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS ReviewTable CASCADE;
DROP VIEW IF EXISTS ReviewRate CASCADE;
-- Define views for your intermediate steps here:
-- 1. Summarize Helpfulness for a single review
CREATE VIEW ReviewTable AS (
    SELECT allreview.reviewer AS CID, allreview.IID,
    CASE
        WHEN helpfulReview.help IS NULL THEN False
        ELSE true
    END AS help
    FROM
        (SELECT h1.Reviewer, h1.IID, true AS help
        FROM Helpfulness AS h1
        WHERE h1.helpfulness = true
        GROUP BY h1.Reviewer, h1.IID
        HAVING count(*) > (
            SELECT count(*) / 2
            FROM Helpfulness AS h2
            GROUP BY Reviewer, IID
            HAVING h1.Reviewer = h2.Reviewer AND h1.IID = h2.IID
        )) AS helpfulReview
    RIGHT JOIN
        (SELECT distinct Reviewer, IID
        FROM Helpfulness
        )AS allreview
    ON helpfulReview.reviewer = allreview.reviewer AND helpfulReview.IID = allreview.IID
);

CREATE VIEW ReviewRate AS (
    SELECT allCustomer.CID, allCustomer.firstName,
    CASE
        WHEN helpfulReview.trueSum IS NULL THEN 0
        ELSE CAST(helpfulReview.trueSum AS float) / CAST(aLLReview.allSum AS float)
    END AS rate
    FROM
        (SELECT CID, firstName FROM Customer) AS allCustomer
    LEFT JOIN
        (SELECT CID, count(*) AS allSum
        FROM ReviewTable
        GROUP BY CID
        ) AS aLLReview
    ON allCustomer.CID = aLLReview.CID
    LEFT JOIN
        (SELECT CID, count(*) AS trueSum
        FROM ReviewTable
        WHERE help = true
        GROUP BY CID
        ) AS helpfulReview
    ON aLLReview.CID = helpfulReview.CID
);

-- Your query that answers the question goes below the "insert into" line:
insert into q2
SELECT CID, firstName,
CASE 
    WHEN (rate < 0.5) OR (rate IS NULL) THEN 'not helpful'
    WHEN (rate >= 0.5) AND (rate < 0.8) THEN 'somewhat helpful'
    WHEN (rate >= 0.8) THEN 'very helpful'
END AS helpfulness_category
FROM ReviewRate;

SELECT * FROM q2;