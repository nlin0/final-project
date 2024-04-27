open Yojson

type t = (string * int) list

(** The Utils module includes simple functions that can be used across all of
    our ml files. *)
let remove_quotes str =
  let len = String.length str in
  if len >= 2 && str.[0] = '"' && str.[len - 1] = '"' then
    String.sub str 1 (len - 2)
  else str

let replace_newlines str =
  let len = String.length str in
  let rec replace index acc =
    if index >= len then acc
    else
      let current_char = str.[index] in
      match current_char with
      | '\\' when index + 1 < len && str.[index + 1] = 'n' ->
          replace (index + 2) (acc ^ "\n")
      | _ -> replace (index + 1) (acc ^ String.make 1 current_char)
  in
  replace 0 ""

let convert_str str =
  let str_no_quotes = remove_quotes str in
  replace_newlines str_no_quotes

let to_alst json =
  match json with
  | `Assoc assoc_list -> assoc_list
  | _ -> []

(** [load_json filepath] loads the json file and converts to json *)
let load_json filepath =
  let json = Yojson.Basic.from_file filepath in
  to_alst json

(** [get_val key alst] gets out the value associated with [key] from the
    association list [alst] *)
let get_val key alst =
  (* we can add options or exceptions.. idk if its needed tho *)
  List.assoc key alst

(** [print_msg key alst] prints out the value associated with [key] from the
    association list [alst] *)
let print_msg key alst =
  let to_print = convert_str (Yojson.Basic.to_string (get_val key alst)) in
  print_endline to_print

(** [get_nested key alst] grabs the child association list in the parent [alst]
    at [key] *)
let get_nested key alst =
  let nested_json = get_val key alst in
  to_alst nested_json

(** [print_nested_msg parent_key child_key alst] prints out the [child_key] of
    the child association list at [parent_key] in [alst] *)
let print_nested_msg parent_key child_key alst =
  let child_json = get_nested parent_key alst in
  print_msg child_key child_json
