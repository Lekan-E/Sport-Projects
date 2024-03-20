# Drop existing database with the same name
DROP DATABASE IF EXISTS ArsenalDB;

# Create the database
CREATE DATABASE IF NOT EXISTS ArsenalDB;
USE ArsenalDB;

# Drop existing table
DROP TABLE IF EXISTS league_table,
seasonratings,
player_season,
p_possession_stats,
c_possession_stats,
p_defensive_stats,
c_defensive_stats,
p_goalkeeping_stats,
c_goalkeeping_stats,
p_miscell_stats,
c_miscell_stats,
p_passing_stats,
c_passing_stats,
p_per_90,
c_per_90,
p_shooting_stats,
c_shooting_stats,
p_standard_stats,
c_standard_stats;

# --------------------------------------------------------------------------
# Season Ratings Table
# --------------------------------------------------------------------------
CREATE TABLE seasonratings(
	SeasonID INT NOT NULL,
    PlayerName VARCHAR(80) NOT NULL,
    SeasonRating DECIMAL(4,2) NOT NULL
);

INSERT INTO seasonratings
SELECT s.season_id, PlayerName, Ratings as AvgRating
FROM temp_seasonratings ts
JOIN season s ON s.season_name = ts.season_name;

# Update player names to match players table
UPDATE seasonratings
SET PlayerName = 'Gabriel Dos Santos'
WHERE PlayerName = 'Gabriel'; 

# --------------------------------------------------------------------------
# Standard Stats Table
# --------------------------------------------------------------------------
# Players
CREATE TABLE p_standard_stats(
	SeasonID INT NOT NULL,
    PlayerID INT NOT NULL,
    Player VARCHAR(80),
    Position TEXT, 
	MatchesPlayed INT NOT NULL, 
	Starts INT NOT NULL, 
	MinutesPlayed INT NOT NULL,
	Goals INT NOT NULL,
	Assists INT NOT NULL,
	GoalContribution INT NOT NULL, 
	NonPenaltyGoals INT NOT NULL,
	PenaltyScored INT NOT NULL, 
	YellowCard INT NOT NULL, 
	RedCard INT NOT NULL, 
	xG DECIMAL(3,1) NOT NULL, 
	xAG DECIMAL(3,1) NOT NULL, 
	ProgressiveCarries INT NOT NULL, 
	ProgressivePasses INT NOT NULL, 
	ProgressivePassesRecevied INT NOT NULL
);

# Insert values into table
INSERT INTO p_standard_stats
SELECT s.season_id as SeasonID, p.ID as PlayerID, Player ,Position, MatchesPlayed, Starts ,MinutesPlayed, Goals, Assists, 
GoalContribution, NonPenaltyGoals, PenaltyScored, YellowCard, RedCard, xG, xAG, ProgressiveCarries, ProgressivePasses, ProgressivePassesRecevied
FROM temp_players_standard_stats tss
JOIN players p ON p.FullName = tss.Player
JOIN season s ON s.season_name = tss.season_name;

-- Assign Foreign Key 1
ALTER TABLE p_standard_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

-- Assign Foreign Key 2
ALTER TABLE p_standard_stats
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);

# Club
CREATE TABLE c_standard_stats(
	SeasonID INT NOT NULL,
	MatchesPlayed INT NOT NULL, 
	Goals INT NOT NULL,
    xG DECIMAL(3,1) NOT NULL,
	Assists INT NOT NULL,
    xAG DECIMAL(3,1) NOT NULL,
	GoalContribution INT NOT NULL, 
	NonPenaltyGoals INT NOT NULL,
	PenaltyScored INT NOT NULL, 
	YellowCard INT NOT NULL, 
	RedCard INT NOT NULL, 
	ProgressiveCarries INT NOT NULL, 
	ProgressivePasses INT NOT NULL, 
	ProgressivePassesRecevied INT NOT NULL
);

INSERT INTO c_standard_stats
SELECT s.season_id, MatchesPlayed, Goals,xG, Assists, xAG,
GoalContribution, NonPenaltyGoals, PenaltyScored, YellowCard, RedCard, ProgressiveCarries, ProgressivePasses, ProgressivePassesRecevied
FROM temp_club_standard_stats tcss
JOIN season s ON s.season_name = tcss.season_name;

