/*
 * Note: The dataset in this database was synthetically created using random values.
 * The data generation process involved the use of Python scripts to produce random
 * values for each column. These synthetic datasets were then exported to CSV files
 * and imported into SQL tables.
 * 
 * This synthetic data includes, but is not limited to:
 * - Movies dataset with random titles, genres, durations, qualifications, protagonists, and years.
 * - TV Shows dataset with random series names, genres, number of seasons, qualifications, protagonists, and years.
 * - Users dataset with random usernames, names, surnames, and passwords.
 * 
 * The purpose of this synthetic data is for development, testing, and demonstration purposes only.
 * It does not represent real-world data.
 */

CREATE DATABASE Ireflix;
USE Ireflix;

-- Create Users Table
CREATE TABLE Users (
    Username VARCHAR(35) PRIMARY KEY,
    Name VARCHAR(35) NOT NULL,
    Surname VARCHAR(35) NOT NULL,
    Password VARCHAR(15) NOT NULL
);

-- Create Movies Table
CREATE TABLE Movies (
    ID_Movie INT(6) PRIMARY KEY,
    Movie_Name VARCHAR(35) NOT NULL,
    Genre VARCHAR(20) NOT NULL,
    Duration TIME NOT NULL,
    Qualification TINYINT CHECK (Qualification BETWEEN 1 AND 5),
    Protagonist_Name VARCHAR(35) NOT NULL,
    Protagonist_Surname VARCHAR(35) NOT NULL
);

-- Create Series Table
CREATE TABLE Series (
    ID_Series INT(6) PRIMARY KEY,
    Series_Name VARCHAR(35) NOT NULL,
    Genre VARCHAR(20) NOT NULL,
    Qualification TINYINT CHECK (Qualification BETWEEN 1 AND 5),
    Protagonist_Name VARCHAR(35) NOT NULL,
    Protagonist_Surname VARCHAR(35) NOT NULL,
    No_seasons INT NOT NULL
);

-- Create Actors Table
CREATE TABLE Actors (
    Name VARCHAR(35) NOT NULL,
    Surname VARCHAR(35) PRIMARY KEY,
    Nationality VARCHAR(50)
);

-- Create Directors Table
CREATE TABLE Directors (
    Name VARCHAR(35) NOT NULL,
    Surname VARCHAR(35) PRIMARY KEY,
    Nationality VARCHAR(50)
);

-- Create User Activity Table for Movies
CREATE TABLE User_Movie_Activity (
    Username VARCHAR(35) UNIQUE,
    ID_Movie INT,
    Genre VARCHAR(20),
    FOREIGN KEY (Username) REFERENCES Users(Username),
    FOREIGN KEY (ID_Movie) REFERENCES Movies(ID_Movie)
);

-- Create User Activity Table for Series
CREATE TABLE User_Series_Activity (
    Username VARCHAR(35) UNIQUE,
    ID_Series INT,
    Genre VARCHAR(20),
    FOREIGN KEY (Username) REFERENCES Users(Username),
    FOREIGN KEY (ID_Series) REFERENCES Series(ID_Series)
);

-- Checking for inserted data
select * from actors;
select * from directors;
select * from movies;
select * from series;
select * from user_movie_activity;
select * from users;
select * from user_series_activity;

/* Adding the year */
ALTER TABLE Movies ADD Year INT;
ALTER TABLE Series ADD Year INT;

-- Adding a TempMovies table to then join the year into the correct tables 
CREATE TABLE TempMovies (
    ID_Movie INT PRIMARY KEY,
    Movie_Name VARCHAR(35),
    Genre VARCHAR(20),
    Duration TIME,
    Qualification TINYINT,
    Protagonist_Name VARCHAR(35),
    Protagonist_Surname VARCHAR(35),
    Year INT
);

-- Adding a TempSeries table to then join the year into the correct tables
CREATE TABLE TempSeries (
    ID_Series INT(6) PRIMARY KEY,
    Series_Name VARCHAR(35) NOT NULL,
    Genre VARCHAR(20) NOT NULL,
    Qualification TINYINT CHECK (Qualification BETWEEN 1 AND 5),
    Protagonist_Name VARCHAR(35) NOT NULL,
    Protagonist_Surname VARCHAR(35) NOT NULL,
    Number_Seasons INT NOT NULL,
    Year INT
);

-- Update Movies table from TempMovies
UPDATE Movies m
JOIN TempMovies t ON m.ID_Movie = t.ID_Movie
SET m.Year = t.Year;

-- Update Series table from TempSeries
UPDATE Series s
JOIN TempSeries ts ON s.ID_Series = ts.ID_Series
SET s.Year = ts.Year;

-- Select Year to verify updates
select year from movies;
select year from series;

-- Drop temporary tables
DROP TABLE TempMovies;
DROP TABLE TempSeries;

-- Select all from Movies to verify updates
Select * from movies;
Select * from series;

-- Obtain Number of Movies a Famous Actor Participated In - Samantha Smith
SELECT COUNT(*) as SamanthaSmith_movies
FROM Movies
WHERE Protagonist_Name = 'Samantha' AND Protagonist_Surname = 'Smith';

-- List of Actors Who Were Protagonists in Movies but Not in Series
SELECT DISTINCT A.Name, A.Surname
FROM Actors A
JOIN Movies M ON A.Name = M.Protagonist_Name AND A.Surname = M.Protagonist_Surname
WHERE NOT EXISTS (
    SELECT 1
    FROM Series S
    WHERE S.Protagonist_Name = A.Name AND S.Protagonist_Surname = A.Surname
);

