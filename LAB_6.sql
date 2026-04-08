--Table : Log(LogMessage varchar(100), logDate Datetime) 
CREATE TABLE Log (
	logMessage Varchar(100),
	logDate Datetime,
);

drop table log

--Part – A 
--1. Create trigger for printing appropriate message after student registration. 
GO
	CREATE OR ALTER TRIGGER TR_AFTER_REG_MESSAGE
	ON STUDENT
	AFTER INSERT
	AS
	BEGIN
		PRINT 'Student Registracation successfully'
		INSERT INTO LOG VALUES ('student ' + (select stuName from inserted) + ' email ' + (select stuemail from inserted) + ' is inserted' , GETDATE())
	END;
GO

SELECT * FROM STUDENT;
INSERT INTO STUDENT VALUES (11, 'YASH NAROLA', 'yashnarola@univ.edu', '7567422700', 'CSE', '2007-03-10', 2024);
INSERT INTO STUDENT VALUES (12, 'MANAV KUMAR', 'manavkumar@univ.edu', '7567422701', 'CSE', '2008-12-11', 2024);
DELETE FROM STUDENT WHERE StudentID IN (11, 12);

DROP TRIGGER TR_AFTER_REG_MESSAGE;
SELECT * FROM LOG;

--2. Create trigger for printing appropriate message after faculty deletion
GO
	CREATE OR ALTER TRIGGER TR_AFTER_DEL_FAC_MESSSAGE
	ON FACULTY
	AFTER DELETE
	AS
	BEGIN
		PRINT 'Faculty deletion successfully'
	END
GO

SELECT * FROM FACULTY;
INSERT INTO FACULTY VALUES (108, 'Dr. Nilesh Shah', 'de.nileshshah@univ.edu', 'CES', 'Professor', '2001-01-01');
DELETE FROM FACULTY WHERE FacultyID = 108;

DROP TRIGGER TR_AFTER_DEL_FAC_MESSSAGE;

--3. Create trigger for monitoring all events on course table. (print only appropriate message) 
GO
	CREATE OR ALTER TRIGGER TR_ALL_EVENT_COURSE
	ON COURSE
	AFTER INSERT, UPDATE, DELETE
	AS
	BEGIN
		PRINT 'CHANGE OCCURRED IN COURSE TABLE'
	END
GO

insert into course values ('CS110', 'My Subject', 10, 'CSE', 1)
select * from course

DROP TRIGGER TR_ALL_EVENT_COURSE;

--4. Create trigger for logging data on new student registration in Log table. 
GO
	CREATE OR ALTER TRIGGER TR_LOGGING_LOG_TABLE
	ON STUDENT
	AFTER INSERT
	AS
	BEGIN
		INSERT INTO LOG VALUES ((SELECT STUNAME FROM INSERTED) + ' LOGGIN', GETDATE())
	END
GO

DROP TRIGGER TR_LOGGING_LOG_TABLE

--  5. Create a trigger for auto-uppercasing faculty names whenever a new record is inserted.
GO
CREATE OR ALTER TRIGGER TR_AFTER_UPPER_FACULTY_NAME
ON FACULTY
AFTER INSERT
AS
BEGIN
    DECLARE @FID    INT;
    DECLARE @FNAME  VARCHAR(100);
    SELECT @FID = FacultyID,@FNAME = FacultyName FROM INSERTED;
    UPDATE FACULTY SET FacultyName = UPPER(@FNAME)
    WHERE FacultyID = @FID;
END;
GO

INSERT INTO FACULTY VALUES (108,'Prof. Mehta','mehta@univ.edu','MECH','Professor','2023-01-31');
SELECT * FROM FACULTY;

DROP TRIGGER TR_AFTER_UPPER_FACULTY_NAME;

-- 6. Create a trigger for calculating faculty experience.(Note: Add required column in Faculty table).
ALTER TABLE FACULTY ADD Experience INT;
GO 
CREATE OR ALTER TRIGGER TR_AFTER_CALCULATE_FACULTY_EXPERIENCE
ON FACULTY
AFTER INSERT,UPDATE
AS
BEGIN
    DECLARE @FID    INT;
    DECLARE @JDATE  DATE;
    DECLARE @EXP    INT;

    SELECT @FID = FacultyID,@JDATE = FacultyJoiningDate FROM INSERTED;
    SET @EXP = DATEDIFF(YEAR,@JDATE,GETDATE());
    UPDATE FACULTY SET Experience = @EXP WHERE FacultyID = @FID;
