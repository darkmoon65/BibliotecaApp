
CREATE PROCEDURE GetAllUsers
AS
    SELECT * FROM Users;
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
    SELECT * FROM Books;
GO


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
    @instStatus INT,
    @isActiver BIT
AS
    INSERT INTO Reservations (idUser, idBook, dmeDateReservation, instStatus, dmeDateCreate, dmeDateUpdate, isActiver)
    VALUES (@idUser, @idBook, @dmeDateReservation, @instStatus, GETDATE(), GETDATE(), @isActiver);
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
