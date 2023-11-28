BEGIN TRANSACTION;

COPY People FROM 'C:/Users/Public/DBMS/database/People.csv' WITH CSV HEADER DELIMITER AS ',';
COPY TeamsFranchises FROM 'C:/Users/Public/DBMS/database/TeamsFranchises.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Teams FROM 'C:/Users/Public/DBMS/database/Teams.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Batting FROM 'C:/Users/Public/DBMS/database/Batting.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Fielding FROM 'C:/Users/Public/DBMS/database/Fielding.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Pitching FROM 'C:/Users/Public/DBMS/database/Pitching.csv' WITH CSV HEADER DELIMITER AS ',';
COPY AllstarFull FROM 'C:/Users/Public/DBMS/database/AllstarFull.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Appearances FROM 'C:/Users/Public/DBMS/database/Appearances.csv' WITH CSV HEADER DELIMITER AS ',';
COPY AwardsManagers FROM 'C:/Users/Public/DBMS/database/AwardsManagers.csv' WITH CSV HEADER DELIMITER AS ',';
COPY AwardsPlayers FROM 'C:/Users/Public/DBMS/database/AwardsPlayers.csv' WITH CSV HEADER DELIMITER AS ',';
COPY AwardsShareManagers FROM 'C:/Users/Public/DBMS/database/AwardsShareManagers.csv' WITH CSV HEADER DELIMITER AS ',';
COPY AwardsSharePlayers FROM 'C:/Users/Public/DBMS/database/AwardsSharePlayers.csv' WITH CSV HEADER DELIMITER AS ',';
COPY HallOfFame FROM 'C:/Users/Public/DBMS/database/HallOfFame.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Managers FROM 'C:/Users/Public/DBMS/database/Managers.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Salaries FROM 'C:/Users/Public/DBMS/database/Salaries.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Schools FROM 'C:/Users/Public/DBMS/database/Schools.csv' WITH CSV HEADER DELIMITER AS ',';
COPY CollegePlaying FROM 'C:/Users/Public/DBMS/database/CollegePlaying.csv' WITH CSV HEADER DELIMITER AS ',';
COPY SeriesPost FROM 'C:/Users/Public/DBMS/database/SeriesPost.csv' WITH CSV HEADER DELIMITER AS ',';

END TRANSACTION;

