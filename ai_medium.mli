(** 
    The logic for medium version AI.

    This module handles the AI firing. This AI has a 25% chance of hitting the 
    player's ship. Otherwise it selects a random non-hit point and fires. 
 *)

(** [ai_fire m] is a board with one entry changed, corresponding to 
    the firing mechanism of Gameboard. *)
val ai_fire : Gameboard.entry array array -> Gameboard.entry array array