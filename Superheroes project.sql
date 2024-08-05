CREATE DATABASE SUPERHEROS;
USE SUPERHEROS;

CREATE TABLE HEROES(
	HeroID INT PRIMARY KEY,
    Name VARCHAR(255),
    RealName VARCHAR(255),
    Gender VARCHAR(255),
    Origin VARCHAR(255)
);

INSERT INTO HEROES(HeroID,Name,RealName,Gender,Origin)
VALUES
(1	,"Spider-Man", "Peter Parker",	"Male",	"New York City"),
(2	,"Wonder Woman", "Diana Prince",	"Female",	"Themyscira"),
(3	,"Batman",	"Bruce Wayne",	"Male",	"Gotham City"),
(4	,"Iron Man","Tony Stark",	"Male",	"Long Island New York"),
(5	,"Black Widow",	"Natasha Romanoff",	"Female",	"Stalingrad");

select * from HEROES;

CREATE TABLE ABILITIES(
	AbilityID int PRIMARY KEY,
    Ability Varchar(255)
);

INSERT INTO ABILITIES(AbilityID,Ability) 
VALUES
(1	,"Super Strength"),
(2	,"Flight"),
(3	,"Intelligence"),
(4	,"Combat Skills"),
(5	,"Web-Slinging");

SELECT * FROM ABILITIES;

CREATE TABLE HEROABILITIES (
    HeroID INT,
    AbilityID INT,
    PRIMARY KEY (HeroID, AbilityID),
    FOREIGN KEY (HeroID) REFERENCES HEROES(HeroID),
    FOREIGN KEY (AbilityID) REFERENCES ABILITIES(AbilityID)
);

INSERT INTO HEROABILITIES 
VALUES
(1	,1),
(1	,5),
(2	,1),
(2	,2),
(3	,3),
(3	,4),
(4	,1),
(4	,3),
(5	,4);

CREATE TABLE Affiliations (
    AffiliationID INT PRIMARY KEY,
    AffiliationName VARCHAR(50)
);
INSERT INTO AFFILIATIONS(AffiliationID,AffiliationName)
VALUES
(1	,"Avengers"),
(2	,"Justice League"),
(3	,"X-Men");

CREATE TABLE HeroAffiliations (
    HeroID INT,
    AffiliationID INT,
    PRIMARY KEY (HeroID, AffiliationID),
    FOREIGN KEY (HeroID) REFERENCES HEROES(HeroID),
    FOREIGN KEY (AffiliationID) REFERENCES Affiliations(AffiliationID)
);

INSERT INTO HEROAFFILIATIONS
VALUES
(1	,1),
(2	,2),
(3	,2),
(4	,1),
(5	,1);

select * FROM HEROAFFILIATIONS;

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(100),
    ReleaseYear INT,
    BoxOffice VARCHAR(20)
);

INSERT INTO MOVIES
VALUES
(1	,"Spider-Man: Homecoming"	,"2017"	,"880M"),
(2	,"Wonder Woman"				,"2017"	,"821M"),
(3	,"The Dark Knight"			,"2008"	,"1005M"),
(4	,"Iron Man"					,"2008"	,"585M"),
(5	,"Black Widow"				,"2021"	,"379M");

