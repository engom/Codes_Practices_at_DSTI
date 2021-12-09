--
/* DML EXERCICES */
--
CREATE TABLE employee2
(
    id INT NOT NULL,
    lastName VARCHAR(25),
    firstName VARCHAR(25),
    userID VARCHAR(8),
    Salary DECIMAL(9,2)
);

-- 1) Add the following employees to the table 
INSERT INTO employee2 
    (id, firstName, lastName, Salary)
VALUES (1, 'Emerick', 'DUVAL', 3200)

INSERT INTO employee2 
    (id, firstName, lastName, Salary)
VALUES (2, 'Anna', 'DUPONT', 4300)

INSERT INTO employee2 
    (id, firstName, lastName, Salary)
VALUES (3, 'Antoine', 'DUPUY', 2200)

INSERT INTO employee2 
    (id, firstName, lastName, Salary)
VALUES (4, 'Jérémy', 'DURANT', 1600)

INSERT INTO employee2 
    (id, firstName, lastName, Salary)
VALUES (5, 'Julie', 'DUMONT', 3800)

INSERT INTO employee2 
    (id, firstName, lastName, Salary)
VALUES (6, 'Léo', 'DUBOIS', 3650)

-- 2) Add the following employees to the table 

UPDATE employee2
SET userID = SUBSTRING(firstName, 1, 3) + SUBSTRING(lastName, 1, 5)

-- second way to do it:

UPDATE employee2
SET userID = SUBSTRING(firstName, 1, 3) + LEFT(lastName, 5)

-- 3) Change the salary of Jérémy DURANT to match Anna Dupont's 
UPDATE employee2
SET Salary = (SELECT Salary
                FROM employee2
                WHERE firstName = 'Anna'
                AND lastName = 'DUPON')
-- WHERE Salary = 

-- 4) Raise by 10 percent the salary of each employee that has a "o" in its first_name
UPDATE employee2
SET Salary = Salary*1.1
WHERE lastName LIKE '%O%'

-- 5) Remove any employee whose salary is below the average salary
DELETE FROM employee2
WHERE Salary < (SELECT AVG(Salary) FROM employee2)

-- Anna's lastName
UPDATE employee2
SET lastName = 'DUPONT'
WHERE firstName = 'Anna'

-- Look what happen on your table 
SELECT *
FROM employee2
------------------------------------End of the Exercise-------------------------------------------------------

/* +++++++++++++++++++++++++++++++++++++++++++ TRANSACTIONS +++++++++++++++++++++++++*+++++++++++++++++++++++ */
------- User A ----------> update a row,
------- User B ----------> update a row (maybe the same as user A).
-- Suppose they work on the same table at same moment: 
-- If two transations come from A and B, the first occurs while the second stays in lock (like a one man queue).
-- Rowback to release to fix the lock.  Il users updates wait each other, then there is a DEADLOCK.

-- 

CREATE TABLE Employees
(
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirtthDate DATE,
    Salary DECIMAL(6,2)
);
-- DECIMAL(num_total_digit, num_digit_after_point)

-- ADD THE EMAIL with ALTER method 
ALTER TABLE Employees
ADD  Email VARCHAR(70);

-- CHANGE datatype of the email colomn
ALTER TABLE Employees
ALTER COLUMN Email VARCHAR(100);

-- Delete a column 
ALTER TABLE Employees
DROP COLUMN salary;

-- ADD A COLUMN
ALTER TABLE Employees
ADD AnnualSalary DECIMAL(6, 2) NOT NULL;

-- INSERT A ROW 
INSERT INTO Employees
(EmployeeID, FirstName, LastName, BirtthDate, Email, AnnualSalary)
VALUES
(1, 'Elhadji', 'Ngom', '01/06/1996', 'samaemail@sql.mail', 3000.00);

-- INSERT A ROW 
INSERT INTO Employees
(EmployeeID, FirstName, LastName, BirtthDate, Email, AnnualSalary)
VALUES
(2, 'Stéphane', 'Ganhi', '04/05/1986', 'sonemail@sql.mail', 4000.00);

--- 
SELECT *
FROM Employees;

/* ============================================ KEYS & CONSTRAINTS ================================================= */
--==== PRIMARY KEY To ADD CONSTRAINT

-- Need to set EmplyeeID column to not null (Otherwise it does not work)
ALTER TABLE Employees
ALTER COLUMN EmployeeID INT NOT NULL;

-- ADIING Primary to an existing table with CONSTAINT Name
ALTER TABLE Employees
ADD CONSTRAINT PK_Employees_EmployeeID PRIMARY KEY (EmployeeID);

-- Remove the constraint ceated 
ALTER TABLE Employees
DROP CONSTRAINT PK_Employees_EmployeeID;

-- Add Primary without maning it --- not a good habit
ALTER TABLE Employees
ADD PRIMARY KEY (EmployeeID);


--== FOREIGN KEY

-- Create a new departement table to add foreign key 
CREATE TABLE Departements
 (
    DepartementID INT PRIMARY KEY,
    DepartementName VARCHAR(50),
 );

-- ADD two row into Departements table
 INSERT INTO Departements
 (DepartementID, DepartementName)
 VALUES
 (1, 'Mathmatiques-Informatique')

 INSERT INTO Departements
 (DepartementID, DepartementName)
 VALUES
 (3, 'Biologie')
 GO

-- Add e DepID column in Employees
 ALTER TABLE Employees
 ADD DepID INT;

 -- ADIING Foreign Primary to an existing table with CONSTAINT Name
ALTER TABLE Employees
ADD CONSTRAINT FK_Emp_DepID
        FOREIGN KEY (DepID)
            REFERENCES Departements(DepartementID);

-- Display the Departements table
SELECT * 
FROM
    Departements;

-- Insert a new row into Employees having DepId as FK now 
INSERT INTO Employees
(EmployeeID, FirstName, LastName, BirtthDate, Email, AnnualSalary, DepID)
VALUES
(3, 'Hamidou', 'Thiam', '04/05/1990', 'seneemail@sql.mail', 3000.00, 1);

-- Display the Employees 
SELECT * 
FROM
    Employees;

-- Adding a named CHECK constraint to prevent negative salaries
ALTER TABLE Employees
ADD CONSTRAINT CK_salary_positive CHECK (AnnualSalary >= 0);

/* ++++++++++++++++++++++++++ VIEWS +++++++++++++++++++++++++++++++*/
--Create a view that stores a query
CREATE VIEW V_SalesByYearAndRegien
AS
    SELECT 
    YEAR(OrderDate) AS OrderYear,
    RegionName AS Region,
    SUM(UnitPrice*Quantity) AS TotatSaleAmount
    FROM Sales sa 
    JOIN [State] st 
        ON sa.CustomerStateID = StateID
    JOIN Region r 
        ON st.RegionID = r.RegionID
    GROUP BY YEAR(OrderDate), RegionName;


-- It behaves like a table 
-- Display the view 
SELECT *
FROM V_SalesByYearAndRegien;

SELECT *
FROM vSalesExtract;