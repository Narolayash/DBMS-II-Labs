--Part – A 

SELECT * FROM STUDENT;
--1.	INSERT Procedures: Create stored procedures to insert records into STUDENT tables (SP_INSERT_STUDENT)
--StuID	Name	Email	Phone	Department	DOB	EnrollmentYear
--10	Harsh Parmar	harsh@univ.edu	9876543219	CSE	2005-09-18	2023
--11	Om Patel	om@univ.edu	9876543220	IT	2002-08-22	2022
GO
CREATE OR ALTER PROC PR_INSERT_STUDENT
@Id int,
@Name VARCHAR(100),
@Email VARCHAR(100),
@Phone VARCHAR(15),
@Department VARCHAR(50),
@DOB DATE,
@EnYear int
AS
BEGIN 
	INSERT INTO STUDENT (StudentID, StuName, StuEmail, StuPhone, StuDepartment, StuDateOfBirth, StuEnrollmentYear) VALUES
	(@Id, @Name, @Email, @Phone, @Department, @DOB, @EnYear)
END
GO

EXEC PR_INSERT_STUDENT 10, 'Harsh Parmar', 'harsh@univ.edu', '9876543219', 'CSE', '2005-09-18', 2023;
EXEC PR_INSERT_STUDENT 11, 'Om Patel', 'om@univ.edu', '9876543220', 'IT', '2002-08-22', 2022;


--2.	INSERT Procedures: Create stored procedures to insert records into COURSE tables 
--(SP_INSERT_COURSE)
--CourseID	CourseName	Credits	Dept	Semester
--CS330	Computer Networks	4	CSE	5
--EC120	Electronic Circuits	3	ECE	2
GO
CREATE OR ALTER PROC PR_INSRT_COURSE 
@ID VARCHAR(10),
@Name VARCHAR(100),
@Credit int,
@Department VARCHAR(50),
@Sem int
AS
BEGIN
	INSERT INTO COURSE VALUES 
	(@ID, @Name, @Credit, @Department, @Sem);
END
GO

EXEC PR_INSRT_COURSE 'CS330', 'Computer Networks', 4, 'CSE', 5;
EXEC PR_INSRT_COURSE 'EC120', 'Electronic Circuits', 3, 'ECE', 2;


--3.	UPDATE Procedures: Create stored procedure SP_UPDATE_STUDENT to update Email 
-- and Phone in STUDENT table. (Update using studentID)
GO
CREATE OR ALTER PROC PR_UPDATE_STUDENT
@Id INT,
@Email VARCHAR(100),
@Phone VARCHAR(15)
AS 
BEGIN
	UPDATE STUDENT
	SET StuEmail = @Email, StuPhone = @Phone
	WHERE StudentID = @Id;
END
GO


--4.	DELETE Procedures: Create stored procedure SP_DELETE_STUDENT to delete 
-- records from STUDENT where Student Name is Om Patel.
GO
CREATE OR ALTER PROC PR_DELETE_STUDENT
AS
BEGIN
	DELETE STUDENT
	WHERE StuName = 'Om Patel';
END
GO

EXEC PR_DELETE_STUDENT;


--5.	SELECT BY PRIMARY KEY: Create stored procedures to 
-- select records by primary key (SP_SELECT_STUDENT_BY_ID) from Student table.
GO
CREATE OR ALTER PROC PR_SELECT_STUDENT_BY_ID
@ID INT
AS
BEGIN
	SELECT * FROM STUDENT
	WHERE StudentID = @ID;
END
GO

EXEC PR_SELECT_STUDENT_BY_ID 5;
EXEC PR_SELECT_STUDENT_BY_ID 50;


--6.	Create a stored procedure that shows details of the first 5 students ordered by EnrollmentYear.
GO
CREATE OR ALTER PROC FIRST_5_ORD_ENROYEAR
@N INT
AS
BEGIN
	SELECT TOP (@N) StuName
	FROM STUDENT
	ORDER BY StuEnrollmentYear;
END
GO

EXEC FIRST_5_ORD_ENROYEAR 5;



--Part – B  
--7.	Create a stored procedure which displays faculty designation-wise count.
GO
CREATE OR ALTER PROC FACU_DEDI_WISE
AS
BEGIN
	SELECT FacultyDesignation, COUNT(FacultyID)
	FROM FACULTY
	GROUP BY FacultyDesignation;
END
GO

EXEC FACU_DEDI_WISE;


--8.	Create a stored procedure that takes department name as input and returns all students in that department.
GO
CREATE OR ALTER PROC SP_STU_IN_THAT_DEPARMENT 
@Dept VARCHAR(50)
AS
BEGIN
	SELECT * 
	FROM STUDENT
	WHERE StuDepartment = @Dept;
END
GO

EXEC SP_STU_IN_THAT_DEPARMENT 'CSE';



--Part – C 
--9.	Create a stored procedure which displays department-wise maximum, minimum, and average credits of courses.
GO
CREATE OR ALTER PROC SP_DEPT_MAX_MIN_AVG_CREDIT
AS
BEGIN
	SELECT CourseDepartment, MAX(CourseCredits) AS MAX, MIN(CourseCredits) AS MIN, AVG(CourseCredits) AS AVG
	FROM COURSE
	GROUP BY CourseDepartment
END
GO

EXEC SP_DEPT_MAX_MIN_AVG_CREDIT;


--10.	Create a stored procedure that accepts StudentID as parameter and 
-- returns all courses the student is enrolled in with their grades.
GO
CREATE OR ALTER PROC SP_STDID_GRADS
@ID INT
AS
BEGIN
	SELECT StuName, CourseName, Grade
	FROM STUDENT
	JOIN ENROLLMENT
	ON STUDENT.StudentID = ENROLLMENT.StudentID
	JOIN COURSE
	ON COURSE.CourseID = ENROLLMENT.CourseID
	WHERE STUDENT.StudentId = @ID;
END
GO

EXEC SP_STDID_GRADS 1;
