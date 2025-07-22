-- Student Information System: Step-by-Step Guide for MySQL Workbench
--  Setting up the Database
create database if not exists Student_Information;

-- Using the database;
use Student_Information;

-- Creating 'Students' Table
create table Students
(Student_ID int primary key auto_increment,
First_Name varchar(100) not null,
Last_Name varchar(100) not null,
DOB Date,
Email varchar(250) unique not  null
);

-- Creating 'Courses' Table
create table Courses
(Course_ID int primary key auto_increment,
Course_Name varchar(250) not null,
Course_Code varchar(20) unique not null,
Credits int not null
);

-- Creating 'Enrollments' Table
create table Enrollments 
( Enrollment_ID int primary key auto_increment,
Student_ID int not null,
Course_ID int not null,
Enrollment_Date Date not null, 
Foreign key(Student_ID) references Students(Student_ID),
Foreign key(Course_ID) references Courses(Course_ID),
Unique (Student_ID, Course_ID)                                -- Ensures a student can only enroll in a course once
);

-- Create 'Grades' Table
create table Grades
( Grade_ID int primary key auto_increment,
Enrollment_ID int not null,
Grade varchar(2) not null,
Grade_Date Date not null,
foreign key(Enrollment_ID) references Enrollments(Enrollment_ID)
);

-- Inserting into 'Students' Table
insert into Students (First_Name, Last_Name, DOB, Email)
values ('Alice', 'Smith', '2000-01-15', 'alice.smith@example.com'),
('Bob', 'Johnson', '1999-05-20', 'bob.johnson@example.com'),
('Charlie', 'Brown', '2001-11-01', 'charlie.brown@example.com');

-- Reading 'Students' Table
select * from Students;

select * from Students 
where Email = 'alice.smith@example.com';

-- Updating a record in 'Students' Table
update Students 
set Email = 'alice.s@example.com' 
where Student_ID = 1;

-- Delete a student (ensure no enrollments or grades are linked to this student first, or handle ON DELETE CASCADE)
delete from Students 
where Student_ID =  3;

-- Insserting into 'Courses' Table
insert into Courses (Course_Name, Course_Code, Credits)
values ('Introduction to Programming', 'CS101', 3),
('Database Management Systems', 'CS205', 4),
('Calculus I', 'MA101', 3);

-- Reading 'Courses' Table
select * from Courses;

select * from Courses
where Course_Code = 'CS101';

-- Updating a record in 'Courses' Table
update Courses
set Credits = 5
where Course_ID = 2;

-- Delete a course (ensure no enrollments are linked to this course first)
delete from Courses
where Course_ID = 3;

-- Inserting into 'Enrollments' Table
-- Alice enrolls in CS101 (student_id 1, course_id 1)
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2024-09-01');

-- Bob enrolls in CS101 (student_id 2, course_id 1)
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES
(2, 1, '2024-09-01');

-- Alice enrolls in CS205 (student_id 1, course_id 2)
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES
(1, 2, '2024-09-05');

-- Reading from 'Enrollments'
select * from Enrollments;

select S.First_Name, S.Last_Name, 
C.Course_Name, C.Course_Code,
E.Enrollment_Date
from Enrollments as E
inner join Students as S 
on E.Student_ID = S.Student_ID
inner join Courses as C
on E.Course_ID = C.Course_ID
where S.Student_ID = 1;

-- Update enrollment date (uncommon, but possible)
UPDATE Enrollments 
SET enrollment_date = '2024-09-02' 
WHERE enrollment_id = 1;

-- Delete a specific enrollment record (ensure no grades are linked to this enrollment first)
DELETE FROM Enrollments 
WHERE enrollment_id = 3;

-- Inserting into 'Grades' Table
-- Alice gets an A in CS101 (enrollment_id 1)
INSERT INTO Grades (enrollment_id, grade, grade_date) VALUES
(1, 'A', '2024-12-15');

-- Bob gets a B in CS101 (enrollment_id 2)
INSERT INTO Grades (enrollment_id, grade, grade_date) VALUES
(2, 'B', '2024-12-16');

-- Selecting 'Grades' Table
select * from Grades;

select S.First_Name, S.Last_Name, 
C.Course_Name, C.Course_Code, 
G.Grade, G.Grade_Date
from Grades as G
inner join Enrollments as E
on G.Enrollment_ID = E.Enrollment_ID
inner join Students as S
on E.Student_ID = S.Student_ID
inner join Courses as C
on E.Course_ID = C.Course_ID
where E.Enrollment_ID = 1;

-- Update a student's grade
UPDATE Grades 
SET grade = 'A+' 
WHERE grade_id = 1;

-- Delete a specific grade record
DELETE FROM Grades 
WHERE grade_id = 2;

-- ---------------------
## Queries

-- Query 1: Query to add a new student:
INSERT INTO Students (first_name, last_name, DOB, email) 
VALUES ('Diana', 'Prince', '2002-03-10', 'diana.p@example.com');

-- Query 2: Query to enroll a student in a course:
-- Enroll Diana (student_id 4) in Database Management Systems (course_id 2)
INSERT INTO Enrollments (student_id, course_id, enrollment_date) 
VALUES (4, 2, '2025-01-20');

-- Query 3: Query to assign a grade to an enrollment:
-- Assign a grade of 'B+' to Diana's enrollment in CS205 (assuming enrollment_id 4 for the above enrollment)
INSERT INTO Grades (enrollment_id, grade, grade_date) 
VALUES (4, 'B+', '2025-05-25');

-- Query 4: Query to retrieve a student's transcript (all courses and grades):
select S.First_Name, S.Last_Name, 
C.Course_Name, C.Course_Code, C.Credits,
G.Grade, G.Grade_Date, 
E.Enrollment_Date
from Students as S
inner join Enrollments as E
on S.Student_ID = E.Student_ID
inner join Courses as C
on E.Course_ID = C.Course_ID
left join Grades as G
on G.Enrollment_ID = E.Enrollment_ID
where S.Student_ID = 1;

-- Dropping the database
drop database Student_Information;

-- ------------------------X----------------------
