--1--
SELECT PEOPLE.playerID, PEOPLE.nameFirst AS firstname, PEOPLE.nameLast AS lastname, SUM(BATTING.CS) AS total_caught_stealing
FROM PEOPLE
INNER JOIN BATTING ON PEOPLE.playerID = BATTING.playerID
WHERE BATTING.CS IS NOT NULL
GROUP BY PEOPLE.playerID, firstname, lastname
ORDER BY total_caught_stealing DESC, PEOPLE.nameFirst ASC, PEOPLE.nameLast ASC, PEOPLE.playerID ASC
LIMIT 10;   

--2--
SELECT BATTING.playerID, PEOPLE.nameFirst AS firstname, SUM(2*BATTING.h2b + 3*BATTING.h3b + 4*BATTING.hr) AS runscore
FROM PEOPLE, BATTING
WHERE PEOPLE.playerID = BATTING.playerID
GROUP BY BATTING.playerID, PEOPLE.playerID
HAVING SUM(2*BATTING.h2b + 3*BATTING.h3b + 4*BATTING.hr) IS NOT NULL
ORDER BY runscore DESC, firstname DESC, PEOPLE.playerID ASC
LIMIT 10;

--3--
SELECT PEOPLE.playerID, CONCAT(PEOPLE.nameFirst, ' ', PEOPLE.nameLast) as playername, AWARDSSHAREPLAYERS.pointsWon AS total_points
FROM PEOPLE, AWARDSSHAREPLAYERS
WHERE AWARDSSHAREPLAYERS.yearID >= 2000 AND AWARDSSHAREPLAYERS.playerID = PEOPLE.playerID
ORDER BY total_points DESC, AWARDSSHAREPLAYERS.playerID
LIMIT 10;

--4--
SELECT PEOPLE.playerID, PEOPLE.nameFirst AS firstname, PEOPLE.nameLast AS lastname, AVG(BATTING.h / BATTING.ab) AS career_batting_average
FROM PEOPLE, BATTING
WHERE BATTING.ab > 0 
    AND BATTING.ab IS NOT NULL 
    AND BATTING.h IS NOT NULL                                                                   
GROUP BY PEOPLE.playerID
HAVING COUNT(BATTING.yearID) >= 10
ORDER BY career_batting_average DESC, PEOPLE.playerID ASC, PEOPLE.nameFirst ASC, PEOPLE.nameLast ASC
LIMIT 10;

--5--
SELECT PEOPLE.playerID, PEOPLE.nameFirst AS firstname, PEOPLE.nameLast AS lastname, 
    CONCAT(COALESCE(PEOPLE.birthYear::TEXT,''),'-',COALESCE(PEOPLE.birthMonth::TEXT,''),'-',COALESCE(PEOPLE.birthDay::TEXT, '')) AS date_of_birth, 
    COUNT(DISTINCT COALESCE(BATTING.yearID, FIELDING.yearID, PITCHING.yearID)) AS num_seasons
FROM PEOPLE
LEFT OUTER JOIN BATTING ON PEOPLE.playerID = BATTING.playerID
LEFT OUTER JOIN FIELDING ON PEOPLE.playerID = FIELDING.playerID
LEFT OUTER JOIN PITCHING ON PEOPLE.playerID = PITCHING.playerID
GROUP BY PEOPLE.playerID, firstname, lastname, date_of_birth
ORDER BY num_seasons DESC, PEOPLE.playerID ASC, firstname ASC, lastname ASC, date_of_birth ASC;

--6--
SELECT TEAMS.teamID, TEAMS.name AS teamname, TEAMS.franchID AS franchisename, MAX(TEAMS.W) AS num_wins   
FROM TEAMS
WHERE TEAMS.DivWin = 't'
GROUP BY TEAMS.teamID, TEAMS.name, TEAMS.franchID
ORDER BY num_wins DESC, TEAMS.teamID ASC, TEAMS.name ASC, TEAMS.franchID ASC;

