--Cursor 

--Part – A 
--1. Create a cursor Course_Cursor to fetch all rows from COURSE table and display them.
select * from COURSE;
GO
DECLARE @CID varchar(50), @CName varchar(100), @CC int, @CDepart varchar(25), @CSem int;
DECLARE Course_Cursor CURSOR FOR
SELECT * FROM COURSE

OPEN Course_Cursor

FETCH NEXT FROM Course_Cursor INTO @CID, @CName, @CC, @CDepart, @CSem

While @@FETCH_STATUS = 0
BEGIN
	PRINT CONCAT('CourseID ', @CID, ' CourseName ', @CName, ' CourseCredits ', @CC, ' CourseDepartment ', @CDepart, ' CourseSem ', @CSem)

	FETCH NEXT FROM Course_Cursor INTO @CID, @CName, @CC, @CDepart, @CSem
END

CLOSE Course_Cursor

DEALLOCATE Course_Cursor
GO

--2. Create a cursor Student_Cursor_Fetch to fetch records in form of StudentID_StudentName (Example: 
--1_Raj Patel). 
GO
DECLARE @SID INT, @SName varchar(50)
DECLARE Student_Cursor_Fetch CURSOR 
FOR SELECT StudentID, StuName FROM STUDENT

OPEN Student_Cursor_Fetch

FETCH NEXT FROM Student_Cursor_Fetch INTO @SID, @SName

WHILE @@FETCH_STATUS = 0
BEGIN 
	PRINT CAST(@SID AS varchar) + '_' + @SName

	FETCH NEXT FROM Student_Cursor_Fetch INTO @SID, @SName
END

CLOSE Student_Cursor_Fetch

DEALLOCATE Student_Cursor_Fetch
GO

--3. Create a cursor to find and display all courses with Credits greater than 3. 
GO
DECLARE @CName varchar(100)
DECLARE CreditGreater3 CURSOR FOR
SELECT CourseName 
FROM COURSE 
WHERE CourseCredits > 3

OPEN CreditGreater3

FETCH NEXT FROM CreditGreater3 INTO @CName

WHILE @@FETCH_STATUS = 0
BEGIN 
	PRINT @CName
	FETCH NEXT FROM CreditGreater3 INTO @CName
END

CLOSE CreditGreater3

DEALLOCATE CreditGreater3

GO

--4. Create a cursor to display all students who enrolled in year 2021 or later. 
GO
DECLARE @NAME VARCHAR(100), @YEAR INT;
DECLARE Student_Cursor CURSOR FOR
SELECT StuName,StuEnrollmentYear FROM STUDENT 
WHERE StuEnrollmentYear >= 2021;

OPEN Student_Cursor;

FETCH NEXT FROM Student_Cursor INTO @NAME,@YEAR;

WHILE @@FETCH_STATUS = 0
BEGIN
	 -- SELECT @NAME AS NAME ,@YEAR AS YEAR
	 PRINT CONCAT('Student Name - ', @NAME , ' & Enrollment Year - ', @YEAR)
	 FETCH NEXT FROM Student_Cursor INTO @NAME,@YEAR;
END;

CLOSE Student_Cursor;

DEALLOCATE Student_Cursor;
GO

--5. Create a cursor Course_CursorUpdate that retrieves all courses and increases Credits by 1 for courses 
--with Credits less than 4. 
GO
DECLARE @CID VARCHAR(10), @CREDITS INT
DECLARE Course_CursorUpdate CURSOR FOR
SELECT CourseID,CourseCredits FROM COURSE WHERE CourseCredits < 4;
OPEN Course_CursorUpdate;
FETCH NEXT FROM Course_CursorUpdate INTO @CID,@CREDITS;

WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE COURSE SET CourseCredits = CourseCredits + 1
	WHERE CourseID = @CID;

	FETCH NEXT FROM Course_CursorUpdate INTO @CID,@CREDITS;
END;
CLOSE Course_CursorUpdate;
DEALLOCATE Course_CursorUpdate;
GO

--6. Create a Cursor to fetch Student Name with Course Name (Example: Raj Patel is enrolled in Database 
--Management System) 

GO
DECLARE @SNAME VARCHAR(100), @CNAME VARCHAR(100)
DECLARE Enroll_Cursor CURSOR FOR
SELECT S.StuName,C.CourseName FROM
STUDENT S JOIN ENROLLMENT E
ON S.StudentID = E.StudentID
JOIN COURSE C
ON E.CourseID = C.CourseID
OPEN Enroll_Cursor;
FETCH NEXT FROM Enroll_Cursor INTO @SNAME,@CNAME;

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @SNAME + ' is enrollend in ' + @CNAME;

	FETCH NEXT FROM Enroll_Cursor INTO @SNAME,@CNAME;
