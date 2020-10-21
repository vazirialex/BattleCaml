open Gameboard
open Random

let coordlst_x = ref [0;1;2;3;4;5;6;7;8;9]
let coordlst_y = ref [0;1;2;3;4;5;6;7;8;9]

(* [filter coord coordlst] updates [coordlst] to remove [coord]. It then returns
that list. *)
let filter coord coordlst = 
  let func = (fun lst -> if lst <> coord then true else false) in
  coordlst := List.filter func !coordlst;
  !coordlst

(* [choose_rnd_elt lst] chooses 2 elements in a list. and makes a tuple out of them *)
let choose_rnd_elt lst = 
  let rnd_elt = Random.int (List.length !lst) in
  let (rnd_ind_x, rnd_ind_y) = List.nth !lst rnd_elt in
  (rnd_ind_x, rnd_ind_y)
 
(* [cartesian_product x_lst y_lst] calculates the cartesian product of [x_lst]x[y_lst].
The end result is a list of tuples of all different coordinate pair combinations *)
let rec cartesian_product x_lst y_lst = 
    match x_lst, y_lst with
    | [], _ | _, [] -> []
    | h1::t1, h2::t2 -> let fstlst = (cartesian_product [h1] t2) in
                        let sndlst = (cartesian_product t1 y_lst) in
                        let newlst = fstlst@sndlst in
                        (h1,h2)::newlst

(* [shuffle lst]  returns a list whose elements from [lst] are randomly
shuffled. *)
let shuffle lst =
  let func = (fun tup -> (Random.bits (), tup)) in
  let new_lst = List.map func lst in
  let sort = List.sort compare new_lst in
  List.map snd sort

(* [generate_coordinates] is a shuffledlist of all possible coordinates 
  in the 10x10 matrix *)
let generate_coordinates = 
  let prod = cartesian_product !coordlst_x !coordlst_y in
  (shuffle prod)

(* [list_generated] a reference to generate_coordinates *)
let list_generated = ref generate_coordinates

(* [ai_fire m] randomly seleted a coordinate in list_generated and fires at it.
  Because this is the easy mode, there is a small chance that the AI fires
  somewhere that it has already hit, thus losing its turn to fire. *)
let ai_fire m = 
  if !list_generated <> [] then
    let (x, y) = choose_rnd_elt list_generated in
    ignore (filter (x, y) list_generated);
    match m.(x).(y) with
      | Unhit ->  m.(x).(y) <- Hit; m
      | Empty -> m.(x).(y) <- Miss; m
      | _ -> m
    else
      raise (Invalid_argument "This will not be possible")