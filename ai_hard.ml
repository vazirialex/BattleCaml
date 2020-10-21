open Gameboard
open Random

(* [fire_lst] has a true and false value corresponding to hitting a caml or missing *)
let fire_lst = [true; false]

(* [determine_hard_fire ()] has a 50% chance or returning true and a 50% chance
of returning false. *)
let determine_hard_fire () = 
    let elt = Random.int 2 in
    List.nth fire_lst elt

let empty_coords_calculated = ref false

(* [get_all_empty_coords miss_coords] returns a list of coordinate pairs representing
the coordinates of type Empty. *)
let get_all_empty_coords m reflst = 
  if !empty_coords_calculated = false then
  begin
  for i = 0 to Array.length m - 1 do
    for j = 0 to Array.length m.(i) - 1 do
      match m.(i).(j) with
        | Empty -> reflst := (i, j):: !reflst
        | _ -> ()
    done
  done;
  empty_coords_calculated := true;
  !reflst
  end
  else
    !reflst

(* [remove_empty coord reflst] updates [reflst] to a ref list without [coord] *)
let remove_empty coord reflst = 
  reflst := List.filter (fun c -> if c = coord then false else true) !reflst

(* [get_empty_coord empty_coords] returns a coordinate representing type Empty on
  the board. It also removes that coordinate from [empty_coords] *)
let get_empty_coord empty_coords = 
  let rnd_ind = Random.int (List.length !empty_coords) in
  let (x, y) = List.nth !empty_coords rnd_ind in
  remove_empty (x, y) empty_coords;
  (x, y)

(* [current_ship_index] is a reference to a value between 1 and 4 inclusive*)
let current_ship_index = ref 0

let curr_elt = 0

(* [update_ship_index] updates the index to the next element if the current
   element is empty  *)
let rec update_ship_index lst_of_lst num = 
  let first_non_empty_found = ref false in
  match lst_of_lst with
    | [] -> current_ship_index := num
    | h::t -> if h = [] && !first_non_empty_found = false then
               update_ship_index t (succ num)
               else
               begin
               first_non_empty_found := true;
               update_ship_index t num
               end

(* [ships_at_index ind] returns the ship at index [ind] *)
let rec ship_at_index ships ind =
  List.nth !ships ind

(* [get_coord_of_hit ship] returns the first element of [ship].
    It returns the first element so that the ship fires in order *)
let get_coord_of_hit ship = 
  List.nth ship curr_elt

(* [filter_coord lst coord]  returns a new list without a given coordinate. *)
let filter_coord (lst : (int * int) list) (coord : int * int) = 
  List.filter (fun c -> if c = coord then false else true) lst

(* [replace lst ind elt] replaces the value in [lst] at [ind] with [elt] *)
let rec replace lst ind elt =
  match lst with
  | [] -> lst
  | h::t -> if ind = 0 then
              elt::(replace t (ind - 1) elt)
            else
              h::(replace t (ind - 1) elt)

(* [filter_ships] calls replace in a more readable format *)
let filter_ships ship_lst ship_ind new_ship =
  replace ship_lst ship_ind new_ship

(* [update_ship_lst ships] updates ships to correspond to the proper list
of list of coordinates of [ships]. *)
let update_ship_lst ships =
  let curr_ship = ship_at_index ships !current_ship_index in
  let coord = get_coord_of_hit curr_ship in
  let updated_ship = filter_coord curr_ship coord in
  let updated_ship_lst = filter_ships !ships !current_ship_index updated_ship in
  ships := updated_ship_lst;
  update_ship_index !ships 0

(* [ai_fire m ship_lst] is the main firing mechanism of the hard AI. *)
let ai_fire m ships empty_lst = 
  match determine_hard_fire () with
    | true ->
              let curr_ship = ship_at_index ships !current_ship_index in
              let (x, y) = (get_coord_of_hit curr_ship) in
              update_ship_lst ships;
              m.(y-1).(x-1) <- Hit;
              m
    | false ->
              let (x, y) = get_empty_coord empty_lst in
               m.(x).(y) <- Miss;
               m
