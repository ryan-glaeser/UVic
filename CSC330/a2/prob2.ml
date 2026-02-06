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

type opattern =
| WildcardPattern
| BindPattern of string
| StringPattern of string
| IntPattern of int
| TablePattern of (string * opattern) list
| ListPattern of opattern list

type otype =
| StrType
| IntType
| ListType of otype
| TableType of otype list


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

(* This function does the same as the above function
 * but returns None if any of the function transformations
 * fail *)
let flatmap_opt f lst =
  let aux acc x =
    match acc, f x with
    | Some current_list, Some new_elements -> 
        Some (List.append current_list new_elements)
    | _ -> None
  in
  List.fold_left aux (Some []) lst

(* This function parses an otoml record and returns a
 * list of (table_name, string) pairs for all strings
 * in the record *)
let get_strings (t : otoml) : (string * string) list =
  let rec get_values table_name ov =
    match ov with
    | Str s -> [(table_name, s)]
    | Int _ -> []
    | Table okv_lst -> flatmap (fun (_, v') -> get_values table_name v') okv_lst
    | ListOf ov_lst -> flatmap (get_values table_name) ov_lst
  in
  (* Begin processing outer otoml record *)
  flatmap (fun (table_name, okv_lst) ->
    flatmap (fun (_, v) -> get_values table_name v) okv_lst
  ) t

(* This function checks if a string is uppercase *)
let is_uppercase s =
  String.uppercase_ascii s = s

(* This function returns a list of all strings in an
 * otoml record that are uppercase *)
let get_uppercase_strings_1 (t: otoml) : string list =
  let (%) f g x = f (g x) in
  (List.map snd % List.filter (fun (_, s) -> is_uppercase s) % get_strings) t

(* This function does the same as the function above, but
 * using the |> pipeline operator *)
let get_uppercase_strings_2 (t: otoml) : string list =
  t |> get_strings |> List.filter (fun (_, s) -> is_uppercase s) |> List.map snd

(* This function takes a pattern and an OToml value and returns a list of
 * matched bindings and their values *)
let rec omatch (pattern : opattern) (value : ovalue) : (string * ovalue) list option =
  match pattern, value with
  | WildcardPattern, _ -> Some []
  | BindPattern s, _ -> Some [(s, value)]
  | StringPattern s1, Str s2 -> 
      if s1 = s2 then Some [] else None
  | IntPattern i1, Int i2 ->
      if i1 = i2 then Some [] else None
  | ListPattern pats, ListOf vals ->
      (match zip pats vals with
       | Some pairs -> flatmap_opt (fun (p, v) -> omatch p v) pairs
       | None -> None)
  | TablePattern pat_keyvals, Table val_keyvals ->
      (match zip pat_keyvals val_keyvals with
       | Some pairs -> 
           flatmap_opt (fun ((p_key, p_pat), (v_key, v_val)) ->
             if p_key = "" || p_key = v_key then
               omatch p_pat v_val
             else 
               None
           ) pairs
       | None -> None)
  | _ -> None


(* Bonus questions *)
let ocheck (tml : otoml) : bool = false

let otypecheck (tml : otoml) : otype list option = None