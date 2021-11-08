-- Customer Apreciation Week  
  
-- You must not change the next 2 lines or the table definition.  
SET SEARCH_PATH TO Recommender;  
  
-- Do this for each of the views that define your intermediate steps.    
-- (But give them better names!) The IF EXISTS avoids generating an error   
-- the first time this file is imported.  
  
-- Define views for your intermediate steps here:  
  
-- Your SQL code that performs the necessary insertions goes here:  
INSERT INTO Item  VALUES ((SELECT MAX(IID) FROM ITEM) + 1, 'Housewares', 'Company logo mug', 0);  
  
INSERT INTO LineItem(  
    SELECT PID, (SELECT MAX(IID) FROM ITEM) AS IID, 1 AS quantity  
    FROM(  
        SELECT *, row_number() over (partition by cid order by d) AS ranking  
        FROM Purchase  
        WHERE d >= NOW() - interval '1 day'  
    ) AS t1  
    WHERE ranking = 1  
); 