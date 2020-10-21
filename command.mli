(**
    This module stores the command types, used for getting input from the 
    player's keyboard as an in-game data type. 
 *)

(** the abstract type used to represent the player's keyboard input. *)
 type command = | Place | Fire | Rotate | Quit 
                | Save | Up | Down | Left | Right 
                | Nuke | Surrender | Other

(** [get_key win] reads keyboard input from the terminal window [win].
    It then converts the input to the [command] type. *)
 val get_key : Curses.window -> command