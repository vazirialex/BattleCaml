(** [coord] is a coordinate in a matrix. *)
type coord = (int * int)

(** [powerup] is a powerup. *)
type powerup = Sea_mine | Bomb | Double_bullet | Points | Repair_kit

(** [entry] is an entry on the board *)
type entry = Hit | Miss | Unhit | Empty | Collected | Uncollected of powerup

(** [t] is a matrix of entries representing a game board. *)
type t = entry array array

type ship = t
type response = Contact of t | No_contact of t | 
                Already_hit of t | Already_miss of t | Misc

type mode = Easy | Medium | Hard

type orientation = Vertical | Horizontal

exception Malformed 
exception Out_of_bounds

(** [init_matrix ()] is a 10 x 10 matrix initialized to [Empty] entries. *)
let init_matrix () = Array.make_matrix 10 10 Empty

let rec index lst elem acc = 
  match lst with
  | [] -> acc
  | h::t -> if h = elem then acc else index t elem (succ acc)

(* [get_array_from i j arr] returns a new array from i to j (exclusive).
    Essentially, its python code equivalent would be arr[i:j]. *)
let get_array_from i j arr = 
  let lst = Array.to_list arr in 
  let rec array_match i j lst acc num = 
    (match lst with
     | [] -> acc
     | h::t -> if num >= i && num < j 
       then array_match i j t (acc@[h]) (succ num) 
       else array_match i j t acc (succ num)) in
  Array.of_list (array_match i j lst [] 0)

(** [thd tup] returns the third element of [tup], which is represented by 
    (x, y, len, orientation), thus returning the value of len *)
let thd tup = 
  match tup with
  | (_, _, t, _) -> t

(** [create_vertical_lst tup acc num] transforms [tup] into a list of
    coordinate pairs that describe the position of each of the user's placed
    vertical ships.*)
let rec create_vertical_lst tup acc num = 
  match num with
  | num when num < (thd tup) -> 
    let (x, y, _, _) = tup in (create_vertical_lst tup ((x, y+num)::acc) (succ num))
  | _ -> (List.rev acc)

(** [create_horizontal_lst tup acc num] transforms [tup] into a list of
    coordinate pairs that describe the position of each of the user's placed
    horizontal ships. *)
let rec create_horizontal_lst tup acc num = 
  match num with
  | num when num < (thd tup) -> 
    let (x, y, _, _) = tup in create_horizontal_lst tup ((x+num, y)::acc) (succ num)
  | _ -> (List.rev acc)

(** [ship_coordinates arr_to_lst acc] returns a reference of [arr_to_lst] whose
    elements are references to coordinate positions of the user's placed ships.
*)
let rec ship_coordinates arr_to_lst acc = 
  match arr_to_lst with
  | [] -> List.rev acc
  | h::t -> let (_, _, _, orientation) = h in
    if orientation = Vertical then
      (ship_coordinates t ((create_vertical_lst h [] 0)::acc))
    else
      (ship_coordinates t ((create_horizontal_lst h [] 0)::acc))

(** [create_ship len] is an array of [Unhit] elements with length [len]. *)
let create_ship len = Array.make len Unhit

(** [ships] is an array of ships with default length 0 and default orientation
    [Horizontal]. *)
let ships = Array.make 5 (Array.make 0 Unhit, Horizontal)

(** [caml_5] sets index 0 of array [ships] to a ship of length 5 oriented
    horizontally. *)
let caml_5 = ships.(0) <- (create_ship 5, Horizontal)

(** [caml_4] sets index 1 of array [ships] to a ship of length 4 oriented
    horizontally. *)
let caml_4 = ships.(1) <- (create_ship 4, Horizontal)

(** [caml_3] sets index 2 of array [ships] to a ship of length 3 oriented
    horizontally. *)
let caml_3 = ships.(2) <- (create_ship 3, Horizontal)

