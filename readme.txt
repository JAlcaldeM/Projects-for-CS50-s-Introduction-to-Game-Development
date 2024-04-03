Author: Javier Alcalde Marchena
javieralcaldemarchena3a@gmail.com

This project is the submission for Mario, project 4 of HarvardX: CS50's Introduction to Game Development.
The original files were provided by the edX platform (see game files for more information).
Initially the project consisted of a fully functional version of a lateral scroll platformer game, similar to Super Mario Bros.

Functionalities added as per requirements of the course:
- The first tile was set to normal ground so the player does not die after spawning.
- A single key and a locked block of one of the 4 colors at random are generated. This block is solid unless the player has its key (spawns in a random jump block), in which case disappears upon contact (it is unlocked).
- Once the block is unlocked, a flag appears at the end of the level. The flag shares the color with the key and the locked block.
- When the player touches the flag the level ends and the player 'respawns' in a longer level, keeping its score.

Additional functionalities added and other changes (reason between parenthesis):
- The tiles 1 and 3 were set to 'columns', while the tile 2 is normal ground with a switch covered by the locked block. The flag appears when pushing the switch instead of unlocking the block (functionality similar, but more intuitive for the player).
- Movement completely reworked: now the player jumps less, but has inertia and can charge the jump by crouching. Also, player hitbox slightly reduced so that it can jump between blocks and fall in one-tile holes (to improve the player experience and make the game more dynamic).
- A timer was added (to incentivize players to rush the levels instead of playing it safe). This timer is conserved between rounds, with more time added with each level.
- Snails bounce the player when bounced on, keeping momentum. Also, after pushing the switch, a new wave of faster, meaner snails appear (to offer a new challenge , but also to be used for boosting speed in the final rush to the flag).
- All jump blocks are broken in pieces after being hit from behind, and the level maker was modified to not be able to generate them in ways that are impossible to break (since if an unreachable block has the key could lock the player out of completing the level).
- Visual bug fixed where at bigger screen sizes blinking vertical lines would appear in the background or in some textures due to tilemap pixel interpolation.
- Other QOL changes (various sounds added, the UI shows when the player has the key and when the flag has spawned...).

A demonstration of the game can be seen here: https://youtu.be/YskHn1XaWfI

All the new sounds added have been created with Bfxr (https://www.bfxr.net/).
The game icon has been created with GIMP (https://www.gimp.org/).
