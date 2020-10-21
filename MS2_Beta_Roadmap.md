# MS2: Beta Roadmap

This portion of our project is due Tuesday, Nov. 19th since that is when our demo is. 

The main goal of this sprint will be:   
__Satisfactory scope__: addding a visual component to our game, and replacing verbal input with keyboard input. __Due: Saturday Nov.16__.
__Good scope__: adding a mode where the user should be able to actually place their ships onto the board. __Due: Tuesday Nov.19__.   
__Excellent scope__: the placement mode should allow the user to rotate the ship before placing, and there should be a win condition that allows the player to actually win. __Due: Thursday Nov.21__.

Here is a more detailed breakdown of what needs to happen for each scope.

__Satisfactory scope__:  
The graphical component of the game will rely entirely on the "curses" library, which is an OCaml port of the ncurses library written for C. For the purposes of good design and division of labor, we will keep all of the code relating to curses in its own file. You can think of this file as defining a "displayer" module. None of the other files in our game should have any curses code in them, but obviously they will interact with the displayer extensively.  
This is what the "displayer" should do:
1. Given a "Board" type, the displayer should output a graphical representation of the board to the terminal.
2. The representation above should always show a "cursor" (which will just be a inverse of colors for one entry) at the x,y given to it. This means that "cursor" location will not be stored in the displayer, but rather in the game loop. 
3. Before displaying, the displayer should compile several pieces of data, which include a) the board type itself, as definted by gameboard.t, b) the position of the cursor in x,y coordinates. Only after taking in both of these pieces of data should the displayer actually draw anything to the screen. 
4. There should be methods to move the "cursor" in four directions. Again, the displayer only deals with the graphical representation, so it won't be processing key board inputs. Rather, there should just be one method which takes in a direction type, and outputs a new display with the cursor moved. Key board inputs will be processed in another file.
5. There should be a method which changes the color of the "cursor" from the default, to red (or something else) to indicate to the player that a certain move is prohibited, and a corresponding method which changes it back. This can simply be a method that changes a boolean value in the displayer module.  

In order to process keyboard inputs, we should make another file which we can call the "inputter". This will be a simple file, with a single method which waits for user keyboard input, registers it as some internal type,and sends the appropriate type to the game loop for processing. This means that in the main game loop, where we previously had a line which waited for user verbal input, we will instead call the "inputter's" method. Depending of whether the move was legal or not, the game loop will either call the displayer's move function, or will call the displayer's change cursor color function. For example, if the user moves the cursor over a spot on the board which has already been fired at, the cursor should highlight red. If the player moves it off of that spot, the cursor should go back to default. This file should process all four arrow keys, the enter key, and the "q" key. 

__Good scope__:
The game loop should now keep track of which "mode" we are playing in, either the default play mode, or a "placement" mode in which the user can place ships onto the board. Implementing this will require changes in all of our game files.  
Changes to displayer file include:
1. It should now have two distinct display functions, one for each mode. The new display function should be identical to the original one, except that it will display the location of placed ships instead of hits/misses. The cursor will also be different--instead of a single entry being highlighted to represent the position of the cursor, we will now highlight a number of entries corresponding to the size of the ship we are placing at the moment. For example, when placing a 3-point ship, three side-by-side entries should be highlighted corresponding to where the ship is being placed. 
2. To-be-continued.





