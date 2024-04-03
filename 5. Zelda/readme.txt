Author: Javier Alcalde Marchena
javieralcaldemarchena3a@gmail.com

This project is the submission for Zelda, project 5 of HarvardX: CS50's Introduction to Game Development.
The original files were provided by the edX platform (see game files for more information).
Initially the project consisted of an dungeon (much like the ones from the classic Legend of Zelda games) in which the players could fight monsters and move to other randomly generated rooms after pushing a switch.

Functionalities added as per requirements of the course:
- Sometimes (25%) an enemy drops a heart when defeated. This heart restores 1 HP to the player when consumed.
- Pots spawn at random. The player can pick the pots, and the animation changes accordingly. The player cannot attack while carrying a pot.
  - It was decided that the pots must be solid (no entity can pass through them) and the player cannot pass to the next room while holding a pot due to its size.
- The player can throw the pot, sending it flying in a straight line torwards where it is looking. It is destroyed after hitting a wall or an enemy (dealing it 1 point of damage) or travelling more than 4 tiles.


Additional functionalities added and other changes (reason between parenthesis):
- Now entities (enemies, player) and objects (pots, switch) cannot spawn colliding any other entity or object (enemies or the player couldnt move when spawn 'inside' a pot).
- Instead of dropping instantly, the pot describes a parable torwards the ground (to make it more 'realistic'). The pot can still hit enemies when falling.
- When destroyed, the pot is broken in pieces that are sent into directions (random, but influenced by the tipe of collision), 'emulating' some bounces with the ground and eventually stopping.
  - The pieces can also bounce with the walls so that they are kept inside the room.
- Minor bug fixing (sound triggers, visual aberrations, etc).


To do:
- sounds for pots crashing, both the initial crash and the pieces hitting the ground (and rupee gaining)


A demonstration of the game can be seen here: https://youtu.be/yM2XByj4mUI

All the new sounds added have been created with Bfxr (https://www.bfxr.net/).
The game icon and all new sprites have been created with GIMP (https://www.gimp.org/).
