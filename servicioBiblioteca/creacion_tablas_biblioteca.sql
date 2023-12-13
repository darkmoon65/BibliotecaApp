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
    idUser INT,
    idBook INT,
    dmeDateReservation DATETIME,
    instStatus INT,
    dmeDateCreate DATETIME,
    dmeDateUpdate DATETIME,
    isActiver BIT,
    PRIMARY KEY (idUser, idBook),
    FOREIGN KEY (idUser) REFERENCES Users(idUser),
    FOREIGN KEY (idBook) REFERENCES Books(idBook)
);
