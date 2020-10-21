open Curses

type command = | Place | Fire | Rotate | Quit 
               | Save | Up | Down | Left | Right 
               | Nuke | Surrender | Other

(* let key_pad = keypad scr true *)

let get_key win = 
  try
    match char_of_int (wgetch win) with
    | 'S' | 's' -> Down 
    | 'W' | 'w' -> Up
    | 'A' | 'a' -> Left
    | 'D' | 'd' -> Right
    | 'F' | 'f' -> Fire
    | 'R' | 'r' -> Rotate
    | 'Q' | 'q' -> Quit
    | 'P' | 'p' -> Place
    | 'N' | 'n' -> Nuke
    | 'M' | 'm' -> Surrender
    | _ -> Save
  with _ -> Save