CREATE TABLE HeroMovies (
    HeroID INT,
    MovieID INT,
    PRIMARY KEY (HeroID, MovieID),
    FOREIGN KEY (HeroID) REFERENCES Heroes(HeroID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

INSERT INTO HEROMOVIES
VALUES
(1	,1),
(2	,2),
(3	,3),
(4	,4),
(5	,5);

CREATE TABLE Villains (
    VillainID INT PRIMARY KEY,
    Name VARCHAR(50),
    RealName VARCHAR(50),
    Gender VARCHAR(10),
    Origin VARCHAR(50)
);

insert into VILLAINS
VALUES
(1	,"Green Goblin"	,"Norman Osborn","Male"	,"New York City"),
(2	,"Ares"			,"None"			,"Male"	,"Olympus"),
(3	,"Joker"		,"Unknown"		,"Male"	,"Gotham City"),
(4	,"Mandarin"		,"Unknown"		,"Male"	,"China"),
(5	,"Taskmaster"	,"Tony Masters"	,"Male"	,"Unknown");

CREATE TABLE VillainAbilities (
    VillainID INT,
    AbilityID INT,
    PRIMARY KEY (VillainID, AbilityID),
    FOREIGN KEY (VillainID) REFERENCES Villains(VillainID),
    FOREIGN KEY (AbilityID) REFERENCES Abilities(AbilityID)
);

INSERT INTO VILLAINABILITIES
VALUES
(1	,1),
(1	,5),
(2	,1),
(2	,2),
(3	,3),
(3	,4),
(4	,3),
(4	,4),
(5	,4);

CREATE TABLE Battles (
    BattleID INT PRIMARY KEY,
    HeroID INT,
    VillainID INT,
    Location VARCHAR(50),
    Outcome VARCHAR(50),
    FOREIGN KEY (HeroID) REFERENCES Heroes(HeroID),
    FOREIGN KEY (VillainID) REFERENCES Villains(VillainID)
);

INSERT INTO BATTLES
VALUES
(1	,1	,1	,"New York City"	,"Hero Wins"),
(2	,2	,2	,"Themyscira"		,"Hero Wins"),
(3	,3	,3	,"Gotham City"		,"Hero Wins"),
(4	,4	,4	,"China"			,"Hero Wins"),
(5	,5	,5	,"Unknown Location"	,"Villain Wins");


--------------------- Queries ----------------------------
-- List all movies featuring 'Spider-Man'

SELECT m.Title, m.ReleaseYear
FROM Movies m
JOIN HeroMovies hm ON m.MovieID = hm.MovieID
JOIN Heroes h ON hm.HeroID = h.HeroID
WHERE h.Name = 'Spider-Man';

-- List all battles where the hero won

SELECT b.BattleID, h.Name AS Hero, v.Name AS Villain, b.Location
FROM Battles b
JOIN Heroes h ON b.HeroID = h.HeroID
JOIN Villains v ON b.VillainID = v.VillainID
WHERE b.Outcome = 'Hero Wins';

-- Find all abilities of villains who have fought 'Batman'

SELECT DISTINCT a.Ability
FROM Abilities a
JOIN VillainAbilities va ON a.AbilityID = va.AbilityID
JOIN Battles b ON va.VillainID = b.VillainID
JOIN Heroes h ON b.HeroID = h.HeroID
WHERE h.Name = 'Batman';

-- Find the highest-grossing movie featuring 'Iron Man'

SELECT m.Title, m.BoxOffice
FROM Movies m
JOIN HeroMovies hm ON m.MovieID = hm.MovieID
JOIN Heroes h ON hm.HeroID = h.HeroID
WHERE h.Name = 'Iron Man'
ORDER BY CAST(REPLACE(m.BoxOffice, 'M', '') AS DECIMAL(10, 2)) DESC
LIMIT 1;

-- List all heroes who have never lost a battle

SELECT h.Name
FROM Heroes h
LEFT JOIN Battles b ON h.HeroID = b.HeroID
WHERE b.Outcome IS NULL OR b.Outcome = 'Hero Wins'
GROUP BY h.HeroID
HAVING COUNT(CASE WHEN b.Outcome = 'Villain Wins' THEN 1 END) = 0;

-- Find all battles that took place in New York City and their outcomes.

SELECT H.Name AS HeroName, V.Name AS VillainName, B.Outcome
FROM Battles B
JOIN Heroes H ON B.HeroID = H.HeroID
JOIN Villains V ON B.VillainID = V.VillainID
WHERE B.Location = 'New York City';

-- Get a list of heroes and the total number of movies they appeared in.

SELECT H.Name, COUNT(M.MovieID) AS MovieCount
FROM Heroes H
JOIN HeroMovies HM ON H.HeroID = HM.HeroID
JOIN Movies M ON HM.MovieID = M.MovieID
GROUP BY H.Name;

-- Find all movies released in or after 2010 along with their box office collection.

SELECT Title, ReleaseYear, BoxOffice
FROM Movies
WHERE ReleaseYear >= 2010;

-- List all heroes who have super strength as one of their abilities.

SELECT H.Name
FROM Heroes H
JOIN HeroAbilities HA ON H.HeroID = HA.HeroID
JOIN Abilities A ON HA.AbilityID = A.AbilityID
WHERE A.Ability = 'Super Strength';

-- Find all battles where a specific hero (e.g., Wonder Woman) participated and the outcomes.

SELECT B.Location, B.Outcome, V.Name AS VillainName
FROM Battles B
JOIN Heroes H ON B.HeroID = H.HeroID
JOIN Villains V ON B.VillainID = V.VillainID
WHERE H.Name = 'Wonder Woman';

-- Get the list of villains and their abilities.

SELECT V.Name, A.Ability
FROM Villains V
JOIN VillainAbilities VA ON V.VillainID = VA.VillainID
JOIN Abilities A ON VA.AbilityID = A.AbilityID;

-- Find all movies in which a specific hero (e.g., Iron Man) has appeared.

SELECT M.Title, M.ReleaseYear, M.BoxOffice
FROM Movies M
JOIN HeroMovies HM ON M.MovieID = HM.MovieID
JOIN Heroes H ON HM.HeroID = H.HeroID
WHERE H.Name = 'Iron Man';

-- List all heroes and their affiliations.

SELECT H.Name, A.AffiliationName
FROM Heroes H
JOIN HeroAffiliations HA ON H.HeroID = HA.HeroID
JOIN Affiliations A ON HA.AffiliationID = A.AffiliationID;

-- Find all abilities of a specific hero (e.g., Spider-Man).

SELECT A.Ability
FROM Abilities A
JOIN HeroAbilities HA ON A.AbilityID = HA.AbilityID
JOIN Heroes H ON HA.HeroID = H.HeroID
WHERE H.Name = 'Spider-Man';

-- List all heroes along with their real names and origins.

SELECT Name, RealName, Origin FROM Heroes;

----------------------------- END ---------------------------------------