--7--
SELECT TEAM1.teamID, TEAM1.name AS teamname, TEAM1.yearID AS seasonid, (TEAM1.W)*1.0 / (TEAM1.G) * 100 AS winning_percentage
FROM TEAMS TEAM1
LEFT JOIN TEAMS TEAM2 ON TEAM1.teamID = TEAM2.teamID 
                    AND ((TEAM1.W * 1.0 / TEAM1.G) * 100) < ((TEAM2.W * 1.0 / TEAM2.G) * 100)           
WHERE TEAM1.W >= 20 AND TEAM2.teamID IS NULL
ORDER BY winning_percentage DESC, TEAM1.teamID ASC, teamname ASC, seasonid ASC      
LIMIT 5;

--8-- 
SELECT TEAMS.teamID, TEAMS.name AS teamname, SALARIES.yearID AS seasonid, SALARIES.playerID, PEOPLE.nameFirst AS player_firstname, PEOPLE.nameLast AS player_lastname, SALARIES.salary
FROM TEAMS, SALARIES, PEOPLE
WHERE SALARIES.salary =
        (SELECT MAX(SALARIES.salary)
        FROM SALARIES
        WHERE SALARIES.teamID = TEAMS.teamID AND SALARIES.yearID = TEAMS.yearID) 
    AND TEAMS.teamID = SALARIES.teamID 
    AND TEAMS.yearID = SALARIES.yearID 
    AND PEOPLE.playerID = SALARIES.playerID
ORDER BY TEAMS.teamID ASC, TEAMS.name ASC, seasonid ASC, SALARIES.playerID ASC, PEOPLE.nameFirst ASC, PEOPLE.nameLast ASC, SALARIES.salary DESC;

--9--

--10--
SELECT PLAYER1.playerID, 
    (SELECT CONCAT(PEOPLE.nameFirst, ' ', PEOPLE.nameLast)
    FROM PEOPLE
    WHERE PEOPLE.playerID = PLAYER1.playerID) AS playername,
    COUNT(DISTINCT PLAYER2.playerID) AS number_of_batchmates
FROM COLLEGEPLAYING AS PLAYER1
JOIN COLLEGEPLAYING AS PLAYER2 ON PLAYER1.schoolID = PLAYER2.schoolID AND PLAYER1.yearID = PLAYER2.yearID
WHERE PLAYER1.playerID != PLAYER2.playerID
GROUP BY PLAYER1.playerID
ORDER BY number_of_batchmates DESC, PLAYER1.playerid ASC;

--11--
SELECT TEAMS.teamID, TEAMS.name AS teamname, COUNT(*) total_WS_wins
FROM TEAMS
JOIN TEAMS AS teamsDuplicate ON TEAMS.teamID = teamsDuplicate.teamID 
                        AND TEAMS.yearID = teamsDuplicate.yearID
WHERE TEAMS.wswin = 't' 
    AND teamsDuplicate.G >= 110
GROUP BY TEAMS.teamID, TEAMS.name
ORDER BY total_WS_wins DESC, TEAMS.teamID ASC, teamname ASC
LIMIT 5;

--12--
SELECT PITCHING.playerID, PEOPLE.nameFirst AS firstname, PEOPLE.nameLast AS LASTNAME, 
    SUM(PITCHING.sv) AS career_saves, COUNT(DISTINCT PITCHING.yearID) AS num_seasons
FROM PITCHING, PEOPLE
WHERE PITCHING.playerID = PEOPLE.playerID
    AND PITCHING.playerID IN 
        (SELECT playerID 
        FROM PITCHING 
        GROUP BY playerID
        HAVING COUNT(DISTINCT yearID) >= 15)
GROUP BY PITCHING.playerID, PEOPLE.nameFirst, PEOPLE.nameLast
HAVING SUM(PITCHING.sv) IS NOT NULL
ORDER BY career_saves DESC, num_seasons DESC, PITCHING.playerID, firstname ASC, lastname ASC
LIMIT 10;