-- Assign Foreign Key 1
ALTER TABLE c_standard_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);


# --------------------------------------------------------------------------
# Shooting Stats Table
# --------------------------------------------------------------------------
# Players
CREATE TABLE p_shooting_stats(
	SeasonID INT NOT NULL,
    PlayerID INT NOT NULL,
    Player VARCHAR(80),
    Goals INT NOT NULL,
    Shots INT NOT NULL, 
    ShotsonTarget INT NOT NULL, 
    ShotsonTargetPercent DECIMAL(4,1) NOT NULL, 
    GoalsPerShot DECIMAL(3,1) NOT NULL, 
    GoalsPerShotsonTarget DECIMAL(3,1) NOT NULL, 
    ShotDistance DECIMAL(3,1) NOT NULL, 
    xG DECIMAL(3,1) NOT NULL
);

# Insert values into the table
INSERT INTO p_shooting_stats
SELECT s.season_id as SeasonID, p.ID as PlayerID, Player, Goals, Shots, ShotsonTarget, ShotsonTargetPercent , GoalsPerShot, GoalsPerShotsonTarget, ShotDistance, xG
FROM temp_players_shooting_stats ts
JOIN players p ON p.FullName = ts.Player
JOIN season s ON s.season_name = ts.season_name;

-- Assign Foreign Key 1
ALTER TABLE p_shooting_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

-- Assign Foreign Key 2
ALTER TABLE p_shooting_stats
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);

# Club
CREATE TABLE c_shooting_stats(
	SeasonID INT NOT NULL,
    Goals INT NOT NULL,
    xG DECIMAL(3,1) NOT NULL,
    Shots INT NOT NULL, 
    ShotsonTarget INT NOT NULL, 
    ShotsonTargetPercent DECIMAL(4,1) NOT NULL, 
    GoalsPerShot DECIMAL(3,1) NOT NULL, 
    GoalsPerShotsonTarget DECIMAL(3,1) NOT NULL, 
    ShotDistance DECIMAL(3,1) NOT NULL
);

INSERT INTO c_shooting_stats
SELECT s.season_id, Goals, xG, Shots, ShotsonTarget, ShotsonTargetPercent , GoalsPerShot, GoalsPerShotsonTarget, ShotDistance
FROM temp_club_shooting_stats tcs
JOIN season s ON s.season_name = tcs.season_name;

-- Assign Foreign Key 1
ALTER TABLE c_shooting_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

# --------------------------------------------------------------------------
# Passing Stats Table
# --------------------------------------------------------------------------
# Players
CREATE TABLE p_passing_stats(
	SeasonID INT NOT NULL,
    PlayerID INT NOT NULL,
    Player VARCHAR(80), 
	CompletedPass INT NOT NULL, 
	AttemptedPass INT NOT NULL, 
	PassCompletionPercent DECIMAL(3,1) NOT NULL, 
	KeyPass INT NOT NULL,
	KeyPass_Final3rd INT NOT NULL, 
	PassesPenaltyArea INT NOT NULL
);

INSERT INTO p_passing_stats
SELECT  s.season_id as SeasonID, p.ID as PlayerID, Player ,CompletedPass, AttemptedPass, PassCompletionPercent, KeyPass, KeyPass_Final3rd,
PassesPenaltyArea
FROM temp_players_passing_stats tps
JOIN players p ON p.FullName = tps.Player
JOIN season s ON s.season_name = tps.season_name;

-- Assign Foreign Key 1
ALTER TABLE p_passing_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

-- Assign Foreign Key 2
ALTER TABLE p_passing_stats
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);

# Club
CREATE TABLE c_passing_stats(
	SeasonID INT NOT NULL,
	CompletedPass INT NOT NULL, 
	AttemptedPass INT NOT NULL, 
	PassCompletionPercent DECIMAL(3,1) NOT NULL, 
	KeyPass INT NOT NULL,
	KeyPass_Final3rd INT NOT NULL, 
	PassesPenaltyArea INT NOT NULL
);

