Author: Javier Alcalde Marchena
javieralcaldemarchena3a@gmail.com

This project is the submission for Flappy Bird, project 1 of HarvardX: CS50's Introduction to Game Development.
The original files were provided by the edX platform (see game files for more information).
Initially the project consisted of a fully functional version of a game similar to Flappy Birds.

Functionalities added as per requirements of the course:
- Randomization added to the gap between pipes.
- Randomization added to the interval at which pairs of pipes spawn.
- A medal is rewarded to the player when the game ends, depending of the score (10 for bronze, 20 for silver, 30 for gold).
- Implemented a pause feature.

Additional functionalities added and other changes (reason between parenthesis):
- Sprite of the bird changed to better match the hitbox shape (the sprite was somewhat round, but the hitbox is square).
	- The game has been renamed to Fifty Bricks.
- Increased player speed and pipe spawn (to add dynamism).
- Added 4 special flight modes, based on https://game.engineering.nyu.edu/projects/exploring-game-space/ (to add variety):
	- After a certain time, a powerup spawns. When it collides the bird, the corresponding special mode activates.
	- Each special mode changes the game parameters to offer a different challenge. The bird and pipe sprites also change.
	- After the same time, another powerup spawns that transforms the bird back into the standard bird.
	- When changing modes, the bird gains a shield that prevents the player to lose until it is used to the new bird parameters.
- Added 'cheat mode' by pressing the key 'z' (used during development, kept as an 'easter egg' for you, the reader).
- Minor changes to sequence of elements updates (to improve game feel, since sometimes the bird seemed to not touch the pipe in score screen).
- Minor changes (toggle fullscreen with 'f') and bug fixes (game over if the bird touches the upper ground or the ceiling, pipe height do not get stuck at maximum or minimum value).

A demonstration of the game can be seen here: https://youtu.be/WHtxZYj3Xmg

All the new sounds added have been created with Bfxr (https://www.bfxr.net/).
The game icon and any additional sprites have been created/edited with GIMP (https://www.gimp.org/).

