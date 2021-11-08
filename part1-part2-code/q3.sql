-- Curators

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q3 CASCADE;

CREATE TABLE q3 (
    CID INT NOT NULL,
    categoryName TEXT NOT NULL,
    PRIMARY KEY(CID, categoryName)
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS alreadyDone CASCADE;
DROP VIEW IF EXISTS shouldHaveDone CASCADE;
DROP VIEW IF EXISTS didNotInclude CASCADE;
DROP VIEW IF EXISTS result CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW alreadyDone AS 
SELECT distinct Purchase.CID, reviewElim.IID, Item.category
FROM Purchase
JOIN LineItem ON Purchase.PID = LineItem.PID
JOIN Item ON LineItem.IID = Item.IID
JOIN (SELECT * FROM Review WHERE comment IS NOT NULL) AS reviewElim ON Purchase.CID = reviewElim.CID AND Item.IID = reviewElim.IID;

CREATE VIEW result AS
SELECT alreadyDone.CID, alreadyDone.category
FROM alreadyDone
GROUP BY(CID, category)
HAVING count(IID) = (
    SELECT count(IID)
    FROM Item
    WHERE alreadyDone.category = Item.category
);

-- Your query that answers the question goes below the "insert into" line:
insert into q3(CID, categoryName)
SELECT CID, category
FROM result;