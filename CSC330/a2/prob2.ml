(* CSC330: Assignment 2, Problem 2
 * Ryan Glaeser 
 * V00832892 *)

type ovalue =
  | Str of string
  | Int of int
  | Table of okeyvalue list
  | ListOf of ovalue list
  and okeyvalue = string * ovalue
  and otable = string * okeyvalue list
  and otoml = otable list


(* This function zips two lists into a list of pairs.
 * Returns None for lists of unequal length *)
let rec zip lst1 lst2 =
  try Some (List.combine lst1 lst2)
  with Invalid_argument _ -> None

(* This function takes a function and maps it over
 * a list, returning a new list of the form
 * [x1; f(x1); x2; f(x2); ...] where xi are elements
 * of the original list*)
let rec flatmap f lst = 
  List.concat_map f lst

let flatmap_opt f lst =
  let aux acc x =
    match acc, f x with
    | Some current_list, Some new_elements -> 
        Some (List.append current_list new_elements)
    | _ -> None
  in
  List.fold_left aux (Some []) lst

let get_strings (t : otoml) : (string * string) list =
  let rec collect_values table_name v =
    match v with
    | Str s -> [(table_name, s)]
    | Int _ -> []
    | ListOf vs -> flatmap (collect_values table_name) vs
    | Table kvs -> flatmap (fun (_, v') -> collect_values table_name v') kvs
  in
  flatmap (fun (table_name, kvs) ->
    flatmap (fun (_, v) -> collect_values table_name v) kvs
  ) t