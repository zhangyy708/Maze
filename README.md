# Maze

## How to Play?

### Goal
There are currently 2 levels in this game. In each level, the player should plan 3 different routes from the start point (marked as green) to the end point (marked as red). The place that the player has passed will be replaced by a wall (except for the start and end points), so the player cannot step on that place again. Therefore, the player should consider each route wisely.  

### Win & Lose

There is time limit of 180 seconds in each level. If the player cannot succeed in 180 seconds, game over; otherwise, the player will enter the next level. If the player can succeed in all levels, they will win the game.

### Score

Whenever the player passes a floor tile (except for the start and end points), they will get 1 point. 

Additionally, in each level, there are a few hearts. If the player collides with each heart, they will get a score of 10. 

### Instruction

Use Left/Right/Up/Down keys to control the player.  
Press Enter to start the game.  
Press Esc to quit the game.  
Press R to reset the current level.  

## About the Project

This project is built with love2d. Game states include: StartState, PlayState, and GameOverState.  

### StartState

Press Enter to start. 

### PlayState

BGM changes. The player can get to play the game. Left time, score, and the current level are displayed on the screen.  
If the player presses R, the score will be reset, the generated walls will disappear, and the player will be placed at the start point.  

### GameOverState

BGM changes. If the player wins in all levels, text of 'You Win!!!' will be displayed here; otherwise, text of 'Game Over' will appear. The player can press Enter to re-start the game. 

### Maze

Maze.lua generates maps for each level (generateMap() and generateObjects()).  

If the player collides with a heart, a sound will be played, the heart will disappear (and cannot be collided again), and the score will be added 10. 

Wheneve the player passes a floor tile (except for the start and end points), a wall will be generated at that place, the score will be added 1, and the player cannot step on that place again.  

If the player collides with the end point, they will be placed at the start point, their animations will be changed, and the generated walls will not disappear.  

If the player collides with the end point for the third time in each level, they will win in the level and will enter the next level. If all levels are passed, the player will win the game.  

### constants, game_objects, and entity_defs

Constants, map designs, and statistics of game objects and the player are separated from the programming part. 

## Credits

The map assets of the maze are from https://timberwolfgames.itch.io/amazing-maze-sprites and the previous project of zelda.  
The assets of characters are from https://parabellum-games.itch.io/retro-rpg-character-pack  
The BGM is from https://maou.audio/game_event27/ and https://maou.audio/game_dangeon10/  
Sound effects are generated from Bfxr  
The font is from https://www.fontspace.com/black-north-font-f87052  
The background image is from https://saurabhkgp.itch.io/pixel-art-forest-background-simple-seamless-parallax-ready-for-2d-platformer-s  

All assets used in this project are free for personal use.  