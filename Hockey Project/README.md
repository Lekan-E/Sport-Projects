# Hockey Project
### Aim: Create a post-match report/dashboard for a hockey coaching team highlighting key actions in the game such as pass map, goal shot map, shooting efficiency and key performers in the games.

Tools used:
- Python for analysis
- Tableau for visualization and dashboard creation

Data Info:
- There are two data files & a rink template for scatter plots. One data file has a condensed event set from a randomly chosen hockey game and the other contains Expected Goals values (xG) to be merged onto shot attempts for this game. **If an xG value does not correspond to a shot event, it should not be counted**

- X and Y Coordinates are in feet and are adjusted such that both teams attack from left (dz) to right (oz)
    - X values range from -100 (end boards behind the DZ net) to 0 (centre ice) and 100 (end boards behind the OZ net)
    - Y values range from -42.5 (west side boards) to 0 (centre ice) and 42.5 (east side boards)
    - **When creating scatter plots, please use these coordinates along with the provided rink_template to display the full rink**

- Binary columns that have values of 0 or 1 indicate 0=No, 1=Yes

- Successfull passes are completed passes, successful shots are shots on net

- Compiledgametime is in seconds, and periods are 20 minutes long, except for overtime which is 5 minutes or less

### Match Report Dashboard
Link to interactive dashboard:
https://github.com/Lekan-E/SportProjects/blob/30538c36fe535a8aca65ad4e612d991f59290f22/Hockey%20Project/Tableau%20Images/Match%20Dashboard.jpg