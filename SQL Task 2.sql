   # SQL TASK 2

CREATE DATABASE Project1;
USE Project1;

-- ORDERS,CUST,SALESPEOPLE ANALYSIS

-- Q1 # Create the Salespeople

CREATE TABLE Salespeople(
snum INT UNSIGNED,
sname VARCHAR(20),
city VARCHAR(20),
comm FLOAT(10,2),
CONSTRAINT PK_Salespeople PRIMARY KEY (snum)
);

INSERT INTO  SalesPeople  VALUES
(1001, 'Peel', 'London', '0.12') ,
(1002, 'Serres', 'San Jose', '0.13') ,
(1003, 'Axelrod', 'New york', '0.10') ,
(1004, 'Motika', 'London', '0.11') ,
(1007, 'Rafkin', 'Barcelona', '0.15');

SELECT * FROM salespeople;

-- Q2 #  Create the Cust Table 

CREATE TABLE Cust(
cnum INT UNSIGNED,
cname VARCHAR(20),
city VARCHAR(20),
rating INT UNSIGNED,
snum INT UNSIGNED,
CONSTRAINT PK_Cust PRIMARY KEY (cnum),
CONSTRAINT FK_Salespeople FOREIGN KEY (snum) REFERENCES Salespeople(snum)
);

INSERT INTO  Cust 
VALUES
(2001, 'Hoffman', 'London', 100, 1001) ,
(2002, 'Giovanne', 'Rome', 200, 1003) ,
(2003, 'Liu', 'San Jose', 300, 1002) ,
(2004, 'Grass', 'Berlin', 100, 1002) ,
(2006, 'Clemens', 'London', 300, 1007) ,
(2007, 'Pereira', 'Rome', 100, 1004) ,
(2008, 'James', 'London', 200, 1007) ;

SELECT * FROM Cust;

-- Q3 # Create orders table 

CREATE TABLE orders(
onum INT UNSIGNED,
amt FLOAT(10,2),
odate DATE,
cnum INT UNSIGNED,
snum INT UNSIGNED,
CONSTRAINT PK_orders PRIMARY KEY (onum),
CONSTRAINT FK_Salespeople1 FOREIGN KEY (snum) REFERENCES Salespeople(snum),
CONSTRAINT FK_Cust FOREIGN KEY (cnum) REFERENCES Cust(cnum)
);

INSERT INTO  orders ( onum  , amt  , odate  , cnum  , snum )  VALUES
(3001, '18.69', '1994-10-03', 2008, 1007) ,
(3002, '1900.10', '1994-10-03', 2007, 1004) ,
(3003, '767.19', '1994-10-03', 2001, 1001) ,
(3005, '5160.45', '1994-10-03', 2003, 1002) ,
(3006, '1098.16', '1994-10-04', 2008, 1007) ,
(3007, '75.75', '1994-10-05', 2004, 1002) ,
(3008, '4723.00', '1994-10-05', 2006, 1001) ,
(3009, '1713.23', '1994-10-04', 2002, 1003) ,
(3010, '1309.95', '1994-10-06', 2004, 1002) ,
(3011, '9891.88', '1994-10-06', 2006, 1001) ;

SELECT * FROM ORDERS;

-- Q4 # 	Write a query to match the salespeople to the customers according to the city they are living. 

SELECT SALESPEOPLE.SNAME,CUST.CNAME,SALESPEOPLE.CITY FROM SALESPEOPLE
INNER JOIN CUST 
ON SALESPEOPLE.CITY = CUST.CITY;

-- Q5 # Write a query to select the names of customers and the salespersons who are providing service to them.

SELECT SALESPEOPLE.SNAME,CUST.CNAME,CUST.SNUM
FROM SALESPEOPLE 
INNER JOIN CUST 
ON SALESPEOPLE.SNUM = CUST.SNUM;

-- Q6 #  Write a query to find out all orders by customers not located in the same cities as that of their salespeople

SELECT ONUM,CNAME,ORDERS.CNUM,ORDERS.SNUM
FROM SALESPEOPLE,CUST,ORDERS
WHERE CUST.CITY <> SALESPEOPLE.CITY
AND ORDERS.CNUM = CUST.CNUM
AND ORDERS.SNUM = CUST.SNUM;

-- Q7 # Write a query that lists each order number followed by name of customer who made that order

SELECT ONUM,CUST.CNAME FROM ORDERS,CUST
WHERE ORDERS.CNUM = CUST.CNUM
ORDER BY ONUM ASC;

-- Q8 # Write a query that finds all pairs of customers having the same rating

SELECT A.CNAME, B.CNAME, A.RATING 
FROM CUST A,CUST B
WHERE A.RATING = B.RATING 
AND A.CNUM > B.CNUM
ORDER BY RATING ASC;


-- Q9 # Write a query to find out all pairs of customers served by a single salesperson

SELECT A.CNAME, B.CNAME, S.SNAME
FROM CUST AS A, CUST AS B, SALESPEOPLE AS S 
WHERE A.SNUM = B.SNUM
AND A.SNUM = S.SNUM
AND A.CNAME <> B.CNAME;

-- Q 10 # Write a query that produces all pairs of salespeople who are living in same city

SELECT A.SNAME, B.SNAME, A.CITY
FROM SALESPEOPLE A, SALESPEOPLE B
WHERE A.CITY = B.CITY AND A.SNAME < B.SNAME;
 

-- Q11 # Write a Query to find all orders credited to the same salesperson who services Customer 2008

SELECT * FROM ORDERS
WHERE SNUM = (SELECT DISTINCT SNUM FROM ORDERS WHERE CNUM = 2008);

-- Q12 # Write a Query to find out all orders that are greater than the average for Oct 4th

SELECT * FROM ORDERS 
WHERE AMT > ( SELECT AVG(AMT) FROM ORDERS WHERE ODATE = '1994-10-04');

-- Q13 # Write a Query to find all orders attributed to salespeople in London.

SELECT * FROM ORDERS 
WHERE SNUM IN (SELECT SNUM FROM SALESPEOPLE WHERE CITY = 'LONDON');

-- Q14 # Write a query to find all the customers whose cnum is 1000 above the snum of Serres.

SELECT CNUM,CNAME FROM CUST
WHERE CNUM > (SELECT SNUM+1000 FROM SALESPEOPLE WHERE SNAME= 'SERRES');

-- Q15 # Write a query to count customers with ratings above San Jose’s average rating

SELECT COUNT(CNUM) FROM CUST 
WHERE RATING > (SELECT AVG(RATING) FROM CUST WHERE CITY = 'SAN JOSE');

-- Q16 # Write a query to show each salesperson with multiple customers.

SELECT SNUM, SNAME FROM SALESPEOPLE 
WHERE SNUM IN (SELECT SNUM FROM CUST GROUP BY SNUM HAVING COUNT(SNUM)>1);