INSERT INTO c_passing_stats
select s.season_id, tcp.CompletedPass, tcp.AttemptedPass, PassCompletionPercent, tcp.KeyPass, KeyPass_Final3rd, tcp.PassesPenaltyArea
from temp_club_passing_stats tcp
join season s ON s.season_name = tcp.season_name;

-- Assign Foreign Key 1
ALTER TABLE c_passing_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);


# --------------------------------------------------------------------------
# Possession Stats Table
# --------------------------------------------------------------------------
# Players
CREATE TABLE p_possession_stats(
	SeasonID INT NOT NULL,
    PlayerID INT NOT NULL,
    Player VARCHAR(80),
    Touches INT NOT NULL, 
	TouchesDefense INT NOT NULL, 
	AttemptedTakeons INT NOT NULL, 
	SuccessfulTakeons INT NOT NULL, 
	SuccessfulTakeonsPercent DECIMAL(4,1) NOT NULL, 
	Carries INT NOT NULL, 
	TotalCarryDistance INT NOT NULL
);

INSERT INTO p_possession_stats
SELECT s.season_id as SeasonID, p.ID as PlayerID, Player, Touches , TouchesDefense, AttemptedTakeons, SuccessfulTakeons, SuccessfulTakeonsPercent, Carries, TotalCarryDistance
FROM temp_players_possession_stats tpps
JOIN players p ON p.FullName = tpps.Player
JOIN season s ON s.season_name = tpps.season_name;

-- Assign Foreign Key 1
ALTER TABLE p_possession_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

-- Assign Foreign Key 2
ALTER TABLE p_possession_stats
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);

# Club
CREATE TABLE c_possession_stats(
	SeasonID INT NOT NULL,
    Touches INT NOT NULL, 
	TouchesDefense INT NOT NULL, 
	AttemptedTakeons INT NOT NULL, 
	SuccessfulTakeons INT NOT NULL, 
	SuccessfulTakeonsPercent DECIMAL(4,1) NOT NULL, 
	Carries INT NOT NULL, 
	TotalCarryDistance INT NOT NULL
);

INSERT INTO c_possession_stats
SELECT s.season_id, Touches , TouchesDefense, AttemptedTakeons, SuccessfulTakeons, SuccessfulTakeonsPercent, Carries, TotalCarryDistance
FROM temp_club_possession_stats tcps
JOIN season s ON s.season_name = tcps.season_name;

-- Assign Foreign Key 1
ALTER TABLE c_possession_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

# --------------------------------------------------------------------------
# Miscell Stats Table
# --------------------------------------------------------------------------
# Players
CREATE TABLE p_miscell_stats(
	SeasonID INT NOT NULL,
    PlayerID INT NOT NULL,
    Player VARCHAR(80),
	FoulsCommitted INT NOT NULL, 
	FoulsDrawn INT NOT NULL,
	Offside INT NOT NULL, 
	BallRecoveries INT NOT NULL, 
	AerialDuelsWon INT NOT NULL, 
	AerialDuelsLost INT NOT NULL
);

INSERT INTO p_miscell_stats
SELECT s.season_id as SeasonID, p.ID as PlayerID, Player, FoulsCommitted, FoulsDrawn, Offside,BallRecoveries,AerialDuelsWon, AerialDuelsLost
FROM temp_players_miscell_stats tms
JOIN players p ON p.FullName = tms.Player
JOIN season s ON s.season_name = tms.season_name;

-- Assign Foreign Key 1
ALTER TABLE p_miscell_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

-- Assign Foreign Key 2
ALTER TABLE p_miscell_stats
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);


# Club
CREATE TABLE c_miscell_stats(
	SeasonID INT NOT NULL,
	FoulsCommitted INT NOT NULL, 
	FoulsDrawn INT NOT NULL,
	Offside INT NOT NULL, 
	BallRecoveries INT NOT NULL, 
	AerialDuelsWon INT NOT NULL, 
	AerialDuelsLost INT NOT NULL
);

# Insert into club table
INSERT INTO c_miscell_stats
select s.season_id as SeasonID, FoulsCommitted, FoulsDrawn, Offside,BallRecoveries,AerialDuelsWon, AerialDuelsLost
from temp_club_miscell_stats tcm
join season s ON s.season_name = tcm.season_name;

