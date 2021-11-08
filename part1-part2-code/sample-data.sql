-- Small sample dataset for Assignment 2.

-- Item(IID, category, description, price)
INSERT INTO Item VALUES 
(1, 'Book', '...', 21.00),
(2, 'Shirt', '...', 14.00),
(3, 'Hat', '...', 22.00);

-- Customer(CID, email, lastName, firstName, title)
INSERT INTO Customer VALUES
(100 , 'customerA@email.com', 'Granger', 'Hermione', 'Ms'),
(200 , 'customerB@email.com', 'Potter', 'Harry', 'Mr'),
(300 , 'customerC@email.com', 'Dumbledor', 'Albus', 'Professor');
      
-- Purchase(PID, CID, d, cNumber, card)
INSERT INTO Purchase VALUES
(1, 100, '2019-11-01', 12345, 'Amex'),
(2, 200, '2019-11-01', 64210, 'Visa'),
(3, 300, '2021-01-01', 99999, 'Mastercard');

-- LineItem(PID, IID, quantity)
INSERT INTO LineItem VALUES
(1, 1, 1),
(2, 1, 1),
(2, 2, 1),
(2, 3, 1),
(3, 2, 1);

-- Review(CID, IID, rating, comment)
INSERT INTO Review VALUES
(100, 1, 5, 'Fantastic read!'),
(200, 1, 1, 'Meh. '),
(200, 2, 4, 'Pretty good.'),
(300, 2, 5, 'Fantastic!'),
(300, 3, 5, 'Great!! ');

-- -- Helpfulness(reviewer, IID, observer, helpfulness)
-- INSERT INTO Helpfulness VALUES
-- (1515, 4, 1599, False),
-- (1515, 4, 1518, True),
-- (1515, 4, 1515, True),
-- (1515, 4, 1500, True),
-- (1518, 4, 1599, True),
-- (1518, 4, 1515, True),
-- (1518, 4, 1500, False);

