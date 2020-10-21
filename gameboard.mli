(** 
    This module contains all of the logic of the gameboard data structure. 

    The gameboard is used to store both the opponent's and player's placement,
    shooting and movement information. 
 *)

exception Malformed 
exception Out_of_bounds

(** Stores the board coordinate information for firing and placing ships *)
type coord = int * int

(** The various powerup types that can be used by the player *)
type powerup = Sea_mine | Bomb | Double_bullet | Points | Repair_kit

(** The entry options that a single spot on the board may be *)
type entry = Hit | Miss | Unhit | Empty | Collected | Uncollected of powerup

(** The ai mode options *)
type mode = Easy | Medium | Hard

(** The type representing the gameboard *)
type t = entry array array

(** The ships are all sub boards, layered atop the main gameboard *)
type ship = t

(** The type respresenting the response to firing on a particular spo ton the 
    board. *)
type response = Contact of t | No_contact of t | 
                Already_hit of t | Already_miss of t | Misc

(** Represents whether a ships is oriented vertically or horizontally *) 
type orientation = Vertical | Horizontal

(** [init_matrix ()] is a 2-dimensional 10x10 array of [Empty] values. *)
val init_matrix : unit -> entry array array

(** [index lst elem acc] is the 0-based index of [elem] in the list [lst].
    Requires: [elem] is in the list [lst]. 
    Returns [acc] if [lst] is the empty list. *)
val index : 'a list -> 'a -> int -> int

(** [thd tup] returns the third element of [tup], which is represented by 
(x, y, len, orientation), thus returning the value of len *)
val thd : 'a * 'b * 'c * 'd -> 'c

(** [create_vertical_lst tup acc num] transforms [tup] into a list of coordinate 
    pairs that describe the position of each of the user's placed vertical 
    ships.*)
val create_vertical_lst : 'a * int * int * 'b -> ('a * int) list -> int -> 
                          ('a * int) list

(** [create_horizontal_lst tup acc num] transforms [tup] into a list of 
   coordinate pairs that describe the position of each of the user's placed 
   horizontal ships. *)
val create_horizontal_lst : int * 'a * int * 'b -> (int * 'a) list -> int -> 
                            (int * 'a) list

(** [get_array_from i j] is a subset of [arr], indexed from [i] to 
   [j]-non-inclusive. *)
val get_array_from : int -> int -> 'a array -> 'a array

(** [create_ship len] is an array of [Unhit] values of length [len]. *)
val create_ship : int -> entry array

(** The standard game ship suite *)
val ships : (entry array * orientation) array

(** [ship_coordinates arr_to_lst acc] returns a reference of [arr_to_lst] whose
     elements are references to coordinate positions of the user's placed 
     ships *)
val ship_coordinates : (int * int * int * orientation) list -> 
                       (int * int) list list -> (int * int) list list

(* The standard game opponent ship suite *)
val opp_ships : (entry array * orientation) array

(** [string_of_entry e] is the one-character string representation of 
    Entry [e]. *)
val string_of_entry : entry -> string

(** [string_of_response r] is the string description of response [r] *)
val string_of_response : response -> string

(** [new_mod n m] is n % m, handling negative numbers. 
    Requires: m is not 0. *)
val new_mod : int -> int -> int

(** Represents the fully hit board -- used to instantly win/lose *)
val nuke_board : entry array array
(** Represents the fully empty board -- used to initialize *)
val demo_board : entry array array

(** The powerups used in the hard mode of the game *)
val hard_mode_powerups : powerup list
(** The powerups used in the hard mode of the game *)
val easy_mode_powerups : powerup list

(** [get_row n num] is the row at index [num] in matrix [m] *)
val get_row : 'a array -> int -> 'a

(** [transpose m] is the transpose of matrix [m] *)
val transpose : 'a array array -> 'a array array

(** [get_val_of_coord m c] is the value at coordinates x, y contained in [c], 
    of matrix [m] *)
val get_val_of_coord : t -> coord -> entry

(** [fire c m] modifies the board [m] based on the entry value at 
    coordinates [c]. Returns a response type containing the new board. *)
val fire : coord -> t -> response

(** [string_of_tuple tup] is a string representation of tuple [tup]. *)
val string_of_tuple : int * int -> string

(** [format board] prints the elements of Board [board] to the console *)
val format : t -> unit

