----Lab-7 Trigger (Instead of trigger)
--Table : Log(LogMessage varchar(100), logDate Datetime) 
Create Table Log_Insted_Of (
	LogMessage Varchar(100),
	LogDate Datetime
);

--Part – A 
--1. Create trigger for blocking student deletion.
Go
Create or Alter Trigger Blocking_Deletetion_of_Student
On Student
Instead Of Delete
As 
Begin
	Print 'Student deletion is not allowed'
End
Go

Drop Trigger Blocking_Deletetion_of_Student

Delete from STUDENT
where StudentID = 101;

--2. Create trigger for making course read-only.
Go
Create Or Alter Trigger Course_Read_Only
On Course
Instead Of Insert, Delete, Update
As
Begin
	Print 'Course is read only.'
End
Go

Drop Trigger Course_Read_Only

Insert Into COURSE values ('cs101', 'mycourse', 4, 'cse', 3)
select * from COURSE 

--3. Create trigger for preventing faculty removal. 
Go
Create Or Alter Trigger Faculty_not_Remove
On Faculty
Instead Of Delete
As
Begin
	Print 'Facultu removal is not allowed.'
End
Go

Drop Trigger Faculty_not_Remove

delete from FACULTY where FacultyID = 101
select * from FACULTY

--4. Create instead of trigger to log all operations on COURSE (INSERT/UPDATE/DELETE)
-- into Log table. 
--(Example: INSERT/UPDATE/DELETE operations are blocked for you in course table) 
GO
Create Or Alter Trigger Instead_Of_Course_All_Opetation
On COURSE
Instead Of Insert, Delete, Update
As
Begin
	
	if Exists(Select * from inserted) AND Exists(Select * from deleted)
	Begin
		Print 'Updation is not allowed on this table'
		return
	End
	if Exists(Select * from inserted)
	Begin
		Print 'Insertion is not allowed on this tabel'
		return
	End
	if Exists(Select * from deleted)
	Begin
		Print 'Deletion is not allowed on this table'
		return
	End
End
GO

delete from COURSE where CourseID = 'CS101'
Insert Into COURSE values ('cs101', 'mycourse', 4, 'cse', 3)
update COURSE set CourseCredits = 4 where CourseID = 'IT101'

--5. Create trigger to Block student to update their enrollment year and print message ‘students are not 
--allowed to update their enrollment year’ 
GO
Create Or Alter Trigger Student_Enroll_Year_Not_Update
on Student
Instead of Update
As
Begin
	if update(StuEnrollmentYear)
	Begin
		Print 'students are not allowed to update their enrollment year'
		return
	End
	else
	Begin
		update STUDENT
		set StuName = i.StuName,
			StuEmail = i.StuEmail,
			StuPhone = i.StuPhone, 
			StuDepartment = i.StuDepartment,  
			StuDateOfBirth = i.StuDateOfBirth
			from STUDENT s
		join inserted i 
		on s.StudentId = i.StudentId
	End
End
GO

select * from student
update STUDENT
set StuEnrollmentYear = 2026

update STUDENT
set StuName = 'Raj Patel'
where StudentID = 1

--6. Create trigger for student age validation (Min 18).
GO
CREATE OR ALTER TRIGGER TR_VALIDATE_STUDENT_AGE
ON STUDENT
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @DOB DATE;
	SELECT @DOB = StuDateOfBirth FROM inserted;
	IF DATEDIFF(YEAR,@DOB,GETDATE()) < 18
	BEGIN
		PRINT 'Invalid Date of Birth! Student must be at least 18 years old.';
        RETURN;
	END;
	INSERT INTO STUDENT SELECT * FROM inserted
END;
GO

