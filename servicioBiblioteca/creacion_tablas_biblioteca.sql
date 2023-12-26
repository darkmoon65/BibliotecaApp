create database dbreto
go

use dbreto
go

CREATE TABLE Users (
    idUser INT PRIMARY KEY IDENTITY(1,1),
    varFirstName VARCHAR(255),
    varLastName VARCHAR(255),
    varEmail VARCHAR(255),
    varPassword VARCHAR(255),
    intStatus INT,
    dmeDateCreate DATETIME,
    dmeDateUpdate DATETIME,
    isActiver BIT
);

CREATE TABLE Books (
    idBook INT PRIMARY KEY IDENTITY(1,1),
    varTitle VARCHAR(255),
    varCode VARCHAR(255),
    instStatus INT,
    dmeDateCreate DATETIME,
    dmeDateUpdate DATETIME,
    isActiver BIT
);

CREATE TABLE Reservations (
    idReservation INT PRIMARY KEY IDENTITY(1,1),
    idUser INT,
    idBook INT,
    dmeDateReservation DATETIME,
	dmeDateReservationEnd DATETIME,
    instStatus INT,
    dmeDateCreate DATETIME,
    dmeDateUpdate DATETIME,
    isActiver BIT,
    FOREIGN KEY (idUser) REFERENCES Users(idUser),
    FOREIGN KEY (idBook) REFERENCES Books(idBook)
);

CREATE TABLE WaitReservations (
    idWaitReservation INT PRIMARY KEY IDENTITY(1,1),
    idBook INT,
    idUser INT,
    varPriority VARCHAR(2),
    dmeDateReservation DATETIME,
    dmeDateReservationEnd DATETIME,
    instStatus INT,
    dmeDateCreate DATETIME,
    dmeDateUpdate DATETIME,
    isActive BIT,
	FOREIGN KEY (idUser) REFERENCES Users(idUser),
    FOREIGN KEY (idBook) REFERENCES Books(idBook)
);
