open Gameboard

(** 
    This module handles all of the display logic for the game. 
    It interfaces with the Curses module to display to the terminal.
*)

(** The underlying terminal screen window reference.
    All other windows are layer atop this one. *)
val scr : Curses.window ref

(** A reference to the width of the terminal window. *)
val max_x : int ref 
(** A reference to the height of the terminal window *)
val max_y : int ref

(** A reference to the player board window *)
val b_win : Curses.window ref
(** A reference to the ai board window *)
val ai_win : Curses.window ref

(** A refrence to the x position of the Curses drawing cursor *)
val cur_x : int ref
(** A refrence to the y position of the Curses drawing cursor *)
val cur_y : int ref

(** A reference to the time the cursor has not been updated. 
    Resets cyclically. *)
val cur_timer : float ref

(** A refrence to the x position on the board of the upper-left corner of the 
    player's crosshair matrix. *)
val crosshair_x : int ref
(** A refrence to the x position on the board of the upper-left corner of the
    player's crosshair matrix. *)
val crosshair_y : int ref 
(** A reference to the player's crosshair matrix *)
val crosshair_mat : int array array ref

(** Moves the Curses cursor to the next posiiton of the board, going from left 
    to right, top to bottom. Wraps around to the next line if the edge of the 
    board is reached *)
val incr_cur : 'a array array -> unit

(** Initializes internal Curses windows for the placement phase *)
val placement_init : unit -> unit
(** Initializes internal Curses windows for the play phase *)
val play_init : unit -> unit
(** Initializes internal Curses windows for the menu phase *)
val menu_init : unit -> unit
(** Initializes internal Curses windows for the win phase *)
val win_init : unit -> unit
(** Initializes internal Curses windows for the lose phase *)
val lose_init : unit -> unit
(** Initializes internal Curses windows for the placement phase *)

(** Deallocates internal Curses windows for the play phase *)
val play_end : unit -> unit
(** Deallocates internal Curses windows for the menu phase *)
val menu_end : unit -> unit
(** Deallocates internal Curses windows for the win phase *)
val win_end : unit -> unit
(** Deallocates internal Curses windows for the lose phase *)
val lose_end : unit -> unit

(** [check_cross ()] is true if the drawing cursor coordinates are equal to a 
    crosshair coordinate, and false otherwise *)
val check_cross : unit -> bool

(** Renders the main board to the terminal, with the crosshair graphic *)
val render_board : Gameboard.entry array array -> Curses.window -> int -> float -> unit

(** Renders the ai board to the terminal, without the crosshair graphic *)
val render_ai_board : Gameboard.entry array array -> Curses.window -> 'a -> 'b -> unit

(** Performs all of the rendering, based on phase and delta time *)
val render : Gameboard.entry array array -> Gameboard.entry array array -> int -> int -> int -> string -> float -> float

(** [exit_display ()] destroys all windows and exits the game. *)
val exit_display : unit -> 'a