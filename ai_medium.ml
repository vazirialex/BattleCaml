(* Implementation of the AI that you play against. *)
open Gameboard
open Random

(* [fire_lst] represents how the firing mechanics for the AI will work.
    A randomizer chooses a number between 0 and 3 inclusive, corresponding to
    an element in [fire_lst]. If false, then AI fires randomly, if true, then
    the AI find a coordinate with an unhit ship and fires there.
    This gives the AI a 25% chance of hitting a target's ship.  *)
let fire_lst = [true; false; false; false]

(* [determine_fire] chooses a random element in fire_lst. *)
let determine_fire () = 
  let elt = Random.int 4 in
  List.nth fire_lst elt

let unhit_coord = ref (0, 0)
let unhit_found = ref false

(* [fire_unhit m] finds the first coordinate of matrix [m] that is Unhit and stores
  that coordinate in hit_coord *)
let fire_unhit m = 
  unhit_found := false;
  for i = 0 to Array.length m - 1 do
    for j = 0 to Array.length m.(i) - 1 do
      match m.(i).(j) with
      | Unhit -> if !unhit_found <> true then 
                unhit_found := true; 
                unhit_coord := (i, j)
      | _ -> ()
    done
  done

let empty_found = ref false
let empty_coord = ref (0, 0)

(* [hit_redo m] finds the first empty coordinate and saves it in empty_coord.
    This is important because if the board gets a lot of empty *)
let redo m = 
  empty_found := false;
  for i = 0 to Array.length m - 1 do
    for j = 0 to Array.length m.(i) - 1 do
      match m.(i).(j) with
      | Empty -> if !empty_found <> true then 
                empty_found := true; 
                empty_coord := (i, j)
      | _ -> ()
    done
  done
(* [redo_flip m] does the same thing as redo_x but flips *)
let redo_flip m = 
  empty_found := false;
  for i = 0 to Array.length m - 1 do
    for j = 0 to Array.length m.(i) - 1 do
      match m.(i).(j) with
      | Empty -> if !empty_found <> true then 
                empty_found := true; 
                empty_coord := (j, i)
      | _ -> ()
    done
  done

let get_valid_rndm_coord m =
  empty_found := false;
  for i = 0 to Array.length m - 1 do
    for j = 0 to Array.length m.(i) - 1 do
      let x = Random.int 10 in
      let y = Random.int 10 in
      match m.(x).(y) with
      | Empty -> if !empty_found <> true then 
                empty_found := true; 
                empty_coord := (x, y)
      | Hit -> redo m
      | Miss -> redo_flip m
      | Unhit -> fire_unhit m
      | _ -> redo m
    done
  done

let ai_fire m =
  match determine_fire () with
  | true -> fire_unhit m; 
            let x = fst !unhit_coord in
            let y = snd !unhit_coord in
            m.(x).(y) <- Hit; 
            m
  | false -> get_valid_rndm_coord m;
             let x = fst !empty_coord in
             let y = snd !empty_coord in
             m.(x).(y) <- Miss;
            m