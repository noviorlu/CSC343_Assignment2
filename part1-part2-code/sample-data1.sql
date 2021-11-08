-- Small sample dataset for Assignment 2.

-- Item(IID, category, description, price)
INSERT INTO Item VALUES 
(1, 'Book', 'Cloud Atlas', 21.00),
(2, 'Book', 'A Thousand Splendid Suns', 20.21),
(3, 'Book', 'Homegoing', 20.21),
(4, 'Book', 'Trickster', 20.21);

-- Customer(CID, email, lastName, firstName, title)
INSERT INTO Customer VALUES
(1, 'jack.com', 'jack', 'chen', NULL),
(2, 'Pete.com', 'Peter', 'Li', NULL);
      
-- Purchase(PID, CID, d, cNumber, card)
INSERT INTO Purchase VALUES
(1, 1,'2021-11-07 03:11:27',1,'Amex'),
(2, 1,'2021-11-07 03:11:27',1,'Amex'),
(3, 1,'2021-11-07 03:11:27',1,'Amex'),
(4, 1,'2021-11-07 03:11:27',1,'Amex'),
(5, 1,'2021-11-07 03:11:27',1,'Amex'),
(6, 1,'2021-11-07 01:11:27',1,'Amex'),
(7, 2,'2021-11-07 01:11:27',1,'Amex');

-- LineItem(PID, IID, quantity)
INSERT INTO LineItem VALUES
(1, 1, 10),
(2, 2, 20),
(3, 1, 1),
(4, 1, 1),
(5, 3, 1),
(6, 3, 1),
(7, 4, 1);

-- Review(CID, IID, rating, comment)
INSERT INTO Review VALUES
(2, 4, 5, 'Amazing!');

-- Helpfulness(reviewer, IID, observer, helpfulness)
-- INSERT INTO Helpfulness VALUES