-- Assign Foreign Key 1
ALTER TABLE c_miscell_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

# --------------------------------------------------------------------------
# Goalkeeping Stats Table
# --------------------------------------------------------------------------
# Players
CREATE TABLE p_goalkeeping_stats(
	SeasonID INT NOT NULL,
    PlayerID INT NOT NULL,
    Player VARCHAR(80),
    MatchesPlayed INT NOT NULL, 
	MinutesPlayed INT NOT NULL, 
	GoalAgainst INT NOT NULL ,
	ShotsOnTargetAgaint INT NOT NULL, 
	Saves INT NOT NULL,
	SavePercentage DECIMAL(4,1) NOT NULL, 
	CleanSheet INT NOT NULL,
	PenaltyFaced INT NOT NULL,
	PenaltySaved INT NOT NULL
);

INSERT INTO p_goalkeeping_stats
SELECT s.season_id as SeasonID, p.ID as PlayerID, Player,MP,Min, GA,SoTA,Saves, SavePercentage,CS,PKatt, PKsv
FROM temp_players_goalkeeping_stats tg
JOIN players p ON p.FullName = tg.Player
JOIN season s ON s.season_name = tg.season_name;

-- Assign Foreign Key 1
ALTER TABLE p_goalkeeping_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

-- Assign Foreign Key 2
ALTER TABLE p_goalkeeping_stats
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);

# Club
CREATE TABLE c_goalkeeping_stats(
	SeasonID INT NOT NULL,
	GoalAgainst INT NOT NULL ,
	ShotsOnTargetAgaint INT NOT NULL, 
	Saves INT NOT NULL,
	SavePercentage DECIMAL(4,1) NOT NULL, 
	CleanSheet INT NOT NULL,
	PenaltyFaced INT NOT NULL,
	PenaltySaved INT NOT NULL
);

INSERT INTO c_goalkeeping_stats
SELECT s.season_id as SeasonID, GA,SoTA,Saves, SavePercentage, CS,PKatt, PKsv
FROM temp_club_goalkeeping_stats tcg
JOIN season s ON s.season_name = tcg.season_name;

-- Assign Foreign Key 1
ALTER TABLE c_goalkeeping_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

# --------------------------------------------------------------------------
# Defensive Stats Table
# --------------------------------------------------------------------------
# Players
CREATE TABLE p_defensive_stats(
	SeasonID INT NOT NULL,
    PlayerID INT NOT NULL,
    Player VARCHAR(80),
    Tackles INT NOT NULL, 
	TacklesWon INT NOT NULL, 
	Blocks INT NOT NULL, 
	Interceptions INT NOT NULL, 
	Clearances INT NOT NULL
);

INSERT INTO p_defensive_stats
SELECT s.season_id as SeasonID,  p.ID as PlayerID, Player, Tkl,TklW, Blocks, Interceptions, Clr
FROM temp_players_defensive_stats td
JOIN players p ON p.FullName = td.Player
JOIN season s ON s.season_name = td.season_name;

-- Assign Foreign Key 1
ALTER TABLE p_defensive_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

-- Assign Foreign Key 2
ALTER TABLE p_defensive_stats
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);

# Club
CREATE TABLE c_defensive_stats(
	SeasonID INT NOT NULL,
    Tackles INT NOT NULL, 
	TacklesWon INT NOT NULL, 
	Blocks INT NOT NULL, 
	Interceptions INT NOT NULL, 
	Clearances INT NOT NULL
);

INSERT INTO c_defensive_stats
SELECT s.season_id as SeasonID, Tkl,TklW, Blocks, Interceptions, Clr
FROM temp_club_defensive_stats tcd
JOIN season s ON s.season_name = tcd.season_name;

-- Assign Foreign Key 1
ALTER TABLE c_defensive_stats
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