--13--
SELECT PEOPLE.playerID, PEOPLE.nameFirst AS firstname, PEOPLE.nameLast AS lastname, 
    LOWER(CONCAT(COALESCE(PEOPLE.birthCity::TEXT,''),' ', COALESCE(PEOPLE.birthState::TEXT,''),' ',COALESCE(PEOPLE.birthCountry::TEXT,''))) AS birth_address, 
    TEAM1.name AS first_teamname, TEAM2.name AS second_teamname
FROM PEOPLE, PITCHING
JOIN (SELECT PITCHING.playerID, MIN(yearID) AS year1 
    FROM PITCHING
    GROUP BY PITCHING.playerID
    HAVING COUNT(DISTINCT teamID) >= 5) AS minimumYear ON minimumYear.playerID = PITCHING.playerID
LEFT OUTER JOIN TEAMS AS TEAM1 ON PITCHING.teamID = TEAM1.teamID 
                                AND minimumYear.year1 = TEAM1.yearID
LEFT OUTER JOIN 
    (SELECT playerID, teamID, MIN(PITCHING.yearID) AS year2
        FROM PITCHING
        WHERE (playerID, teamID) NOT IN (SELECT playerID, MIN(teamID)
                                        FROM PITCHING
                                        GROUP BY playerID)
        GROUP BY playerID, teamID) AS secondYear ON minimumYear.playerID = secondYear.playerID 
LEFT OUTER JOIN TEAMS AS TEAM2 ON secondYear.teamID = TEAM2.teamID 
                            AND secondYear.year2 = TEAM2.yearID
WHERE PEOPLE.playerID = PITCHING.playerID 
ORDER BY PITCHING.playerID ASC, firstname ASC, lastname ASC, birth_address ASC, first_teamname ASC, second_teamname ASC;

--14--

--15--
SELECT TEAMS.teamID, TEAMS.name AS teamname, TEAMS.yearID AS seasonid, MANAGERS.playerID AS managerid, PEOPLE.nameFirst AS managerfirstname, PEOPLE.nameLast AS managerlastname
FROM TEAMS, MANAGERS, PEOPLE
WHERE TEAMS.teamID = MANAGERS.teamID AND TEAMS.yearID = MANAGERS.yearID AND MANAGERS.playerID = PEOPLE.playerID
        AND TEAMS.yearID >= 2000 
        AND TEAMS.yearID <= 2010 
        AND MANAGERS.teamID = TEAMS.teamID
        AND (MANAGERS.inseason = 0 OR MANAGERS.inseason = 1)
ORDER BY TEAMS.teamID ASC, teamname ASC, seasonid DESC, managerid ASC, managerfirstname ASC, managerlastname ASC;

--16--
SELECT AWARDSPLAYERS.playerID, COALESCE(MAX(SCHOOLS.schoolname), '') AS college_name, 
    COUNT(AWARDSPLAYERS.awardID) AS total_awards
FROM AWARDSPLAYERS
LEFT JOIN COLLEGEPLAYING ON AWARDSPLAYERS.playerID = COLLEGEPLAYING.playerID
LEFT JOIN SCHOOLS ON COLLEGEPLAYING.schoolID = SCHOOLS.schoolID
WHERE COLLEGEPLAYING.yearID = 
        (SELECT MAX(yearID)
        FROM COLLEGEPLAYING 
        WHERE COLLEGEPLAYING.playerID = AWARDSPLAYERS.playerID)
        OR COLLEGEPLAYING.yearID IS NULL
GROUP BY AWARDSPLAYERS.playerID
ORDER BY total_awards DESC, college_name ASC, AWARDSPLAYERS.playerID ASC
LIMIT 10;

--17--
SELECT PEOPLE1.playerID, PEOPLE1.nameFirst AS firstname, PEOPLE1.nameLast AS lastname, AWARDSPLAYERS1.awardID AS playerawardid, AWARDSPLAYERS1.yearID AS playerawardyear, AWARDSMANAGERS1.awardID AS managerawardid, AWARDSMANAGERS1.yearID AS managerawardyear
FROM PEOPLE PEOPLE1
JOIN (SELECT playerID, MIN(yearID) AS min_year
        FROM AWARDSPLAYERS
        GROUP BY playerID) A ON PEOPLE1.playerID = A.playerID
