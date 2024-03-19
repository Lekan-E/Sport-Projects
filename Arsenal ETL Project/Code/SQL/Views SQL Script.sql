# Create a view to store required stats for visualizations

# GET ALL REQUIRED STATS
CREATE OR REPLACE VIEW v_allstats AS
with shooting AS (
SELECT SeasonID, PlayerID, Shots, ShotsonTargetPercent AS SoTPercent, ShotDistance as Dist, xG, CONCAT(ShotsonTarget, '-', Shots) as SoT
FROM p_shooting_stats
),
passing AS (
SELECT SeasonID, PlayerID, AttemptedPass, PassCompletionPercent, KeyPass as KP
FROM p_passing_stats
),
standard AS (
SELECT SeasonID, PlayerID, CONCAT(MatchesPlayed,'-', Starts) AS MP_MS, MinutesPlayed AS Min, Goals, Assists,  ProgressivePasses as ProgP, ProgressiveCarries as ProgC, xAG
FROM p_standard_stats
),
possession AS (
SELECT SeasonID, PlayerID, SuccessfulTakeonsPercent, TotalCarryDistance, Touches, Carries, CONCAT(SuccessfulTakeons, '-', AttemptedTakeons) as TakeOn
FROM p_possession_stats
),
defense AS (
SELECT SeasonID, PlayerID, ROUND(((TacklesWon/Tackles) * 100),2) as TacklesWonPercentage, CONCAT(TacklesWon, '-' , Tackles) as Tkls, Blocks, Interceptions, Clearances, Tackles
FROM p_defensive_stats
),
miscell AS(
SELECT SeasonID, PlayerID, BallRecoveries, FoulsDrawn, ROUND(AerialDuelsWon/(AerialDuelsWon + AerialDuelsLost) * 100 ,2) as AerialDuelsWonPercent, FoulsCommitted
FROM p_miscell_stats
),
goalkeeping AS (
SELECT SeasonID, PlayerID, ShotsOnTargetAgaint as SoTFaced, Saves, SavePercentage, CleanSheet, CONCAT(PenaltySaved, '-', PenaltyFaced) as Pens, GoalAgainst as GoalsConceded
FROM p_goalkeeping_stats
)
SELECT ps.SeasonID, ps.PlayerID, ps.PlayerName, ps.AverageRating, 
st.MP_MS, st.Min, st.Goals, st.xAG, st.ProgP, st.ProgC,
sh.xG, st.Assists, sh.Shots, sh.SoTPercent, sh.Dist, sh.SoT,
poss.SuccessfulTakeonsPercent, poss.TotalCarryDistance, poss.Touches, poss.Carries, poss.TakeOn,
pass.AttemptedPass, pass.PassCompletionPercent, pass.KP,  
misc.FoulsDrawn, misc.AerialDuelsWonPercent, misc.FoulsCommitted, misc.BallRecoveries, 
gk.SoTFaced, gk.Saves, gk.SavePercentage, gk.CleanSheet, gk.Pens, gk.GoalsConceded,
def.TacklesWonPercentage, def.Tkls, def.Blocks, def.Interceptions, def.Clearances, def.Tackles,
CASE
WHEN Position IN ('Centre-Back','Left-Back','Right-Back') THEN 'Defender'
WHEN Position IN ('Defensive Midfield','Central Midfield','Attacking Midfield') THEN 'Midfielder'
WHEN Position IN ('Right Winger','Centre-Forward','Left Winger') THEN 'Forward'
WHEN Position LIKE('Goalkeeper') THEN 'Goalkeeper'
else 'NaN'
END AS NewPosition
FROM player_season ps
JOIN shooting sh ON sh.PlayerID = ps.PlayerID AND sh.SeasonID = ps.SeasonID
JOIN passing pass ON pass.PlayerID = ps.PlayerID AND pass.SeasonID = ps.SeasonID
JOIN standard st ON st.PlayerID = ps.PlayerID AND st.SeasonID = ps.SeasonID
JOIN possession poss ON poss.PlayerID = ps.PlayerID AND poss.SeasonID = ps.SeasonID
JOIN miscell misc ON misc.PlayerID = ps.PlayerID AND misc.SeasonID = ps.SeasonID
left JOIN goalkeeping gk ON gk.PlayerID = ps.PlayerID AND gk.SeasonID = ps.SeasonID
JOIN defense def ON def.PlayerID = ps.PlayerID AND def.SeasonID = ps.SeasonID;

SELECT * 
FROM v_allstats where SeasonID = 5 ;

drop view v_allstats;

