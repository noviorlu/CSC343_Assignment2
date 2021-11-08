-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DELETE FROM PopularItems;
DELETE FROM DefinitiveRatings;
INSERT INTO PopularItems(
    SELECT IID FROM(
    SELECT IID, category, sum, rank() over (partition by category order by sum DESC) AS ranking
    FROM(
        SELECT Item.IID, category, SUM(quantity)
        FROM Purchase JOIN LineItem ON Purchase.PID = LineItem.PID
        JOIN Item ON LineItem.IID = Item.IID
        GROUP BY Item.IID
    )AS t1)AS t2 WHERE ranking <= 2
);
INSERT INTO DefinitiveRatings(
    SELECT Curator.CID, IID, rating FROM Curator JOIN Review ON Curator.CID = Review.CID
    WHERE IID IN(
        SELECT IID FROM PopularItems
    )
);
