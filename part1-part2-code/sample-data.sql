-- Small sample dataset for Assignment 2.

-- Item(IID, category, description, price)
INSERT INTO Item VALUES 
(1, 'Book', 'sdqdqdqdq', 5.0);

-- Customer(CID, email, lastName, firstName, title)
INSERT INTO Customer VALUES
(1, 'customerA@email.com', 'Tomer', 'Cousin', NULL),
(2, 'customerB@email.com', 'Tomer', 'Cas', NULL);
      
-- Purchase(PID, CID, d, cNumber, card)
INSERT INTO Purchase VALUES
(1, 1, '2021-11-07 00:59:27.967040-05:00', 12345, 'Amex'),
(2, 2, '2020-02-05', 56789, 'Mastercard');

-- LineItem(PID, IID, quantity)
INSERT INTO LineItem VALUES
(1, 1, 20),
(2, 1, 15);