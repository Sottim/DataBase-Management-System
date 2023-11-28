# Dataset 
We will be using a large dataset of baseball statistics for this assignment. This dataset is a compilation of pitching, hitting, and fielding statistics for US Major League Baseball from 1871 through 2014. The data has been cleaned to an extent and organized for the purpose of this assignment.

## 1.1 Description
The design follows these general principles. Each player is assigned a unique number (playerID). All of the information relating to that player is tagged with his playerID. The playerIDs are linked to names and birthdates in the People table1.

The database is comprised of the following main tables:
Table Name Description
People Player names, DOB, and biographical info
Batting batting statistics
Pitching pitching statistics
Fielding fielding statistics

These main tables are supplemented by the following tables:
Table Name Description
AllStarFull All-Star appearances
HallofFame Hall of Fame voting data
Managers managerial statistics
Teams yearly stats and standings
TeamFranchises franchise information
Salaries player salary data
SeriesPost post-season series information
AwardsManagers awards won by managers
AwardsPlayers awards won by players
AwardsShareManagers award voting for manager awards
AwardsSharePlayers award voting for player awards
Appearances details on the positions a player appeared at
Schools list of colleges that players attended
CollegePlaying list of players and the colleges they attended

##  1.2 Schema
Schema diagram for the dataset is attached in the same folder.

## 1.3 Instructions
1. Download the cleaned up data from this link. It is a zip file that contains CSV files for each of the
tables described above. It also contains two sql files to be used for data loading.
2. In order to load this data into you database, you need to first define the structure for these data
tables. Run the file database structure.sql using \i /path/to/database structure.sql
1
In this document we will use ‘table’ and ‘relation’ interchangeably.
3
3. Once the table structures are defined, you can load the data to your database by running
\i /path/to/import database.sql. Note that you first need to change import database.sql by
modifying the path of csv files for the corresponding tables.
4. If you face ”Permission Denied” or similar issues while running the import_database.sql script,
make sure that you’ve placed the csv files in a folder which is accessible by the postgres user. The
easiest way to do this is place it in a subdirectory of C:/Users/public/ on windows, or /tmp/ on
linux/macOS.

## 1.4 Queries 
The description and instructions for the queries can be found in the pdf file attached in the same folder.



