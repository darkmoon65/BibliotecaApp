
CREATE PROCEDURE GetAllUsers
AS
    SELECT * FROM Users;
GO

CREATE PROCEDURE GetUserById
    @varEmail varchar(255),
	@varPassword varchar(255)
AS
    SELECT * FROM Users
    WHERE varEmail = @varEmail and varPassword = @varPassword;
GO

CREATE PROCEDURE InsertUser
    @varFirstName VARCHAR(255),
    @varLastName VARCHAR(255),
    @varEmail VARCHAR(255),
    @varPassword VARCHAR(255),
    @intStatus INT,
    @isActiver BIT
AS
    INSERT INTO Users (varFirstName, varLastName, varEmail, varPassword, intStatus, dmeDateCreate, dmeDateUpdate, isActiver)
    VALUES (@varFirstName, @varLastName, @varEmail, @varPassword, @intStatus, GETDATE(), GETDATE(), @isActiver);
GO



CREATE PROCEDURE UpdateUser
    @idUser INT,
    @varFirstName VARCHAR(255),
    @varLastName VARCHAR(255),
    @varEmail VARCHAR(255),
    @varPassword VARCHAR(255),
    @intStatus INT,
    @isActiver BIT
AS
    UPDATE Users
    SET varFirstName = @varFirstName,
        varLastName = @varLastName,
        varEmail = @varEmail,
        varPassword = @varPassword,
        intStatus = @intStatus,
        dmeDateUpdate = GETDATE(),
        isActiver = @isActiver
    WHERE idUser = @idUser;
GO

CREATE PROCEDURE DeleteUser
    @idUser INT
AS
    DELETE FROM Users WHERE idUser = @idUser;
GO

-- LIBROS -----------------

CREATE PROCEDURE InsertBook
    @varTitle VARCHAR(255),
    @varCode VARCHAR(255),
    @instStatus INT,
    @isActiver BIT
AS
    INSERT INTO Books (varTitle, varCode, instStatus, dmeDateCreate, dmeDateUpdate, isActiver)
    VALUES (@varTitle, @varCode, @instStatus, GETDATE(), GETDATE(), @isActiver);
GO

CREATE PROCEDURE GetAllBooks
AS
BEGIN
     WITH LastReservation AS (
        SELECT
            R.*,
            ROW_NUMBER() OVER (PARTITION BY R.idBook ORDER BY R.dmeDateReservationEnd DESC) AS RowNum
        FROM
            Reservations R
    )
    SELECT
        B.*,
        RR.idReservation,
        RR.idUser AS ReservationUserID,
        RR.dmeDateReservation,
        RR.dmeDateReservationEnd,
        RR.instStatus
    FROM
        Books B
    LEFT JOIN
        LastReservation RR ON B.idBook = RR.idBook AND RR.RowNum = 1;
END;



CREATE PROCEDURE GetBookById
    @idBook INT
AS
    SELECT * FROM Books WHERE idBook = @idBook;
GO


CREATE PROCEDURE UpdateBook
    @idBook INT,
    @varTitle VARCHAR(255),
    @varCode VARCHAR(255),
    @instStatus INT,
    @isActiver BIT
AS
    UPDATE Books
    SET varTitle = @varTitle,
        varCode = @varCode,
        instStatus = @instStatus,
        dmeDateUpdate = GETDATE(),
        isActiver = @isActiver
    WHERE idBook = @idBook;
GO

CREATE PROCEDURE DeleteBook
    @idBook INT
AS
    DELETE FROM Books WHERE idBook = @idBook;
GO

-- reservaciones --------

CREATE PROCEDURE InsertReservation
    @idUser INT,
    @idBook INT,
    @dmeDateReservation DATETIME,
	@dmeDateReservationEnd DATETIME,
    @instStatus INT,
    @isActiver BIT
AS
    IF NOT EXISTS (SELECT 1 FROM Reservations WHERE idBook = @idBook AND instStatus = 1)
		BEGIN
			INSERT INTO Reservations (idUser, idBook, dmeDateReservation, 
									  dmeDateReservationEnd, instStatus, dmeDateCreate, 
									  dmeDateUpdate, isActiver)
			VALUES (@idUser, @idBook, @dmeDateReservation, 
					@dmeDateReservationEnd, @instStatus, GETDATE(), GETDATE(), @isActiver);
		END
    ELSE
		BEGIN
			DECLARE @priorityNext NVARCHAR(2);

			SELECT @priorityNext = CASE 
				WHEN MAX(varPriority) = 'P1' THEN 'P2'
				WHEN MAX(varPriority) = 'P2' THEN 'P3'
				ELSE 'P1' END
			FROM WaitReservations
			WHERE idBook = @idBook;

			DECLARE @lastDate DATETIME;
			SELECT TOP 1 @lastDate = dmeDateReservationEnd
			FROM WaitReservations
			WHERE isActive = 1 and idBook = @idBook and instStatus = 1
			ORDER BY varPriority DESC;

			IF(@lastDate IS NULL)
			BEGIN
				SET @lastDate = @dmeDateReservation
			END

			IF NOT EXISTS (SELECT 1 FROM WaitReservations WHERE idBook = @idBook AND idUser = @idUser)
			BEGIN
				DECLARE @sizeList INT;
				SELECT @sizeList = COUNT(*) FROM WaitReservations WHERE instStatus = 1 AND idBook = @idBook;

				IF(@sizeList < 3)
				BEGIN
					-- Insertar solo si no existe un registro con el mismo userId
					INSERT INTO WaitReservations (idUser, idBook, varPriority, 
												  dmeDateReservation, dmeDateReservationEnd, 
												  instStatus, dmeDateCreate, dmeDateUpdate, isActive)
					VALUES (@idUser, @idBook, @priorityNext, @lastDate, DATEADD(HOUR, 24, @lastDate),
							1,  GETDATE(), GETDATE(), 1);
				END
			END
		END