INSERT INTO STUDENT(StudentID,StuName,StuEmail,StuPhone,StuDepartment,StuDateOfBirth,StuEnrollmentYear) VALUES
(45,'Jay Patel','jay@univ.edu','9879999084','CSE','2025-09-18',2024);
INSERT INTO STUDENT(StudentID,StuName,StuEmail,StuPhone,StuDepartment,StuDateOfBirth,StuEnrollmentYear) VALUES
(45,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

SELECT * FROM STUDENT;

DROP TRIGGER TR_VALIDATE_STUDENT_AGE;

-- PART-B
--7. Create trigger for unique faculty’s email check.
GO
CREATE OR ALTER TRIGGER TR_UNIQUE_FACULTY_EMAIL
ON FACULTY
INSTEAD OF INSERT,UPDATE
AS
BEGIN
	DECLARE @EMAIL VARCHAR(100);
	SELECT @EMAIL = FacultyEmail FROM inserted;
	IF @EMAIL IN (SELECT FacultyEmail FROM FACULTY)
	BEGIN
		PRINT 'Duplicate faculty email is not allowed.';
		RETURN;
	END;
	UPDATE F
	SET
		F.FacultyID = I.FacultyID,
		F.FacultyName = I.FacultyName,
		F.FacultyEmail = I.FacultyEmail,
		F.FacultyDepartment = I.FacultyDepartment,
		F.FacultyDesignation = I.FacultyDesignation,
		F.FacultyJoiningDate = I.FacultyJoiningDate
	FROM FACULTY F JOIN inserted I
	ON F.FacultyID = I.FacultyID

	INSERT INTO FACULTY 
	SELECT * FROM inserted where FacultyID NOT IN (SELECT FacultyID FROM FACULTY);
END;
GO

SELECT * FROM FACULTY;

INSERT INTO FACULTY (FacultyID,FacultyName,FacultyEmail,FacultyDepartment,FacultyDesignation,FacultyJoiningDate)
VALUES (109,'Arjun Bala','patel@univ.edu','CSE','Assistant Prof','2020-01-01')

INSERT INTO FACULTY (FacultyID,FacultyName,FacultyEmail,FacultyDepartment,FacultyDesignation,FacultyJoiningDate)
VALUES (109,'Arjun Bala','arjun@univ.edu','CSE','Assistant Prof','2020-01-01')

UPDATE FACULTY SET FacultyEmail = 'mehta@univ.edu' WHERE FacultyName = 'Dr. Sheth';

DROP TRIGGER TR_UNIQUE_FACULTY_EMAIL;


--8. Create trigger for preventing duplicate enrollment.
GO
CREATE OR ALTER TRIGGER TR_PREVENT_DUPLICATE_ENROLLMENT
ON ENROLLMENT
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @SID INT,@CID VARCHAR(10);
	SELECT @SID = StudentID,@CID = CourseID from inserted;
	IF 
	  (SELECT COUNT(*) FROM ENROLLMENT WHERE StudentID = @SID and CourseID = @CID) > 0
	BEGIN
		PRINT 'Duplicate enrollment not allowed.'
		RETURN;
	END;
	INSERT INTO ENROLLMENT (StudentID, CourseID, EnrollmentDate,Grade,EnrollmentStatus)
	SELECT StudentID,CourseID,EnrollmentDate,Grade,EnrollmentStatus FROM inserted;

END;
GO

SELECT * FROM ENROLLMENT;

DROP TRIGGER TR_PREVENT_DUPLICATE_ENROLLMENT;

-- PART-C

--9. Create trigger to Allow enrolment in month from Jan to August, otherwise print message enrolment
-- closed.

GO
CREATE OR ALTER TRIGGER TR_ENROLLMENT_MONTH_CHECK
ON ENROLLMENT
INSTEAD OF INSERT
AS
BEGIN
	IF MONTH(GETDATE()) < 8
		INSERT INTO ENROLLMENT (StudentID, CourseID, EnrollmentDate,Grade,EnrollmentStatus)
		SELECT StudentID,CourseID,EnrollmentDate,Grade,EnrollmentStatus FROM inserted;
	ELSE
		 PRINT 'Enrollment closed.';
END;
GO

DROP TRIGGER TR_ENROLLMENT_MONTH_CHECK;

--10. Create trigger to Allow only grade change in enrollment (block other updates).
-- If Grade column updated -> allow update
-- Else -> block update
GO
CREATE OR ALTER TRIGGER TR_ALLOW_ONLY_GRADE_UPDATE
ON ENROLLMENT
INSTEAD OF UPDATE
AS
BEGIN
	IF UPDATE(GRADE)
		UPDATE ENROLLMENT
		SET Grade = I.Grade
		FROM ENROLLMENT E JOIN inserted I
		ON E.EnrollmentID = I.EnrollmentID;
	ELSE 
		 PRINT 'Only grade change is allowed.';
END;
GO

DROP TRIGGER TR_ALLOW_ONLY_GRADE_UPDATE;