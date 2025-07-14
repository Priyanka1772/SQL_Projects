-- Creating a database
create database if not exists Library_DB;

-- Using the database ad the default
use Library_DB;

-- Creating 'Authors' table
create table Authors 
( Author_ID int primary key auto_increment,
Author_Name varchar(250) not null
);

-- Creating 'Books' table
create table Books
( Book_ID int primary key auto_increment,
Title varchar(250) not null,
Author_ID int not null,
Publication_Year int,
isbn varchar(20) unique not null,
Available_Copies int default 1,
foreign key (Author_ID) references Authors(Author_ID)
 );
 
 -- Creating 'Members' table
 create table Members
 ( Member_ID int primary key auto_increment,
 Member_Name varchar(250) not null, 
 Address varchar(250) , 
 Contact varchar(20)
  );
  
  -- Creating 'Loans' table
  create table Loans
  (Loan_ID int primary key auto_increment,
  Book_ID int not null,
  Member_ID int not null, 
  Loan_Date date not null, 
  Return_Date date,                                           -- 'null' if not returned
  foreign key (Book_ID) references Books(Book_ID),
  foreign key (Member_ID) references Members(Member_ID)
  );
  
  -- Inserting data into 'Authors' table
  insert into Authors(Author_Name)
  values ('Robert Greene'), ('Jane Austen');
  
  insert into Authors(Author_Name)
  values ('George Orwell'), ('Harper Lee'), ('Sylvia Plath'), ('Osho'), ('Yuval Noah Harrari'), ('Jordan B. Peterson'), ('Sahadat Hasan Manto'), ('Fyodor Dostoyevsky');
  
  -- Viewing data 'Authors' table
  select * from Authors;
  
  -- Updating data 'Authors' table
  update Authors set Author_Name = 'George O. Orwell'
  where Author_ID = 3;
  
  -- Deleting data 'Authors' table
  delete from Authors
  where Author_ID = 4;
  
  -- Inserting data into 'Books' table
  insert into Books(Title, Author_ID, Publication_Year, isbn, Available_Copies)
  value ('Pride and Prejudice', 2, 1813, '978-0141439518', 3);
  
  insert into Books(Title, Author_ID, Publication_Year, isbn, Available_Copies)
  values ('48 Laws of Power', 1, 1998, '978-0141439519', default);

insert into Books(Title, Author_ID, Publication_Year, isbn, Available_Copies)
values ('1984', 3, 1984, '978-0141439520', 5),
('The Bell Jar', 5, 1963, '978-0141439521', 8),
('The Diamond Sword', 6, 2017, '978-0141439522', 20)
;

  -- Viewing data 'Books' table
  select * from Books;
  
  -- Viewing books by title
  select * from Books 
  where title like 'The%';

-- Viewing books with Author names (using JOIN)
select B.Title, B.Publication_Year, B.isbn, B.Available_Copies, A.Author_Name
from Books as B
inner join Authors as A
on B.Author_ID = A.Author_ID;
   
-- Update the number of copies for a book
update Books 
set Available_Copies = 10
where Book_ID = 6;
  
-- Update a book's title
update Books
set Title = 'The 48 Laws of Power'
where Book_ID = 3;

-- Delete a book (ensure no active loans for this book first)
delete from Books
where Book_ID = 4;

-- Inserting values into Members table
insert into Members (Member_name, Address, Contact)
value ('Alice Smith', '123 Main St, Anytown', '555-1111');

insert into Members (Member_Name, Address, Contact)
values ('Bob Johnson', '456 Oak Ave, Otherville', '555-2222'),
('Charlie Brown', '789 Pine Ln, Somewhere', '555-3333');

-- Viweing the data in Members table
select * from Members;

-- Updating data in Memebers table
update Members
set Contact = '555-1234'
where Member_ID = 3;

-- Alice borrows 'Pride and Prejudice'
insert into Loans (Book_ID, Member_ID, Loan_Date, Return_Date)
value (1, 1, '2025-07-01', NULL);

insert into Loans (Book_ID, Member_ID, Loan_Date, Return_Date)
values (2, 2, '2025-06-20', NULL);

-- Viewing the Loans table
select * from Loans;

-- Alice returns 'Pride and Prejudice'
-- This would be an UPDATE, not a new INSERT for the same loan
-- For demonstration, let's add another loan that's already returned
insert into Loans (Book_ID, Member_ID, Loan_Date, Return_Date)
values (3, 1, '2025-06-10', '2025-06-15');

-- Viewing active loans (not yet returned)
select * from Loans
where Return_Date is NULL;

-- Viewing all loan  details with Book and mmebers Names
select L.Loan_ID, B.Title as Book_Title, A.Author_Name, M.Member_Name, L.Loan_Date, L.Return_Date
from Loans as L
inner join Books as B on L.Book_ID = B.Book_ID
inner join Authors as A on B.Author_ID = A.Author_ID
inner join Members as M on L.Member_ID = M.Member_ID;

-- Mark a book as returned 
update Loans
set Return_Date = curdate() 
where Loan_ID = 2;

-- Also update the available copies in the Books table
update Books
set Available_Copies = Available_Copies + 1
where Book_ID = 2;

-- Delete a specific loan record
DELETE FROM Loans WHERE loan_id = 3;

-- ---------------------
## Queries

-- Queries to track borrowed books (currently out on loan):
select B.title as Book_Title, A.Author_Name as Author, M.Member_Name as BorrowedBy, L.Loan_Date as LoanDate
from Loans as L
inner join Books as B on L.Book_ID = B.Book_ID
inner join Authors as A on A.Author_ID = B.Author_ID
inner join Members as M on L.Member_ID = M.Member_ID
where L.Return_Date IS NULL;

-- Queries to track overdue books:
select B.Title as BookTitle, A.Author_Name as Author, M.Member_Name as BorrowedBy, L.Loan_Date as LoanDate
from Loans as L
inner join Books as B on B.Book_ID = L.Book_ID
inner join Authors as A on B.Author_ID = A.Author_ID
inner join Members as M on L.Member_ID = M.Member_ID
where L.Return_Date is null and datediff(curdate(), L.Loan_Date) > 14; -- Assuming a 14-day loan period

-- Queries to find books by a specific author:
select B.Title as BookTitle, B.Publication_Year, B.isbn, B.Available_Copies
from Books as B
inner join Authors as A on B.Author_ID = A.Author_ID
where A.Author_Name = 'Robert Greene'; -- Replace with the author you want to search for

-- ------------------------X----------------------