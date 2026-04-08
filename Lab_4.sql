--Part-A 
--1. Write a scalar function to print "Welcome to DBMS Lab". 
GO
CREATE OR ALTER FUNCTION FN_print_Welcome ()
RETURNS Varchar(100)
AS 
BEGIN
	RETURN 'Welcome to DBMS Lab'
END;
GO

SELECT dbo.FN_print_Welcome();

--2. Write a scalar function to calculate simple interest.
GO
CREATE OR ALTER FUNCTION FN_simple_interest ( 
	@P FLOAT,
	@T FLOAT,
	@R FLOAT
)
RETURNS FLOAT
AS 
BEGIN
	RETURN (@P * @T * @R) / 100;
END;
GO

SELECT dbo.FN_simple_interest(1000, 12, 15);

--3. Function to Get Difference in Days Between Two Given Dates 
GO
CREATE OR ALTER FUNCTION FN_diff_two_dates(
	@DATE1 DATE,
	@DATE2 DATE
)
RETURNS INT
AS
BEGIN
	RETURN DATEDIFF(day, @DATE1, @DATE2);
END;
GO

SELECT dbo.FN_diff_two_dates('2007-03-10', '2007-03-31');

--4. Write a scalar function which returns the sum of Credits for two given CourseIDs.
GO
CREATE OR ALTER FUNCTION FN_sumofCouserCredits(
	@courseID1 varchar(10),
	@courseID2 varchar(10)
)
RETURNS INT
AS
BEGIN 
	DECLARE @SUM INT = 0;
	SELECT @SUM = SUM(CourseCredits) FROM COURSE WHERE CourseID = @courseID1 or CourseID = @courseID2 ;
	RETURN @SUM
END;
GO

SELECT dbo.FN_sumofCouserCredits('CS101', 'CS201');

--5. Write a function to check whether the given number is ODD or EVEN. 
GO
CREATE OR ALTER FUNCTION FN_oddOrEven(
	@N INT
)
RETURNS varchar(10)
AS
BEGIN 
	IF @N % 2 = 0
		RETURN 'EVEN'

	RETURN 'ODD'
END
GO

SELECT dbo.FN_oddOrEven(10);
SELECT dbo.FN_oddOrEven(15);

--6. Write a function to print number from 1 to N. (Using while loop) 
GO
CREATE OR ALTER FUNCTION FN_print_1_to_N (
	@N INT
)
RETURNS VARCHAR(max)
AS
BEGIN 
	DECLARE @I INT = 1, @Print VARCHAR(max) = '';
		
	WHILE @I <= @N
		BEGIN
			SET @Print = @Print + CAST(@I as varchar) + ' ';
			SET @I = @I + 1
		END;
	RETURN @Print;
END
GO

SELECT dbo.FN_print_1_to_N(10);

--7. Write a scalar function to calculate factorial of credits for a given CourseID. 
GO
CREATE OR ALTER FUNCTION FN_fatorial_of_CourseCredit (
	@ID varchar(10)
)
RETURNS INT
AS
BEGIN 
	DECLARE @credit INT;
	SELECT @credit =  CourseCredits 
					FROM COURSE
						WHERE CourseID = @ID;

	DECLARE @FACTO INT = 1, @I INT = 1;
	WHILE @I <= @Credit
		BEGIN
			SET @FACTO = @FACTO * @I 
			SET @I = @I + 1;
		END;

	RETURN @FACTO;
END
GO

SELECT dbo.FN_fatorial_of_CourseCredit('CS101');

--8. Write a scalar function to check whether a given EnrollmentYear is in the past, current or future (Case 
--statement) 
GO
CREATE OR ALTER FUNCTION FN_Enroll_past_future_current (
	@Year INT
)
RETURNS VARCHAR(10)
AS 
BEGIN
	RETURN CASE
			WHEN @Year < YEAR(getdate()) THEN 'Past'
			WHEN @Year > YEAR(getdate()) THEN 'FUTURE'
			ELSE 'CURRENT'
		END
END
GO

SELECT dbo.FN_Enroll_past_future_current(2024);

