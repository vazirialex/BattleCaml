(**
    This modules is the main entry point into the game. 

    It handles the running of the game loop, and receinves input from the 
    player and passes it to the corresponding listeners in the game.
    It also interfaces with the display module to draw the game every frame, 
    and reset the framerate timer every call to draw.
 *)

val handle_rotate : ('a * Gameboard.orientation) array -> int -> unit

val main : unit -> 'a