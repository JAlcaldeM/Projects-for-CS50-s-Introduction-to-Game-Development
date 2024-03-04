Author: Javier Alcalde Marchena
javieralcaldemarchena3a@gmail.com

This project is the submission for Match-3, project 3 of HarvardX: CS50's Introduction to Game Development.
The original files were provided by the edX platform (see game files for more information).
Initially the project consisted of a fully functional version of a Match-3 game.

Functionalities added as per requirements of the course:
- Implemented a time addition on a match, corresponding to 1 second per tile.
- Changing the pattern on blocks with level: no pattern on level 1, 1 pattern on level 2... with each pattern giving extra points.
- Added a chance to spawn shiny (slightly more white) versions of blocks that clear the entire row when matched, scoring the corresponding extra points.
- Only allowing tile swaps that cause at least 1 match (if not, the swap is reverted). The board resets automatically if there are no possible matches.
- (Optional) allow swaping by using mouse instead of keyboard.

Additional functionalities added and other changes (reason between parenthesis):
- Reduced the number of colors to 8 (to reduce the chances of automatic board resets, and give the game more chromatic clarity).
- Shiny blocks trigger clear columns instead of rows in horizontal matches (to not punish horizontal matches with worse clears), and can activate other shiny blocks (to allow combinations of multiple clears).
- Starting time reduced from 60 to 30 seconds. Extra time gained due to matches cannot exceed the starting time (to prevent having so much time stacked that it loses meaning).
- Number of points needed to advance levels increased to match other gameplay changes (particularly, multiple clears).
- Design of shiny blocks changed to a white frame and a periodic 'shining' animation (the original design made the shiny version of some colors too similar to the normal version of other colors).
- Additional mouse functionality added (to keep players in mouse mode, since it feels better to play this way):
	- The mouse can also be used to navigate menus.
	- Custom hand sprite for the mouse.
	- The mouse is hidden when playing with keyboard.
- Added 'cheat mode' by pressing the key 'z' or pushing the mouse wheel (used during development, kept as an 'easter egg' for you, the reader).
- Minor changes (adjusting falling animation timing for better gamefeel, toggle fullscreen with 'f') and bug fixes (some colors turning white due to changes in LÖVE 2D version).

A demonstration of the game can be seen here: https://youtu.be/b87E8zPjvXM

All the new sounds added have been created with Bfxr (https://www.bfxr.net/).
The game icon has been created with GIMP (https://www.gimp.org/).