(** [caml_3'] sets index 3 of array [ships] to a ship of length 3 oriented
    horizontally. *)
let caml_3' = ships.(3) <- (create_ship 3, Horizontal)

(** [caml_2] sets index 4 of array [ships] to a ship of length 2 oriented
    horizontally. *)
let caml_2 = ships.(4) <- (create_ship 2, Horizontal)

(** [opp_ships] is an array of ships with default length 0 and default
    orientation [Horizontal]. *)
let opp_ships = Array.make 5 (Array.make 0 Unhit, Horizontal)

(** [opp_5] sets index 0 of array [opp_ships] to a ship of length 5 oriented
    horizontally. *)
let opp_5 = opp_ships.(0) <- (create_ship 5, Horizontal)

(** [opp_4] sets index 1 of array [opp_ships] to a ship of length 4 oriented
    horizontally. *)
let opp_4 = opp_ships.(1) <- (create_ship 4, Horizontal)

(** [opp_3] sets index 2 of array [opp_ships] to a ship of length 3 oriented
    horizontally. *)
let opp_3 = opp_ships.(2) <- (create_ship 3, Horizontal)

(** [opp_3'] sets index 3 of array [opp_ships] to a ship of length 3 oriented
    horizontally. *)
let opp_3' = opp_ships.(3) <- (create_ship 3, Horizontal)

(** [opp_2] sets index 4 of array [opp_ships] to a ship of length 2 oriented
    horizontally. *)
let opp_2 = opp_ships.(4) <- (create_ship 2, Horizontal)

(** [hard_mode_powerups] is a list of powerups used in hard mode. *)
let hard_mode_powerups = Sea_mine :: Bomb :: Double_bullet
                         :: Points :: Repair_kit :: []

(** [easy_mode_powerups] is a list of powerups used in easy mode. *)
let easy_mode_powerups = hard_mode_powerups @ hard_mode_powerups

(* [string_of_entry e] is the character representation of entry [e]. *)
let string_of_entry e = 
  match e with 
  | Hit -> "H"
  | Collected -> "C"
  | Miss -> "M" 
  | Unhit -> "." 
  | Empty -> "." 
  | Uncollected p -> "."

let new_mod n m = (n + m) mod m

let get_row m num = m.(num)

let demo_board = 
  init_matrix ()

let nuke_board = 
  Array.make_matrix 10 10 Hit

let transpose m = 
  Array.init (Array.length m.(0)) (fun i -> 
      Array.init (Array.length m) (fun j -> m.(j).(i)))

(** [get_val_of_coord m c] is the value at coordinates x, y contained in [c], 
    of matrix [m] *)
let get_val_of_coord (m:t) (c:coord) = m.(fst c).(snd c)

(** [check_explosion x y m] sets coordinate [x], [y] in matrix [m] to [Hit] if
    it is [Unhit] and [Miss] otherwise. *)
let check_explosion x y m =
  if m.(x).(y) = Unhit then m.(x).(y) <- Hit
  else m.(x).(y) <- Miss

(** [handle_top_left c m] handles explosion at the top left coordinate of
    matrix [m]. *)
let handle_top_left c m = 
  check_explosion (fst c) (snd c + 1) m;
  check_explosion (fst c + 1) (snd c) m;
  check_explosion (fst c + 1) (snd c + 1) m

(** [handle_bottom_left c m] handles explosion at the bottom left coordinate of
    matrix [m]. *)
let handle_bottom_left c m =
  check_explosion (fst c) (snd c - 1) m;
  check_explosion (fst c + 1) (snd c - 1) m;
  check_explosion (fst c + 1) (snd c) m

(** [handle_top_right c m] handles explosion at the top right coordinate of
    matrix [m]. *)
let handle_top_right c m =
  check_explosion (fst c - 1) (snd c) m;
  check_explosion (fst c - 1) (snd c + 1) m;
  check_explosion (fst c) (snd c + 1) m

(** [handle_bottom_right c m] handles explosion at the bottom right coordinate
    of matrix [m]. *)
let handle_bottom_right c m =
  check_explosion (fst c - 1) (snd c - 1) m;
  check_explosion (fst c - 1) (snd c) m;
  check_explosion (fst c) (snd c - 1) m

(** [handle_left c m] handles explosion on the left side of matrix [m]. *)
let handle_left c m =
  check_explosion (fst c) (snd c - 1) m;
  check_explosion (fst c) (snd c + 1) m;
  check_explosion (fst c + 1) (snd c - 1) m;
  check_explosion (fst c + 1) (snd c) m;
  check_explosion (fst c + 1) (snd c + 1) m

(** [handle_top c m] handles explosion on the top side of matrix [m]. *)
let handle_top c m =
  check_explosion (fst c - 1) (snd c) m;
  check_explosion (fst c + 1) (snd c) m;
  check_explosion (fst c - 1) (snd c + 1) m;
  check_explosion (fst c) (snd c + 1) m;
  check_explosion (fst c + 1) (snd c + 1) m

(** [handle_right c m] handles explosion on the right side of matrix [m]. *)
let handle_right c m =
  check_explosion (fst c - 1) (snd c - 1) m;
  check_explosion (fst c - 1) (snd c) m;
  check_explosion (fst c - 1) (snd c + 1) m;
  check_explosion (fst c) (snd c - 1) m;
  check_explosion (fst c) (snd c + 1) m

(** [handle_bottom c m] handles explosion on the bottom side of matrix [m]. *)
let handle_bottom c m =
  check_explosion (fst c - 1) (snd c - 1) m;
  check_explosion (fst c - 1) (snd c) m;
  check_explosion (fst c) (snd c - 1) m;
  check_explosion (fst c + 1) (snd c - 1) m;
  check_explosion (fst c + 1) (snd c) m

(** [handle_explosion c m] handles explosion at coord [c] in matrix [m]. *)
let handle_explosion c m = 
  check_explosion (fst c - 1) (snd c - 1) m;
  check_explosion (fst c - 1) (snd c) m;
  check_explosion (fst c - 1) (snd c + 1) m;
  check_explosion (fst c) (snd c - 1) m;
  check_explosion (fst c) (snd c + 1) m;
  check_explosion (fst c + 1) (snd c - 1) m;
  check_explosion (fst c + 1) (snd c) m;
  check_explosion (fst c + 1) (snd c + 1) m

(** [handle_powerup c m p] handles powerup [p] at coord [c] in matrix [m]. *)
let handle_powerup c m p = 
  if p = Sea_mine 
  then if fst c = 0 && snd c = 0 then begin
      handle_top_left c m
    end
    else if fst c = 0 && snd c = 9 then begin
      handle_bottom_left c m
    end
    else if fst c = 9 && snd c = 0 then begin
      handle_top_right c m
    end
    else if fst c = 9 && snd c = 9 then begin
      handle_bottom_right c m
    end
    else if fst c = 0 then begin
      handle_left c m
    end
    else if snd c = 0 then begin
      handle_top c m
    end
    else if fst c = 9 then begin
      handle_right c m
    end
    else if snd c = 9 then begin
      handle_bottom c m
    end
    else begin
      handle_explosion c m
    end

(** [fire c m] changes the board [m] based on the entry value at coord [c].
    Returns a response containing the new board. *)
let fire (c:coord) m = 
  match get_val_of_coord m c with
  | Empty -> m.(fst c).(snd c) <- Miss; No_contact m
  | Hit ->  Already_hit m
  | Collected -> Already_hit m
  | Miss -> Already_miss m
  | Unhit -> m.(fst c).(snd c) <- Hit; Contact m
  | Uncollected p -> m.(fst c).(snd c) <- Collected;
    handle_powerup c m p; Contact m

let string_of_response r = 
  match r with 
  | Contact m -> "contact"
  | No_contact m -> "no contact"
  | Already_hit m -> "already hit"
  | Already_miss m -> "already miss"
  | Misc -> "misc"

let second_elt lst = List.nth lst 1
let third_elt lst = List.nth lst 2

let string_of_tuple tup = 
  let x = fst tup in 
  let y = snd tup in
  "(" ^ string_of_int x ^ ", " ^ string_of_int y ^ ")"

(** [format_row row] prints the elements of array [row] to the console *)
let format_row (row: entry array) = 
  Array.iter (fun elem -> print_string (string_of_entry elem)) row;
  print_string "\n"

let format (board:t) = 
  print_string "\n";
  Array.iter format_row board