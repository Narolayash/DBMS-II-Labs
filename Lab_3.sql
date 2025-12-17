--Part – A 
--1.	Create a stored procedure that accepts a date and returns all faculty members who joined on that date.
GO
CREATE OR ALTER PROCEDURE PR_FACULTY_MEM_JOINDATE
@DATE DATE
AS
BEGIN 

	SELECT *
	FROM FACULTY
	WHERE FacultyJoiningDate = @DATE;
END
GO

EXEC PR_FACULTY_MEM_JOINDATE '2010-07-15';


--2.	Create a stored procedure for ENROLLMENT table where user enters either StudentID or CourseID and returns EnrollmentID, EnrollmentDate, Grade, and Status.
GO
CREATE OR ALTER PROCEDURE PR_STUID_COURID_INFO
@StdID INT =NULL,
@CouID VARCHAR(10) =NULL
AS 
BEGIN
	SELECT EnrollmentID, EnrollmentDate, Grade, EnrollmentStatus
	FROM ENROLLMENT
	WHERE StudentID = @StdID OR CourseID = @CouID;
END
GO

EXEC PR_STUID_COURID_INFO 5;
EXEC PR_STUID_COURID_INFO @couID = 'CS101';


--3.	Create a stored procedure that accepts two integers (min and max credits) and returns all courses whose credits fall between these values.
GO
CREATE OR ALTER PROC PR_BET_MIN_MAX
@min INT,
@max INT
AS
BEGIN
	SELECT *
	FROM COURSE
	WHERE CourseCredits BETWEEN @min AND @max;
END
GO

EXEC PR_BET_MIN_MAX 3, 4;


--4.	Create a stored procedure that accepts Course Name and returns the list of students enrolled in that course.
GO
CREATE OR ALTER PROC PR_COURSNAME_STUIT
	@Cname VARCHAR(100)
AS
BEGIN 
	SELECT S.StuName 
	FROM STUDENT S
	JOIN ENROLLMENT E
	ON S.StudentID = E.StudentID
	JOIN COURSE C
	ON C.CourseID = E.CourseID
	WHERE CourseName = @Cname;
END
GO

EXEC PR_COURSNAME_STUIT 'Programming Fundamentals';


--5.	Create a stored procedure that accepts Faculty Name and returns all course assignments.
GO
CREATE OR ALTER PROC PR_FACULTY_COU_LIST
	@Fname VARCHAR(100)
AS
BEGIN 
	SELECT C.CourseName,  F.FacultyName
	FROM COURSE C
	JOIN COURSE_ASSIGNMENT CA
	ON C.CourseID = CA.CourseID
	JOIN FACULTY F
	ON F.FacultyID = CA.FacultyID
	WHERE F.FacultyName = @Fname;
END
GO

SELECT * FROM COURSE
SELECT * FROM FACULTY

EXEC PR_FACULTY_COU_LIST 'Prof. Gupta';


--6.	Create a stored procedure that accepts Semester number and Year, and returns all course assignments with faculty and classroom details.
GO
CREATE OR ALTER PROC PR_SEM_YEAR_FAC_CLASS
@sam INT,
@year INT
AS
BEGIN
	SELECT F.FacultyName, CA.ClassRoom
	FROM COURSE_ASSIGNMENT CA
	JOIN FACULTY F
	ON F.FacultyID = CA.FacultyID
	WHERE CA.Semester = @sam AND CA.Year = @year;
END
GO

EXEC PR_SEM_YEAR_FAC_CLASS 3, 2024



--Part – B 
--7.	Create a stored procedure that accepts the first letter of Status ('A', 'C', 'D') and returns enrollment details.
GO
CREATE OR ALTER PROC PR_A_C_D
	@stu	CHAR(1)
AS
BEGIN 
	SELECT * 
	FROM ENROLLMENT
	WHERE EnrollmentStatus LIKE @stu+'%';
END
GO

EXEC PR_A_C_D 'A'


--8.	Create a stored procedure that accepts either Student Name OR Department Name and returns student data accordingly.
GO
CREATE OR ALTER PROC PR_STUNAME_STDDEP_DATA
	@stuName	VARCHAR(100)	=NULL,
	@dept		VARCHAR(100)	=NULL
AS
BEGIN
	SELECT * 
	FROM STUDENT
	WHERE StuName = @stuName OR StuDepartment = @dept;
END
GO

EXEC PR_STUNAME_STDDEP_DATA 'Raj Patel';
EXEC PR_STUNAME_STDDEP_DATA @dept = 'CSE';


--9.	Create a stored procedure that accepts CourseID and returns all students enrolled grouped by enrollment status with counts.
GO
CREATE OR ALTER PROC PR_CouID_EnROllStus_COUNT
	@cID	VARCHAR(10)
AS
BEGIN 
	SELECT E.EnrollmentStatus, COUNT(*)
	FROM COURSE C
	JOIN ENROLLMENT E
	ON C.CourseID = E.CourseID
	WHERE C.CourseID = @cID
	GROUP BY E.EnrollmentStatus;
END
GO

EXEC PR_CouID_EnROllStus_COUNT 'CS101'	
--Part – C 
--10.	Create a stored procedure that accepts a year as input and returns all courses assigned to faculty in that year with classroom details.
GO
CREATE OR ALTER PROC PR_Year_Courses
	@y INT
AS
BEGIN
	SELECT C.CourseName, CA.ClassRoom
	FROM COURSE C
	JOIN COURSE_ASSIGNMENT CA
	ON C.CourseID = CA.CourseID
	WHERE CA.Year = @y;
END
GO

EXEC PR_Year_Courses 2024


--11.	Create a stored procedure that accepts From Date and To Date and returns all enrollments within that range with student and course details.
GO
CREATE OR ALTER PROC PR_ToDate
	@fromDare DATE,
	@toDate DATE
AS 
BEGIN
	SELECT S.StuName, C.CourseName
	FROM STUDENT S
	JOIN ENROLLMENT E
	ON S.StudentID = E.StudentID
	JOIN COURSE C
	ON C.CourseID = E.CourseID
	WHERE E.EnrollmentDate BETWEEN @fromDare AND @toDate
END
GO

EXEC PR_ToDate '2021-01-01', '2021-12-31'


--12.	Create a stored procedure that accepts FacultyID and calculates their total teaching load (sum of credits of all courses assigned).
GO
CREATE OR ALTER PROC PR_Fact_Teach_Load
	@factID INT,
	@load INT OUT
AS
BEGIN
	SELECT @load = SUM(C.CourseCredits)
	FROM FACULTY F
	JOIN COURSE_ASSIGNMENT CA
	ON F.FacultyID = CA.FacultyID
	JOIN COURSE C
	ON C.CourseID = CA.CourseID
	WHERE F.FacultyID = @factID;
END
GO

DECLARE @Tload INT
EXEC PR_Fact_Teach_Load 101, @Tload OUT;
SELECT @Tload
