-- Unrated products.

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF exists q1 CASCADE;

CREATE TABLE q1(
    CID INTEGER,
    firstName TEXT NOT NULL,
	lastName TEXT NOT NULL,
    email TEXT	
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS AllItems CASCADE;
DROP VIEW IF EXISTS HasReview CASCADE;
DROP VIEW IF EXISTS NoReview CASCADE;

-- DROP VIEW IF EXISTS RESULT CASCADE;
-- Purchase GroupBy CID

-- Define views for your intermediate steps here:
CREATE VIEW AllItems AS 
SELECT DISTINCT Purchase.CID, LineItem.IID
FROM Purchase
JOIN LineItem ON Purchase.PID = LineItem.PID;

CREATE VIEW HasReview AS 
SELECT AllItems.CID, AllItems.IID
FROM AllItems join Review ON AllItems.IID=Review.IID;

CREATE VIEW NoReview AS
SELECT h1.CID
FROM (SELECT CID, IID FROM AllItems EXCEPT SELECT CID, IID FROM HasReview) As h1
GROUP BY h1.CID
HAVING count(*) >= 3;

SELECT * FROM NoReview;
-- Your query that answers the question goes below the "insert into" line:
insert into q1 (CID,firstName,lastName,email)
SELECT Customer.CID,firstName,lastName,email
FROM NoReview JOIN Customer ON Customer.CID=NoReview.CID; 