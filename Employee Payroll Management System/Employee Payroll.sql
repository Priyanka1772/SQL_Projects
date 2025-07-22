-- Employee Payroll Management System: Step-by-Step Guide for MySQL Workbench
-- Setting up the Database
-- Creating a database
create database if not exists Payroll_DB;

-- Using the database
use Payroll_DB;

-- Creating 'Departments' Table
create table Departments 
( Dept_ID int primary key auto_increment,
Dept_Name varchar(255) not null unique
);

-- Creating 'Employees' Table
create table Employees
( Emp_ID int primary key auto_increment,
First_Name char(10) not null, 
Last_Name char(10) not null,
Email varchar(50) unique not null,
Phone_No varchar(20),
Hire_Date date not null,
Job_Title varchar(255),
Dept_ID int,
foreign key(Dept_ID) references Departments(Dept_ID)
);

-- Creating 'Salaries' Table
create table Salaries
( Salary_ID int primary key auto_increment,
Emp_ID int not null,
Base_Salary decimal(10, 2) not null,
Bonus decimal(10, 2) default 0.00,
Deductions decimal(10, 2) default 0.00,
Pay_Date date not null,
foreign key(Emp_ID) references Employees(Emp_ID)
);

-- Inserting into 'Departments' Table
INSERT INTO Departments (Dept_Name) 
VALUES ('Human Resources'), ('Engineering'), ('Sales'), ('Marketing');

-- Viewing 'Departments' Table
-- Selecting all departments
SELECT * FROM Departments;

-- Selecting a specific department by name
SELECT * FROM Departments 
WHERE Dept_Name = 'Engineering';

-- Updating a department name
UPDATE Departments 
SET Dept_Name = 'R&D' 
WHERE Dept_ID = 2;

-- Deleting a department (ensure no employees are linked to this department first, or handle ON DELETE CASCADE)
DELETE FROM Departments 
WHERE Dept_ID = 4;

-- Inserting into 'Employees' Table
INSERT INTO Employees (First_Name, Last_Name, Email, Phone_No, Hire_Date, Job_Title, Dept_ID) 
VALUES
('Alice', 'Smith', 'alice.s@example.com', '555-1111', '2022-01-10', 'HR Manager', 1),
('Bob', 'Johnson', 'bob.j@example.com', '555-2222', '2021-03-15', 'Software Engineer', 2),
('Charlie', 'Brown', 'charlie.b@example.com', '555-3333', '2023-06-01', 'Sales Representative', 3);

-- Viewing 'Employees' Table
-- Selecting all employees
SELECT * FROM Employees;

-- Selecting employees with their department names (using JOIN)
SELECT E.first_name, E.last_name, E.job_title, D.Dept_Name, E.hire_date
FROM Employees AS E
JOIN Departments AS D 
ON E.Dept_ID = D.Dept_ID;

-- Updating an employee's job title
UPDATE Employees 
SET job_title = 'Senior Software Engineer' 
WHERE Emp_ID = 2;

-- Change an employee's department
UPDATE Employees 
SET Dept_ID = 1 
WHERE Emp_ID = 4;                      -- Move Diana to HR

-- Deleting an employee (ensure no salary records are linked to this employee first)
DELETE FROM Employees 
WHERE Emp_ID = 4;

-- Inserting into 'Salary' Table
-- Alice's salary (employee_id 1)
INSERT INTO Salaries (Emp_ID, base_salary, bonus, deductions, pay_date) 
VALUES
(1, 60000.00, 500.00, 200.00, '2024-07-20'),
(1, 60000.00, 0.00, 200.00, '2024-08-20');

-- Bob's salary (employee_id 2)
INSERT INTO Salaries (Emp_ID, base_salary, bonus, deductions, pay_date) VALUES
(2, 80000.00, 1000.00, 300.00, '2024-07-20');

-- Charlie's salary (employee_id 3)
INSERT INTO Salaries (Emp_ID, base_salary, bonus, deductions, pay_date) VALUES
(3, 50000.00, 200.00, 150.00, '2024-07-20');

-- Viewing 'Salary' Table
-- Select all salary records
SELECT * FROM Salaries;

-- Select an employee's salary history with their name
SELECT    E.first_name, E.last_name, 
S.base_salary, S.bonus, S.deductions, S.pay_date,
    (S.base_salary + S.bonus - S.deductions) AS net_pay
FROM Salaries AS S
JOIN Employees AS E ON S.Emp_ID = E.Emp_ID
WHERE E.Emp_ID = 1
ORDER BY S.pay_date DESC;

-- Updating a specific salary entry (e.g., correct a bonus)
UPDATE Salaries 
SET bonus = 750.00 
WHERE salary_id = 1;

-- Deleting a specific salary record
DELETE FROM Salaries 
WHERE salary_id = 2;

-- ---------------------
## Queries

-- Query 1: Query to calculate net pay for all employees for a specific pay period
SELECT  E.Emp_ID, E.first_name, E.last_name, E.job_title,
    D.Dept_Name, S.base_salary, S.bonus, S.deductions,
    (S.base_salary + S.bonus - S.deductions) AS net_pay, S.pay_date
FROM Salaries AS S
JOIN Employees AS E 
ON S.Emp_ID = E.Emp_ID
JOIN Departments AS D 
ON E.Dept_ID = D.Dept_ID
WHERE S.pay_date = '2024-07-20';                    -- Specify the desired pay date

-- Query 2: Query to generate a total payroll report per department for a specific month
SELECT D.Dept_Name, SUM(S.base_salary + S.bonus - S.deductions) AS TotalDepartmentPayroll
FROM Salaries AS S
JOIN Employees AS E 
ON S.Emp_ID = E.Emp_ID
JOIN Departments AS D 
ON E.Dept_ID = D.Dept_ID
WHERE S.pay_date 
BETWEEN '2024-07-01' AND '2024-07-31'                -- Adjust date range for the month
GROUP BY D.Dept_Name
ORDER BY D.Dept_Name;

-- Query 3: Query to find employees who have not received a salary yet (or for a specific period)
SELECT E.Emp_ID, E.first_name, E.last_name, E.hire_date, D.Dept_Name
FROM Employees AS E
LEFT JOIN Salaries AS S 
ON E.Emp_ID = S.Emp_ID
AND S.pay_date = '2024-08-20'        -- Check for a specific pay date
JOIN Departments AS D 
ON E.Dept_ID = D.Dept_ID
WHERE S.salary_id IS NULL; -- If salary_id is NULL, they haven't received pay for this date

-- Dropping the database
drop database Payroll_DB;

-- ------------------------X----------------------