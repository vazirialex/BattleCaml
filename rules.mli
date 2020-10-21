(** 
    This module contains all of the rules that help the player first understand 
    how the game is played. 

    The various rules are all stored as strings.
 *)

(** The subset of the rules relevant in the placement phase *)
val placement_rules : string

(** The subset of the rules relevant in the play phase *)
val play_rules : string