# --------------------------------------------------------------------------
# Per90 Stats Table
# --------------------------------------------------------------------------
#Players
CREATE TABLE p_per_90(
	SeasonID INT NOT NULL,
    PlayerID INT NOT NULL,
    Player VARCHAR(80),
    Position TEXT,
    Goals_Per90 DECIMAL(4,1) NOT NULL, 
    Assists_Per90 DECIMAL(4,1) NOT NULL, 
    GoalContribution_Per90 DECIMAL(4,1) NOT NULL, 
    xG_Per90 DECIMAL(4,1) NOT NULL, 
    xAG_Per90 DECIMAL(4,1) NOT NULL, 
    Shots_Per90 DECIMAL(4,1) NOT NULL, 
    ShotsonTarget_Per90 DECIMAL(4,1) NOT NULL
);

INSERT INTO p_per_90
SELECT s.season_id as SeasonID, p.ID as PlayerID, tps.Player, Position, Goals_Per90, Assists_Per90, GoalContribution_Per90, xG_Per90, xAG_Per90, Shots_Per90, ShotsonTarget_Per90
FROM temp_players_standard_stats tps
JOIN temp_players_shooting_stats ts ON ts.Player = tps.Player AND ts.season_name = tps.season_name
JOIN players p ON p.FullName = tps.Player
JOIN season s ON s.season_name = tps.season_name;

-- Assign Foreign Key 1
ALTER TABLE p_per_90
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

-- Assign Foreign Key 2
ALTER TABLE p_per_90
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);

# Club

CREATE TABLE c_per_90(
	SeasonID INT NOT NULL,
    Goals_Per90 DECIMAL(4,1) NOT NULL, 
    Assists_Per90 DECIMAL(4,1) NOT NULL, 
    GoalContribution_Per90 DECIMAL(4,1) NOT NULL, 
    xG_Per90 DECIMAL(4,1) NOT NULL, 
    xAG_Per90 DECIMAL(4,1) NOT NULL, 
    Shots_Per90 DECIMAL(4,1) NOT NULL, 
    ShotsonTarget_Per90 DECIMAL(4,1) NOT NULL
);

INSERT INTO c_per_90
SELECT s.season_id, Goals_Per90, Assists_Per90, GoalContribution_Per90, xG_Per90, xAG_Per90, Shots_Per90, ShotsonTarget_Per90
FROM temp_club_standard_stats tcss
JOIN temp_club_shooting_stats tcs ON tcs.season_name = tcss.season_name
JOIN season s ON s.season_name = tcss.season_name;

-- Assign Foreign Key 1
ALTER TABLE c_per_90
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

# --------------------------------------------------------------------------
# League Table
# --------------------------------------------------------------------------
CREATE TABLE league_table(
	SeasonID INT NOT NULL,
    LeaguePosition INT NOT NULL,
    MatchesPlayed	INT NOT NULL,
    Wins INT,
    Draw INT,
    Loss INT,
    GoalsScored INT,
    xG DECIMAL(5,2),
    GoalsAgainst INT,
    xGA DECIMAL(5,2),
    GoalDifference INT,
    Points INT NOT NULL,
    xPTS DECIMAL(5,2)
);

# Insert Table
INSERT INTO league_table (SeasonID, LeaguePosition, MatchesPlayed, Wins, Draw, Loss, GoalsScored, xG, GoalsAgainst, xGA, GoalDifference, Points, xPTS)
SELECT s.season_id as SeasonID,
		tlt.Position as LeaguePosition,
        tlt.MatchesPlayed,
        tlt.Wins,
        tlt.Draw,
        tlt.Loss,
        tlt.GoalsScored,
        tlt.xG,
        tlt.GoalsAgainst,
        tlt.xGA,
        (tlt.GoalsScored - tlt.GoalsAgainst) as GoalDifference,
        tlt.Points,
        tlt.XPTS
FROM temp_leaguetable_raw tlt
JOIN season s ON s.season_name = tlt.season_name;

-- Assign Foreign Key 1
ALTER TABLE league_table
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

# --------------------------------------------------------------------------
# Player Season Table
# --------------------------------------------------------------------------
CREATE TABLE player_season (
	SeasonID INT,
    PlayerID INT NOT NULL,
    ShirtNumber INT,
    PlayerName VARCHAR(80) NOT NULL,
    Position VARCHAR(25),
    MatchesPlayed INT NOT NULL,
    MatchesStarted INT NOT NULL,
    MinutesPlayed INT NOT NULL,
    AverageRating DECIMAL(4,2)
);

