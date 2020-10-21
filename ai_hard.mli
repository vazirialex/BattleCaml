open Gameboard

(** 
    The logic for hard version AI. 
    
    This module handles the AI firing. This AI has a 50% chance of hitting your
    player's ship. It runs on a different algorithm from the easy and medium
    AI versions. This algorithm takes the coordinates of the ships once they 
    are placed and fires at ship in order, essentially "cheating". 
    That is, it does not shoot at a different ship until the ship is 
    completely sunk. *) 

(** [ai_fire m ships empty_lst] is a board with one entry changed, corresponding to
the firing mechanism of Gameboard. *)
val ai_fire : Gameboard.entry array array -> (int * int) list list ref -> 
  (int * int) list ref -> Gameboard.entry array array

(** [get_all_empty_coords miss_coords] returns a list of coordinate pairs representing
the coordinates of type Empty. *)
val get_all_empty_coords : Gameboard.entry array array -> (int * int) list ref -> (int * int) list

(** [update_ship_lst ships] updates ships to correspond to the proper list
of list of coordinates of [ships]. *)
val update_ship_lst : (int * int) list list ref -> unit

(** [replace lst ind elt] replaces the value in [lst] at [ind] with [elt] *)
val replace : 'a list -> int -> 'a -> 'a list