END;
GO

INSERT INTO FACULTY VALUES (110,'Prof. Mehta','mehta@univ.edu','MECH','Professor','2023-01-31',NULL);

UPDATE FACULTY SET FacultyJoiningDate = '2023-02-10' WHERE FacultyID = 108;

DROP TRIGGER TR_AFTER_CALCULATE_FACULTY_EXPERIENCE;

-- PART-B
-- 7. Create a trigger for auto-stamping enrollment dates.
GO
CREATE OR ALTER TRIGGER TR_AFTER_INSERT_ENROLL_DATE
ON ENROLLMENT
AFTER INSERT
AS
BEGIN
      DECLARE @EID   INT;
      SELECT @EID = EnrollmentID FROM INSERTED;
      UPDATE ENROLLMENT SET EnrollmentDate = GETDATE()
      WHERE EnrollmentID = @EID;
END;
GO
INSERT INTO ENROLLMENT VALUES (13,'CS101',null,'A+','Completed');

SELECT * FROM ENROLLMENT;

DROP TRIGGER TR_AFTER_INSERT_ENROLL_DATE;

--  8. Create a trigger for logging data after course assignment – log course and faculty detail.
GO
CREATE OR ALTER TRIGGER TR_AFTER_LOG_COURSE_ASSIGNMENT
ON COURSE_ASSIGNMENT
AFTER INSERT
AS
BEGIN
    DECLARE @CID    VARCHAR(10);
    DECLARE @FID    INT;
    SELECT @CID = CourseID,@FID = FacultyID FROM inserted;
    INSERT INTO LOG VALUES
    ('Course ' + CAST(@CID AS VARCHAR) + ' Assigned to Faculty ' + CAST(@FID AS VARCHAR),GETDATE());
END;
GO

INSERT INTO COURSE_ASSIGNMENT VALUES ('CS301',108,6,2025,'H-408');

SELECT * FROM COURSE_ASSIGNMENT;
SELECT * FROM LOG;

DROP TRIGGER TR_AFTER_LOG_COURSE_ASSIGNMENT;

-- PART-C
-- 9. Create a trigger for updating student phone and print the old and new phone number.
GO
CREATE OR ALTER TRIGGER TR_AFTER_UPDATE_PHONE
ON STUDENT
AFTER UPDATE
AS
BEGIN
    DECLARE @OLD    VARCHAR(15),@NEW    VARCHAR(15);

    SELECT @OLD = StuPhone FROM deleted;
    SELECT @NEW = StuPhone FROM inserted;

    PRINT 'Old Phone: '+@old;
    PRINT 'New Phone: '+@new;
END;
GO

UPDATE STUDENT SET StuPhone = '9876543219' WHERE StudentID = 10;
SELECT * FROM STUDENT;

DROP TRIGGER TR_AFTER_UPDATE_PHONE;

-- 10. Create a trigger for updating course credits and log old and new credits in Log table.
GO
CREATE OR ALTER TRIGGER TR_AFTER_LOG_COURSE_CREDITS
ON COURSE
AFTER UPDATE
AS
BEGIN
    DECLARE @CID  VARCHAR(10), @OLD_CREDIT  INT, @NEW_CREDIT  INT;

    SELECT @OLD_CREDIT = CourseCredits,@CID = CourseID FROM deleted;
    SELECT @NEW_CREDIT = CourseCredits FROM inserted;

    INSERT INTO LOG VALUES
    ('Course ' + CAST(@CID as varchar) + ' credits changed from ' + CAST(@OLD_CREDIT AS VARCHAR) 
     + ' to ' + CAST(@NEW_CREDIT AS VARCHAR),GETDATE());
END;
GO

SELECT * FROM COURSE;
UPDATE COURSE SET CourseCredits = 5 WHERE CourseID = 'CS302';
SELECT * FROM LOG;

DROP TRIGGER TR_AFTER_LOG_COURSE_CREDITS;