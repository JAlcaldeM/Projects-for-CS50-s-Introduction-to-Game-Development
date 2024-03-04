Author: Javier Alcalde Marchena
javieralcaldemarchena3a@gmail.com

This project is the submission for Pong, project 0 of HarvardX: CS50's Introduction to Game Development.
The original files were provided by the edX platform (see game files for more information).
Initially the project consisted of a fully functional version of a game similar to pong for 2 players.

Functionalities added as per requirements of the course:
- Implemented an AI-controlled paddle such that it will try to deflect the ball at all times.

Additional functionalities added and other changes:
- Gameplay elements changed:
	- The movement of the paddle can affect the ball direction (to increase player agency, now players can aim the ball).
	- Ball movement reworked to keep a pseudo-constant total velocity (more Y axis speed means less X axis speed to balance different trajectories).
	- Size of ball and paddles increased to adapt to these gameplay changes (gameplay evolves from just 'trying to hit the ball' to 'trick the enemy player').
- Separated play into 4 modes, and added a basic menu to allow selection (to add variety):
	- PVE (vs AI).
	- PVP (vs player).
	- Practice (infinite mode).
	- Classic (the original gameplay without the gameplay changes).
- Allow selection of 4 different PVE difficulties, from 'Easy' to 'Very Hard' (adapt to the player and create progression).
- Enter 'dev mode' with key 'z' to show AI parameters (used during development, kept as an 'easter egg' for you, the reader).
- Toggle fullscreen with 'f'.

A demonstration of the game can be seen here: https://youtu.be/DCSZvIhqW1k

All the new sounds added have been created with Bfxr (https://www.bfxr.net/).
The game icon has been created with GIMP (https://www.gimp.org/).