JOIN AWARDSPLAYERS AWARDSPLAYERS1 ON A.playerID = AWARDSPLAYERS1.playerID 
                                AND A.min_year = AWARDSPLAYERS1.yearID
JOIN (SELECT playerID, MIN(yearID) AS min_year
    FROM AWARDSMANAGERS
    GROUP BY playerID) B ON PEOPLE1.playerID = B.playerID
JOIN AWARDSMANAGERS AWARDSMANAGERS1 ON B.playerID = AWARDSMANAGERS1.playerID AND B.min_year = AWARDSMANAGERS1.yearID
ORDER BY PEOPLE1.playerID ASC, firstname ASC, lastname ASC;

--18--

--19--

--20--
SELECT DISTINCT SCHOOLS.schoolID, SCHOOLS.schoolname AS schoolname, CONCAT(SCHOOLS.schoolcity, ' ', SCHOOLS.schoolstate) AS schooladdr, PEOPLE.playerID, PEOPLE.nameFirst AS firstname, PEOPLE.nameLast AS lastname
FROM 
    (SELECT COLLEGEPLAYING.schoolID, COUNT(COLLEGEPLAYING.playerID) AS player_number
    FROM COLLEGEPLAYING, SCHOOLS
    GROUP BY COLLEGEPLAYING.schoolID
    ORDER BY player_number DESC 
    LIMIT 5) AS Top5Schools, SCHOOLS, PEOPLE, COLLEGEPLAYING
WHERE PEOPLE.playerID = COLLEGEPLAYING.playerID 
    AND Top5Schools.schoolID = COLLEGEPLAYING.schoolID
    AND Top5Schools.schoolID = SCHOOLS.schoolID
ORDER BY SCHOOLS.schoolID ASC, schoolname ASC, schooladdr ASC, PEOPLE.playerID ASC, firstname ASC, lastname ASC;

--21--
SELECT AWARDSSHAREPLAYERS.awardID, AWARDSSHAREPLAYERS.yearID AS seasonid, AWARDSSHAREPLAYERS.playerID, AWARDSSHAREPLAYERS.pointsWon AS playerpoints, 
    (SELECT AVG(seasonSpecific.pointsWon)
    FROM AWARDSSHAREPLAYERS AS seasonSpecific
    WHERE AWARDSSHAREPLAYERS.yearID = seasonSpecific.yearID
        AND AWARDSSHAREPLAYERS.awardID = seasonSpecific.awardID) AS averagepoints
FROM AWARDSSHAREPLAYERS
WHERE AWARDSSHAREPLAYERS.pointsWon >= 
    (SELECT AVG(seasonSpecific.pointsWon)
    FROM AWARDSSHAREPLAYERS AS seasonSpecific
    WHERE AWARDSSHAREPLAYERS.yearID = seasonSpecific.yearID
        AND AWARDSSHAREPLAYERS.awardID = seasonSpecific.awardID)
ORDER BY AWARDSSHAREPLAYERS.awardID ASC, seasonid ASC, playerpoints DESC, AWARDSSHAREPLAYERS.playerID;

--22--
SELECT PEOPLE.playerID, CONCAT(PEOPLE.nameFirst, ' ', PEOPLE.nameLast) AS playername, PEOPLE.deathYear IS NULL AS alive
FROM PEOPLE
LEFT OUTER JOIN AWARDSPLAYERS ON PEOPLE.playerID = AWARDSPLAYERS.playerID
LEFT OUTER JOIN AWARDSMANAGERS ON PEOPLE.playerID = AWARDSMANAGERS.playerID
WHERE AWARDSPLAYERS.playerID IS NULL 
    AND AWARDSMANAGERS.playerID IS NULL
ORDER BY PEOPLE.playerID ASC, playername ASC;