# Update player names to match players table
UPDATE temp_updatedplayers_raw
SET PlayerName = 'Gabriel Dos Santos'
WHERE PlayerName = 'Gabriel Magalhães'; 

INSERT INTO player_season
with stats_info AS (
SELECT s.season_id as SeasonID, p.ID as PlayerID, tss.Player, tss.Position, tss.MatchesPlayed, tss.Starts, tss.MinutesPlayed
FROM p_standard_stats tss
JOIN players p ON p.FullName = tss.Player
JOIN season s ON s.season_id = tss.SeasonID
),
# 2
ratings_info AS (
SELECT s.season_id AS SeasonID, p.ID as PlayerID, sr.PlayerName, SeasonRating as AvgRating
FROM seasonratings sr
JOIN players p on p.FullName = sr.PlayerName
JOIN season s ON s.season_id = sr.SeasonID
),
# 3
shirt_info AS (
SELECT tp.PlayerName, p.ID as PlayerID, tp.Position, tp.ShirtNumber, s.season_id as SeasonID
FROM temp_updatedplayers_raw tp
LEFT JOIN season s ON s.season_name = tp.season_name
JOIN players p ON p.FullName = tp.PlayerName
)
SELECT si.SeasonID, si.PlayerID, shi.ShirtNumber, si.Player AS PlayerName, shi.Position, si.MatchesPlayed, si.Starts, si.MinutesPlayed, ri.AvgRating
FROM stats_info si
LEFT JOIN ratings_info ri ON ri.SeasonID = si.SeasonID  AND ri.PlayerID = si.PlayerID
JOIN shirt_info shi ON shi.SeasonID = si.SeasonID AND shi.PlayerID = si.PlayerID;


-- Assign Foreign Key 1
ALTER TABLE player_season
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);

-- Assign Foreign Key 2
ALTER TABLE player_season
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

# --------------------------------------------------------------------------
# # Drop Temporary Stats Tables
# --------------------------------------------------------------------------
DROP TABLE IF EXISTS temp_leaguetable_raw,
temp_players,
temp_players_defensive_stats,
temp_players_goalkeeping_stats,
temp_players_miscell_stats,
temp_players_passing_stats,
temp_players_possession_stats,
temp_players_shooting_stats,
temp_players_standard_stats,
temp_seasonratings,
temp_club_defensive_stats,
temp_club_passing_stats,
temp_club_miscell_stats, 
temp_club_goalkeeping_stats,
temp_club_possession_stats,
temp_club_shooting_stats,
temp_club_standard_stats;



# --------------------------------------------------------------------------
# Season
# --------------------------------------------------------------------------
# Create Tables
CREATE TABLE season(
	season_id	INT NOT NULL PRIMARY KEY UNIQUE KEY AUTO_INCREMENT,
    season_name	VARCHAR(20) NOT NULL,
    league	VARCHAR(50) NOT NULL
);

# Insert into Table
INSERT INTO season (season_name, league) VALUES
('2019-2020', 'English Premier League'),
('2020-2021', 'English Premier League'),
('2021-2022', 'English Premier League'),
('2022-2023', 'English Premier League'),
('2023-2024', 'English Premier League');

# --------------------------------------------------------------------------
# Players Table
# --------------------------------------------------------------------------

CREATE TABLE players(
	ID INT NOT NULL PRIMARY KEY UNIQUE KEY AUTO_INCREMENT,
    FullName VARCHAR(80) NOT NULL,
    Nationality VARCHAR(50)
);

# Players Query
INSERT INTO players (FullName, Nationality)
# Nationality
with nationality_temp AS (
SELECT DISTINCT tw.Player, tw.NationCode, tn.Nation 
FROM temp_wages tw
LEFT JOIN temp_nationality tn ON tn.NationID = tw.NationCode
),
# Assign Each Player 
playerID_temp AS (
SELECT DISTINCT PlayerName  
FROM temp_players
-- GROUP BY PlayerName
)
SELECT 
    pt.PlayerName, nt.Nation as Nationality