END;
CLOSE Enroll_Cursor;
DEALLOCATE Enroll_Cursor;
GO

--7. Create a cursor to insert data into new table if student belong to ‘CSE’ department. (create new table 
--CSEStudent with relevant columns) 
Create Table CSEStudent (
	StudentID INT,
	StuName VARCHAR(100),
	StuEmail VARCHAR(100),
	StuPhone VARCHAR(15),
	StuDepartment VARCHAR(50),
	StuDateOfBirth DATE,
	StuEnrollmentYear INT 
);

DROP Table CSEStudent
GO
DECLARE @SID INT, @SName VARCHAR(100), @SEmail VARCHAR(100), @SPhone VARCHAR(15), @SDepart VARCHAR(50), @SDOB DATE, @SEnroll INT
DECLARE CSE_Cursor CURSOR
FOR 
SELECT StudentID, StuName, StuEmail, StuPhone, StuDepartment, StuDateOfBirth, StuEnrollmentYear FROM STUDENT

OPEN CSE_Cursor

FETCH NEXT FROM CSE_Cursor INTO @SID, @SName, @SEmail, @SPhone, @SDepart, @SDOB, @SEnroll

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO CSEStudent VALUES (@SID, @SName, @SEmail, @SPhone, @SDepart, @SDOB, @SEnroll)

	FETCH NEXT FROM CSE_Cursor INTO @SID, @SName, @SEmail, @SPhone, @SDepart, @SDOB, @SEnroll

END

CLOSE CSE_Cursor

DEALLOCATE CSE_Cursor
GO

--Part – B 
--8. Create a cursor to update all NULL grades to 'F' for enrollments with Status 'Completed' 
GO
DECLARE @EID INT;
DECLARE Grade_Cursor CURSOR FOR
SELECT EnrollmentID FROM ENROLLMENT
WHERE Grade IS NULL AND EnrollmentStatus = 'Completed';
OPEN Grade_Cursor;
FETCH NEXT FROM Grade_Cursor INTO @EID;

WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE ENROLLMENT SET Grade = 'F'
	WHERE EnrollmentID = @EID;

	FETCH NEXT FROM Grade_Cursor INTO @EID;
END;
CLOSE Grade_Cursor;
DEALLOCATE Grade_Cursor;
GO

--9. Cursor to show Faculty with Course they teach (EX: Dr. Sheth teaches Data structure) 
GO
DECLARE @FNAME VARCHAR(100), @CNAME VARCHAR(100)
DECLARE Faculty_Cursor CURSOR FOR
SELECT F.FacultyName,C.CourseName FROM
COURSE_ASSIGNMENT CA JOIN COURSE C
ON CA.CourseID = C.CourseID
JOIN FACULTY F
ON CA.FacultyID = F.FacultyID
OPEN Faculty_Cursor;
FETCH NEXT FROM Faculty_Cursor INTO @FNAME,@CNAME;
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @FNAME + ' teaches ' + @CNAME;
	FETCH NEXT FROM Faculty_Cursor INTO @FNAME,@CNAME;
END;
CLOSE Faculty_Cursor;
DEALLOCATE Faculty_Cursor;
GO

--Part – C 
--10. Cursor to calculate total credits per student (Example: Raj Patel has total credits = 15) 
GO
DECLARE @SID INT,@SNAME VARCHAR(100),@TOTAL INT
DECLARE Credit_Cursor CURSOR FOR
SELECT S.StudentID,S.StuName,SUM(C.CourseCredits)
FROM STUDENT S JOIN ENROLLMENT E
ON S.StudentID = E.StudentID
JOIN COURSE C
ON C.CourseID = E.CourseID
GROUP BY S.StudentID,S.StuName;
OPEN Credit_Cursor;
FETCH NEXT FROM Credit_Cursor INTO @SID,@SNAME,@TOTAL;

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @SNAME + ' has total credits = ' + CAST(@TOTAL AS VARCHAR);
	FETCH NEXT FROM Credit_Cursor INTO @SID,@SNAME,@TOTAL;
END;
CLOSE Credit_Cursor;
DEALLOCATE Credit_Cursor;
GO