GO

CREATE PROCEDURE GetAllReservations
AS
    SELECT * FROM Reservations;
GO

CREATE PROCEDURE GetReservation
    @idUser INT,
    @idBook INT
AS
    SELECT * FROM Reservations WHERE idUser = @idUser AND idBook = @idBook;
GO

CREATE PROCEDURE UpdateReservation
    @idUser INT,
    @idBook INT,
    @dmeDateReservation DATETIME,
    @instStatus INT,
    @isActiver BIT
AS
    UPDATE Reservations
    SET dmeDateReservation = @dmeDateReservation,
        instStatus = @instStatus,
        dmeDateUpdate = GETDATE(),
        isActiver = @isActiver
    WHERE idUser = @idUser AND idBook = @idBook;
GO

CREATE PROCEDURE DeleteReservation
    @idUser INT,
    @idBook INT
AS
    DELETE FROM Reservations WHERE idUser = @idUser AND idBook = @idBook;
GO



-- SP Liberacion de libros

CREATE PROCEDURE ReleaseBooks
AS
BEGIN

    UPDATE Reservations
    SET instStatus = 0
    WHERE dmeDateReservation < DATEADD(HOUR, -24, GETDATE());

    DECLARE @usuarioMasProximo NVARCHAR(2);
	DECLARE @dmeDateReservation DATETIME;
	DECLARE @dmeDateReservationEnd DATETIME;

    SELECT TOP 1 @usuarioMasProximo = varPriority , 
				 @dmeDateReservation = dmeDateReservation,
				 @dmeDateReservationEnd = dmeDateReservationEnd
    FROM WaitReservations
    WHERE instStatus = 1
    ORDER BY varPriority ASC;

    -- Realizar la reserva automática para el usuario más próximo en la tabla de wait
	IF ( @dmeDateReservation < GETDATE() )
		BEGIN
		INSERT INTO Reservations(idUser, idBook, dmeDateReservation, 
								dmeDateReservationEnd, instStatus, dmeDateCreate, 
								dmeDateUpdate, isActiver)
			VALUES ( (SELECT TOP 1 idUser FROM WaitReservations WHERE varPriority = @usuarioMasProximo),
			(SELECT TOP 1 idBook FROM WaitReservations WHERE varPriority = @usuarioMasProximo),
			@dmeDateReservation, @dmeDateReservationEnd , 1, GETDATE(), GETDATE(), 1)
		END

    -- Desactivar la reserva anterior en la lista de espera
    UPDATE WaitReservations
    SET instStatus = 0
    WHERE varPriority = @usuarioMasProximo;
END;


EXEC msdb.dbo.sp_add_job
    @job_name = N'ReservaAutomaticaCronJob',
    @enabled = 1,
    @description = N'Job para liberar libros y realizar las reservas automaticamente.';
GO

-- Agregar una tarea para liberar libros después de 24 horas y realizar la reserva automática
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'ReservaAutomaticaCronJob',
    @step_name = N'LiberarYReservar',
    @subsystem = N'TSQL',
    @command = N'EXEC ReleaseBooks;';

EXEC msdb.dbo.sp_add_schedule  
    @schedule_name = N'RunOnceDaily',  
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 000000;  
GO  

EXEC msdb.dbo.sp_attach_schedule  
   @job_name = N'ReservaAutomaticaCronJob',  
   @schedule_name = N'RunOnceDaily';  
GO  

EXEC msdb.dbo.sp_add_jobserver  
    @job_name = N'ReservaAutomaticaCronJob';  
GO  

EXEC msdb.dbo.sp_start_job @job_name = N'ReservaAutomaticaCronJob';


CREATE PROCEDURE GetWaitReservations
AS
BEGIN
    SELECT WR.*, U.varFirstName AS UserName,
        U.varLastName AS UserLastName, B.varTitle
    FROM WaitReservations WR
    INNER JOIN Users U ON WR.idUser = U.idUser
    INNER JOIN Books B ON WR.idBook = B.idBook;
END;
