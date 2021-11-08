\i schema.sql
\i sample-data.sql
\i q3.sql
INSERT INTO Curator(SELECT distinct CID FROM q3);
DROP table q3;
DROP view result;