Author: Javier Alcalde Marchena
javieralcaldemarchena3a@gmail.com

This project is the submission for Breakout, project 2 of HarvardX: CS50's Introduction to Game Development.
The original files were provided by the edX platform (see game files for more information).
Initially the project consisted of a fully functional version of a game similar to Breakout.

Functionalities added as per requirements of the course:
- Added a powerup that spawns two extra balls (spawns after serve and then periodically).
- Grow and shrink the paddle when gaining enough points or losing a life, respectively.
- Added a locked brick that must be unlocked by catching a randomly spawning key powerup.

Additional functionalities added and other changes (reason between parenthesis):
- For the ball-spawning powerup, only the original ball counts for keeping the player alive (so if the player misses this ball loses a life even if other balls are still present).
- When the original ball hits 3+ blocks in rapid succession, a 'streak' is activated:
	- The ball changes color and the screen shows the streak value in increasing size.
	- The paddle grows as a reward for completing a streak instead of when gaining points (incentivizing good aim with the original ball).
	- If already at maximum paddle size, gain extra points instead.
- Players recover health when progressing levels instead of gaining points (to make it more predictable).
- Instead of randomly, the key powerup is inside of a brick that spawns periodically if any block is locked and releases the powerup when destroyed (to make the player feel that it can progress torward this goal if aims well).
	- This block does not reward points (to stop players from exploitig it).
- Recover all health and increase paddle size to the maximum by pressing the key 'z' (used during development, kept as an 'easter egg' for you, the reader).
- Other minor changes (toggle fullscreen with 'f', the musics stops when paused, when the player has reached a new total highscore the corresponding indicator appears...).

A demonstration of the game can be seen here: https://youtu.be/cDJcDu3LNvM

All the new sounds added have been created with Bfxr (https://www.bfxr.net/).
The game icon and any additional sprites have been created/edited with GIMP (https://www.gimp.org/).
