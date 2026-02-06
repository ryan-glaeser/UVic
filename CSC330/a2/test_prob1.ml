(* Testing *)
open Prob1

let testing () =
  let cmp = Int.compare in
  let set = FuncSet.empty_set cmp in
  assert (FuncSet.is_empty set = true);
  print_string ("is_empty test 1: passed\n");
  let set = FuncSet.insert set 1 in
  assert (FuncSet.is_empty set = false);
  print_string ("insert test 1: passed\n");
  assert (FuncSet.size set = 1);
  print_string ("size test 1: passed\n");
  assert (FuncSet.to_list set = [1]);
  print_string ("to_list test 1: passed\n");
  let set = FuncSet.insert set (-1) in
  assert (FuncSet.size set = 2);
  print_string ("insert test 2: passed\n");
  assert (FuncSet.to_list set = [-1; 1]);
  print_string ("to_list test 2: passed\n");
  let set = FuncSet.remove set (-1) in
  assert (FuncSet.size set = 1);
  print_string ("remove test 1: passed\n");
  try
    let _ = FuncSet.remove set 2 in
    assert false
  with
  | FuncSet.EmptySet -> print_string ("remove test 2: passed\n");
  assert (FuncSet.to_list set = [1]);
  print_string ("to_list test 3: passed\n");
  let set2 = FuncSet.insert (FuncSet.insert (FuncSet.insert (FuncSet.empty_set cmp) 1) 2) (-1) in
  assert (FuncSet.size set2 = 3);
  print_string ("insert test 3: passed\n");
  assert (FuncSet.to_list(FuncSet.union set set2) = [-1; 1; 2]);
  print_string ("union test 1: passed\n");
  assert (FuncSet.to_list(FuncSet.intersect set set2) = [1]);
  print_string ("intersect test 1: passed\n");
  assert (FuncSet.to_list(FuncSet.from_list cmp [3; 2; 1; 2; 3]) = [1; 2; 3]);
  print_string ("from_list test 1: passed\n");
  assert (FuncSet.to_list(FuncSet.from_list cmp [100; 1; 2; -2; 2; 1]) = [-2; 1; 2; 100]);
  print_string ("from_list test 2: passed\n");
  assert(FuncSet.to_list(FuncSet.map (fun x -> x mod 2) set2) = [-1; 0; 1]);
  print_string ("map test 1: passed\n");
  assert (FuncSet.fold (fun acc x -> acc + x) 0 set2 = 2);
  print_string ("fold test 1: passed\n");
  assert (FuncSet.fold (fun acc x -> acc * x) 0 set2 = 0);
  print_string ("fold test 2: passed\n");
  assert (FuncSet.fold (fun acc x -> acc * x) 5 set2 = -10);
  print_string ("fold test 3: passed\n");
  let open FuncSet in
  assert (to_list @@ empty_set cmp ++ 1 ++ 2 ++ 3 ++ 1 = [1; 2; 3]);
  print_string ("infix operator test 1: passed\n");

  ()

let _ = testing ()
