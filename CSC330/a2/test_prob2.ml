(* Testing *)
open Prob2

let testing () =
  assert (zip [1; 2; 3] ['a'; 'b'; 'c'] = Some [(1, 'a'); (2, 'b'); (3, 'c')]);
  print_string ("zip test 1: passed\n");
  assert (zip [] [] = Some []);
  print_string ("zip test 2: passed\n");
  assert (zip [1; 2] ['a'] = None);
  print_string ("zip test 3: passed\n");
  assert (zip [1; 2; 3] ['a'; 'b'] = None);
  print_string ("zip test 4: passed\n");

  assert (flatmap (fun x -> [x; -x]) [1; 2; 3] = [1; -1; 2; -2; 3; -3]);
  print_string ("flatmap test 1: passed\n");
  assert (flatmap (fun x -> []) [1; 2; 3] = []);
  print_string ("flatmap test 2: passed\n");
  assert (flatmap (fun x -> [x; x * x]) [1; 2; 3; 4; 5] = [1; 1; 2; 4; 3; 9; 4; 16; 5; 25]);
  print_string ("flatmap test 3: passed\n");

  assert (flatmap_opt (fun x -> if x mod 2 = 0 then Some [x; -x] else None) [1; 2; 4] = None);
  print_string ("flatmap_opt test 1: passed\n");
  assert (flatmap_opt (fun x -> if x mod 2 = 0 then Some [x; -x] else None) [2; 4; 6] = Some [2; -2; 4; -4; 6; -6]);
  print_string ("flatmap_opt test 2: passed\n");
  assert (flatmap_opt (fun x -> Some x) [] = Some []);
  print_string ("flatmap_opt test 3: passed\n");

  let t = [
    "table1", [ ("str", Str "hello");
    ("int", Int 5);
    ("table", Table ["a", Str "x"; "b", Str "Y"]);
    ("list", ListOf [Int 1; Int 2]) ];
    "table2", [ ("something", Str "maybe" )] ] 
  in
  assert (get_strings t = [("table1", "hello"); ("table1", "x"); ("table1", "Y"); ("table2", "maybe")]);
  print_string ("get_strings test 1: passed\n");
  ()

let _ = testing ()