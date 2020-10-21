(** 
    The logic for easy version AI.

    This module handles the AI firing. This AI fires at random spots on the 
    board.
 *)

(** [ai_fire m] randomly seleted a coordinate in list_generated and fires at it.
  Because this is the easy mode, there is a small chance that the AI fires
  somewhere that it has already hit, thus losing its turn to fire. *)
val ai_fire : Gameboard.entry array array -> Gameboard.entry array array

(** [filter coord coordlst] updates [coordlst] to remove [coord]. It then returns
that list. *)
val filter : 'a -> 'a list ref -> 'a list

(**[shuffle lst]  returns a list whose elements from [lst] are randomly
shuffled. *)
val shuffle : 'a list -> 'a list

(** [cartesian_product x_lst y_lst] calculates the cartesian product of 
    [x_lst]x[y_lst]. The end result is a list of tuples of all different 
    coordinate pair combinations *)
val cartesian_product : 'a list -> 'b list -> ('a * 'b) list