FROM
    playerID_temp pt
        LEFT JOIN
    nationality_temp nt ON nt.Player = pt.PlayerName;

# Update players_info table

# Insert and fill null nationalities
UPDATE players
SET Nationality = 'Brazil'
WHERE ID = 48;

# View Tables
SELECT * FROM players_info WHERE ID = 30;

# --------------------------------------------------------------------------
# Wages
# --------------------------------------------------------------------------
CREATE TABLE wages(
	PlayerID INT NOT NULL,
    FullName VARCHAR(80) NOT NULL,
    Nationality VARCHAR(80) NOT NULL,
    Wages INT NOT NULL,
    SeasonID INT NOT NULL
);

-- Assign Foreign Key 1
ALTER TABLE wages
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);

-- Assign Foreign Key 2
ALTER TABLE wages
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

# Insert Table
INSERT INTO wages (PlayerID, FullName, Nationality, Wages, SeasonID)
SELECT pi.ID as PlayerID,
	pi.FullName,
    tw.Nationality,
    tw.Wages,
    s.season_id as SeasonID
FROM temp_wages tw
JOIN players pi ON pi.FullName = tw.Player
JOIN season s ON s.season_name = tw.season_name;

# --------------------------------------------------------------------------
# Transfers
# --------------------------------------------------------------------------

CREATE TABLE transfers (
    PlayerID INT,
    FullName VARCHAR(80) NOT NULL,
    PositionID INT NOT NULL,
    TransferType VARCHAR(20),
    TransferStatus ENUM('In', 'Out') NOT NULL,
    Club VARCHAR(80) NOT NULL,
    League VARCHAR(80) NOT NULL,
    TransferAmount bigint NOT NULL,
    SeasonID INT NOT NULL
);

-- Assign Foreign Key 1
ALTER TABLE transfers
ADD CONSTRAINT FOREIGN KEY(PlayerID)
REFERENCES players(ID);

-- Assign Foreign Key 2
ALTER TABLE transfers
ADD CONSTRAINT FOREIGN KEY(PositionID)
REFERENCES positions(position_id);

-- Assign Foreign Key 3
ALTER TABLE transfers
ADD CONSTRAINT FOREIGN KEY(SeasonID)
REFERENCES season(season_id);

# Transfer Table
INSERT INTO transfers (PlayerID, FullName, PositionID, TransferType, TransferStatus, Club, League, TransferAmount, SeasonID)
SELECT pi.ID as PlayerID,
		tt.Player as FullName,
        p.Position_ID as PositionID,
        tt.TransferType as TransferType,
        tt.Status as Transfer_Status,
        tt.Club,
        tt.League,
        tt.Amount,
        s.season_id as SeasonID
FROM temp_transfers as tt
LEFT JOIN players as pi ON pi.FullName = tt.Player #Joins all transfers including players not in database
JOIN season s ON tt.Season_Name = s.season_name
JOIN positions p ON tt.Position = p.position_name;

update transfers
SET FullName = 'Gabriel Dos Santos'
WHERE FullName = 'Gabriel Magalhães';

describe transfers;

# --------------------------------------------------------------------------
# Positions Table
# --------------------------------------------------------------------------

CREATE TABLE positions(
	position_id	INT	NOT NULL PRIMARY KEY UNIQUE KEY,
    position_name	VARCHAR(25)
);

# UPDATE Positions Table
INSERT INTO positions (position_ID, position_name)
SELECT ROW_NUMBER()OVER() as Position_ID, Position
FROM temp_player_list
GROUP BY Position; 

# --------------------------------------------------------------------------
# Nationality Table
# --------------------------------------------------------------------------
CREATE TABLE nationality(
	Nation	VARCHAR(30) NOT NULL,
    NationCode VARCHAR(5) NOT NULL,
    NationId VARCHAR(5) NOT NULL
);

INSERT INTO nationality
SELECT DISTINCT tn.Nation, tw.Nationality as NationCode, tn.NationID
FROM temp_wages tw
JOIN temp_nationality tn ON tn.NationID = tw.NationCode;

DROP TABLE IF EXISTS temp_nationality,
temp_players, 
temp_transfers,
temp_wages;

