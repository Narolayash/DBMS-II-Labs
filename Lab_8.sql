--Part – A 
--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error. 
GO
CREATE OR ALTER PROCEDURE PR_DIVIDE_BY_ZERO
AS
BEGIN
	BEGIN TRY
		PRINT 10 / 0
	END TRY
	BEGIN CATCH
		PRINT 'Error occurs that is - Divide by zero error.'
	END CATCH
END
GO

EXEC PR_DIVIDE_BY_ZERO
--2. Try to convert string to integer and handle the error using try…catch block. 
GO
CREATE OR ALTER PROCEDURE PR_CONVERT_INT_STR_INT
AS
	BEGIN TRY
		PRINT CAST('NILESH' AS INT)
	END TRY
	BEGIN CATCH
		PRINT 'STRING CAN NOT BE CONVETABLE INTO INTEGER'
	END CATCH
GO

EXEC PR_CONVERT_INT_STR_INT
--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle 
--exception with all error functions if any one enters string value in numbers otherwise print result. 
GO
CREATE OR ALTER PROCEDURE PR_AddNumbers
    @N1 VARCHAR(50),
    @N2 VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        DECLARE @Num1 INT;
        DECLARE @Num2 INT;
        DECLARE @SUM INT;
        SET @Num1 = CAST(@N1 AS INT);
        SET @Num2 = CAST(@N2 AS INT);

        SET @SUM = @Num1 + @Num2;
        PRINT 'Sum = ' + CAST(@SUM AS VARCHAR);
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER()     AS ErrorNumber,
            ERROR_SEVERITY()   AS ErrorSeverity,
            ERROR_STATE()      AS ErrorState,
            ERROR_LINE()       AS ErrorLine,
            ERROR_MESSAGE()    AS ErrorMessage,
            ERROR_PROCEDURE()  AS ErrorProcedure;
    END CATCH
END
GO

EXEC PR_AddNumbers 10, 20
EXEC PR_AddNumbers 10, 'NILESH'

--4. Handle a Primary Key Violation while inserting data into student table and print the error details such 
--as the error message, error number, severity, and state. 

SELECT * FROM STUDENT
GO
CREATE OR ALTER PROCEDURE PR_PRIMARY_VIOLATINO
AS
BEGIN
	BEGIN TRY
		INSERT INTO STUDENT VALUES 
		(1, 'NILESH PATEL', 'nileshpatel@gmail.com', 1001015689, 'CES', '2017-01-12', 2019)
	END TRY
	BEGIN CATCH
		--PRINT 'PRIMARY KEY VIOLATION'
		SELECT 
			ERROR_MESSAGE() AS ERROR_MASSAGE,
			ERROR_NUMBER() AS ERROR_NUMBER,
			ERROR_SEVERITY() AS ERROR_SEVERITY,
			ERROR_STATE() AS ERROR_STATE
  	END CATCH
END
GO

EXEC PR_PRIMARY_VIOLATINO

--5. Throw custom exception using stored procedure which accepts StudentID as input & that throws 
--Error like no StudentID is available in database. 
GO
CREATE OR ALTER PROCEDURE PR_STUID_AVAILABLE
	@ID INT
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (
			SELECT * FROM STUDENT WHERE StudentID = @ID
		)
			THROW 50001, 'STUDENT NOT AVAILABLE', 6
		ELSE
			PRINT 'STUDENT IS AVAILABLE'
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_MESSAGE() AS ERROR_MESSAGE,
			ERROR_SEVERITY() AS ERROR_SEVERITY,
			ERROR_STATE() AS ERROR_STATE,
			ERROR_NUMBER() AS ERROR_NUMBER
	END CATCH
END
GO

EXEC PR_STUID_AVAILABLE 155
EXEC PR_STUID_AVAILABLE 1

--6. Handle a Foreign Key Violation while inserting data into Enrollment table and print appropriate error 
--message.
GO
CREATE OR ALTER PROCEDURE PR_FOREIGN_KEY_VIOLATION
AS
BEGIN
	BEGIN TRY
		INSERT INTO ENROLLMENT VALUES 
		(50, 'CS500', '2006-2-2', 'B_', 'ACTIVE')
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_MESSAGE() AS ERROR_MESSAGE,
			ERROR_SEVERITY() AS ERROR_SEVERITY,
			ERROR_STATE() AS ERROR_STATE,
			ERROR_NUMBER() AS ERROR_NUMBER
	END CATCH
END
GO

EXEC PR_FOREIGN_KEY_VIOLATION


--Part – B 
--7. Handle Invalid Date Format 
BEGIN TRY
	DECLARE @InputDate DATE;

	SET @InputDate = CAST('2026-13-03' AS DATE)

	PRINT 'Valid Date Format'
END TRY

BEGIN CATCH
	
	PRINT 'Error: Invalid Date Format'

END CATCH

--8. Procedure to Update faculty’s Email with Error Handling. 
GO
CREATE OR ALTER PROCEDURE PR_UpdateFacultyEmail
	@FID		INT,
	@NewEmail	VARCHAR(100)
AS
BEGIN
	BEGIN TRY
		UPDATE FACULTY SET FacultyEmail = @NewEmail
		WHERE FacultyID = @FID;

		PRINT 'Faculty Email updated successfully'
	END TRY
	BEGIN CATCH
		 PRINT 'Error occurred while updating email'
		 PRINT ERROR_MESSAGE()
	END CATCH
END;
GO

EXEC PR_UpdateFacultyEmail 101,'sheth@univ.edu';
EXEC PR_UpdateFacultyEmail 1,'patel@univ.edu';

-- OR

GO
CREATE OR ALTER PROCEDURE PR_UpdateFacultyEmail
	@FID INT,
	@NewEmail VARCHAR(100)
AS
BEGIN

BEGIN TRY

	UPDATE FACULTY
	SET FacultyEmail = @NewEmail
	WHERE FacultyID = @FID;

	IF @@ROWCOUNT = 0
		PRINT 'Error: FacultyID not found'
	ELSE
		PRINT 'Faculty Email updated successfully'

END TRY

BEGIN CATCH

	PRINT 'Error occurred while updating email'
	PRINT ERROR_MESSAGE()

END CATCH

END
GO

EXEC PR_UpdateFacultyEmail 1,'patel@univ.edu';
SELECT * FROM FACULTY;

--9. Throw custom exception that throws error if the data is invalid. 
BEGIN TRY
	DECLARE @EMAIL VARCHAR(100) = 'InvalidEmail'
	IF @EMAIL NOT LIKE '%@%.%'
		THROW 50001,'Invalid Email Format',1
	PRINT 'Valid Email'
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH

--Part – C 
--10. Write a script that checks if a faculty’s salary is NULL. If it is, use RAISERROR to show a message with a 
--severity of 16. (Note: Do not use any table)
DECLARE @SALARY DECIMAL(10,2)
SET @SALARY = NULL
IF @SALARY IS NULL
BEGIN
	RAISERROR('Faculty salary cannot be NULL',16,1)
END
ELSE
BEGIN
    PRINT 'Salary is valid'
END
