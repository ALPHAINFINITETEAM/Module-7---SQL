DROP TABLE IF EXISTS card_holder;
DROP TABLE IF EXISTS credit_card ;
DROP TABLE IF EXISTS transaction; 
DROP TABLE IF EXISTS merchant ;
DROP TABLE IF EXISTS merchant_category;
-- 1. Create a Card Holder table
CREATE TABLE card_holder (
    id INT NOT NULL,
    name VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

-- 2. Create a second table Credit Card with a foreign key that references Card Holder table
CREATE TABLE credit_card (
    card VARCHAR(20) NOT NULL,
    cardholder_id INTEGER NOT NULL,
    PRIMARY KEY (card),
    FOREIGN KEY (cardholder_id) REFERENCES card_holder(id)
);

-- Let's create a third table Merchant Category
CREATE TABLE merchant_category (
    id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    PRIMARY KEY (id)
    
);

-- Let's create a fourth table Merchant with a foreign key that references Merchant Category table
CREATE TABLE merchant (
    id INT NOT NULL,
    name VARCHAR(200),
    id_merchant_category INTEGER NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id)
);

-- Let's create a fifth table Transaction with a foreign key that references credit Card and Merchant table
CREATE TABLE transaction (
    id INTEGER NOT NULL,
    date TIMESTAMP NOT NULL,
    amount  MONEY NOT NULL,
	card VARCHAR(20) ,
	id_merchant INTEGER ,
    PRIMARY KEY (id),
    FOREIGN KEY (card) REFERENCES credit_card(card),
	FOREIGN KEY (id_merchant) REFERENCES merchant(id)
);

-- isolate (or group) the transactions of each cardholder
CREATE VIEW Card_Holders_Transactions AS
SELECT card_holder.name, transaction.date, transaction.amount, credit_card.card, merchant.name AS merchant, merchant_category.name AS category
FROM transaction 
JOIN credit_card ON credit_card.card = transaction.card
JOIN card_holder ON card_holder.id = credit_card.cardholder_id
JOIN merchant ON merchant.id = transaction.id_merchant
jOIN merchant_category ON merchant_category.id = merchant.id_merchant_category

ORDER BY card_holder.name

--Count the transactions that are less than $2.00 per cardholder
CREATE VIEW Under_2_transactions AS
SELECT * FROM transaction
WHERE transaction.amount < 2.00
ORDER BY card, amount DESC

CREATE VIEW Count_2_Transactions AS
SELECT COUNT(transaction.amount) AS "Transaction less than $2"
FROM transaction
WHERE transaction.amount < 2.00

--top 100 highest transactions made between 7:00 am and 9:00 am
CREATE VIEW Transaction_7_TO_9 AS
SELECT * FROM transaction
WHERE DATE_PART('hour',transaction.date) >= 7 AND DATE_PART('hour', transaction.date) <= 9
ORDER BY amount DESC
LIMIT 100

--transactions made between 7:00 am and 9:00 am under $2.00
CREATE VIEW Transaction_Under_2_From_7_tO_9 AS
SELECT COUNT (amount) AS "Transaction less than 2 from 7 to 9"
FROM transaction 
WHERE amount < 2 AND DATE_PART('hour',transaction.date) >= 7 AND DATE_PART('hour', transaction.date) <= 9

--top 5 merchants prone to being hacked using small transactions
CREATE VIEW Top_5_Merchants_Hacked AS
SELECT merchant.name AS merchant, merchant_category.name AS category, 
COUNT(transaction.amount) AS transactions
FROM transaction
JOIN merchant ON merchant.id = transaction.id_merchant
JOIN merchant_category ON merchant_category.id = merchant.id_merchant_category
WHERE transaction.amount < 2
GROUP BY merchant.name, merchant_category.name
ORDER BY transactions DESC
LIMIT 5

SELECT *
FROM transaction
WHERE card IN
  (
    SELECT card
    FROM credit_card
    WHERE cardholder_id = 2 
    
  )
  
 
 SELECT *
FROM transaction
WHERE card IN
  (
    SELECT card
    FROM credit_card
    WHERE cardholder_id = 18 
    
  )
  