--9. Write a table-valued function that returns details of students whose names start with a given letter.
GO
CREATE OR ALTER FUNCTION FN_stuName_letter (
	@letter char(1)
)
RETURNS TABLE 
AS 
	RETURN SELECT * 
		FROM STUDENT
		WHERE StuName LIKE @letter+'%';
GO

SELECT * FROM dbo.FN_stuName_letter('A')

--10. Write a table-valued function that returns unique department names from the STUDENT table.
GO
Create Or Alter Function FN_Uni_Dept ()
Returns Table
AS
	Return select DISTINCT StuDepartment
		From STUDENT;
GO

Select * from dbo.FN_Uni_Dept()

--Part-B 
--11. Write a scalar function that calculates age in years given a DateOfBirth. 
GO
Create Or Alter Function Fn_Age_cal (
	@dateOfBirth DATE
)
Returns INT
AS 
BEGIN 
	Return DATEDIFF(Year, @dateOfBirth, GETDATE());
END
GO

Select dbo.Fn_Age_cal('2007-03-10');

--12. Write a scalar function to check whether given number is palindrome or not. 
GO
Create Or Alter Function Fn_Num_Palindrome (
	@N INT
)
Returns Varchar(50)
AS
BEGIN
	Declare @Rev INT = 0, @Result Varchar(50) = ''

	While @N > @Rev
	BEGIN
		Set @Rev = (@Rev * 10) + (@N % 10)
		Set @N = @N / 10
	END

	If @N = @Rev OR @N = @Rev / 10
		SET @Result = 'Palindrom'
	Else
		SET @Result = 'Not Palindrom'

	Return @Result	
END
GO

Select dbo.Fn_Num_Palindrome(123)
Select dbo.Fn_Num_Palindrome(121)

--13. Write a scalar function to calculate the sum of Credits for all courses in the 'CSE' department. 
GO
Create or Alter Function Fn_Sum_Credits ()
Returns INT
AS
BEGIN
	Declare @SUM INT = 0

	SELECT @SUM = SUM(CourseCredits)
		FROM COURSE

	Return @SUM
END
GO

Select dbo.Fn_Sum_Credits()

-- OR

GO
CREATE OR ALTER FUNCTION FN_CHECK_PALINDROME
(
	@N INT
)
RETURNS VARCHAR(50)
AS
BEGIN
	IF CAST(@N AS VARCHAR) = REVERSE(CAST(@N AS VARCHAR))
		RETURN 'PALINDROME';

	RETURN 'NOT PALINDROME'
END;
GO

select dbo.FN_CHECK_PALINDROME(121)
--14. Write a table-valued function that returns all courses taught by faculty with a specific designation. 
GO
Create Or Alter Function FN_Cou_fac_desi(
	@DESIG VARCHAR(50)
)
Returns Table
AS
RETURN 
	(
		SELECT C.CourseName, F.FacultyName, F.FacultyDesignation
		FROM FACULTY F
		JOIN COURSE_ASSIGNMENT CA ON F.FacultyID = CA.FacultyID
		JOIN COURSE C ON C.CourseID = CA.CourseID
		WHERE F.FacultyDesignation = @DESIG
	)
GO

select * from dbo.FN_Cou_fac_desi('Professor')


--Part - C 
--15. Write a scalar function that accepts StudentID and returns their total enrolled credits (sum of credits 
--from all active enrollments). 
GO
Create Or Alter Function FN_Stu_infoo (
	@SID INT
)
RETURNS INT
AS
BEGIN
	DECLARE @TOTAL INT;

	SELECT @TOTAL = SUM(C.CourseCredits)
	FROM ENROLLMENT E JOIN COURSE C
	ON E.CourseID = C.CourseID
	WHERE E.StudentID = @SID AND E.EnrollmentStatus = 'Active';

	RETURN @TOTAL;
END
GO

--16. Write a scalar function that accepts two dates (joining date range) and returns the count of faculty who 
--joined in that period. 
GO
Create Or Alter Function Fn_Faculty_Join (
	@D1 DateTime,
	@D2 DateTime
)
Returns INT
AS
BEGIN
	Declare @Total INT = 0

	Select @Total = Count(*)
		From FACULTY F
		Where F.FacultyJoiningDate BETWEEN @D1 AND @D2

	Return @Total
END
GO
