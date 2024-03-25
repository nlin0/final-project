open Yojson
open Utils

let () =
  (* to_alst and load_json IS IN UTILS. Do we wanna keep them in diff files
     (?) *)
  let intro = load_json "text_dat/intro.json" in
  let start = get_nested "start" intro in
  let start_prompt = get_val "instructions" start in
  let () = print_endline "test" in
  print_endline (Yojson.Basic.to_string start_prompt)

(* use dune utop to test... this prints above the utop interface for some reason
   though ;-; *)
