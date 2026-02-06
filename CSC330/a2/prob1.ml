(* CSC330: Assignment 2, Problem 1
 * Ryan Glaeser 
 * V00832892 *)

module type FSET = sig
type 'a set
exception EmptySet
val empty_set : ('a -> 'a -> int) -> 'a set
val is_empty : 'a set -> bool
val size : 'a set -> int
val insert : 'a set -> 'a -> 'a set
val remove : 'a set -> 'a -> 'a set
val union : 'a set -> 'a set -> 'a set
val intersect : 'a set -> 'a set -> 'a set
val from_list : ('a -> 'a -> int) -> 'a list -> 'a set
val to_list : 'a set -> 'a list
val map : ('a -> 'a) -> 'a set -> 'a set
val fold : ('a -> 'b -> 'a) -> 'a -> 'b set -> 'a
end

module FuncSet : FSET = struct
  type 'a set = ('a -> 'a -> int) * 'a list
  exception EmptySet

  (* This function creates an empty set *)
  let empty_set cmp =
    (cmp, [])

  (* This function checks if the set is empty *)
  let is_empty (cmp, elements) =
    elements = []

  (* This function returns the size of the set *)
  let size (cmp, elements) =
    List.length elements
  
  (* This function inserts an element into the set*)
  let insert (cmp, elements) x =
    let rec add lst =
      match lst with 
      | [] -> [x]
      | head :: tail ->
        match cmp x head with
        | 0 -> head :: tail
        | n when n < 0 -> x :: head :: tail
        | _ -> head :: add tail
    in
    (cmp, add elements)

  (* This function removes an element from the set *)
  let remove (cmp, elements) x =
    let rec delete lst =
      match lst with
      | [] -> raise EmptySet
      | head :: tail ->
        match cmp x head with
        | 0 -> tail
        | n when n < 0 -> raise EmptySet
        | _ -> head :: delete tail
    in
    (cmp, delete elements)
  
  (* This function returns a new set consisting of
   * the union of the two given sets *)
  let union (cmp, elements1) (_, elements2) =
    let rec merge lst1 lst2 =
      match lst1, lst2 with
      | [], lst | lst, [] -> lst
      | head1 :: tail1, head2 :: tail2 ->
        match cmp head1 head2 with
        | 0 -> head1 :: merge tail1 tail2
        | n when n < 0 -> head1 :: merge tail1 lst2
        | _ -> head2 :: merge lst1 tail2
    in
    (cmp, merge elements1 elements2)

  (* This union returns a new set consisting of
   * the intersection of the two given sets *)
  let intersect (cmp, elements1) (_, elements2) =
    let rec find_intersects lst1 lst2 =
      match lst1, lst2 with
      | [], _ | _, [] -> []
      | head1 :: tail1, head2 :: tail2 ->
        match cmp head1 head2 with
        | 0 -> head1 :: find_intersects tail1 tail2
        | n when n < 0 -> find_intersects tail1 lst2
        | _ -> find_intersects lst1 tail2
    in
    (cmp, find_intersects elements1 elements2)

  (* This function creates a set from a given list *)
  let from_list cmp lst = 
    (cmp, List.sort_uniq cmp lst)

  (* This function converts a set to a list *)
  let to_list (cmp, elements) = 
    elements

  (* This function returns a new set with the
   * given function mapped to each element of the set *)
  let map f (cmp, elements) = 
    let mapped_list = List.map f elements in
    (cmp, List.sort_uniq cmp mapped_list)

  (* This function implements a left fold
   * on the set with the given function*)
  let rec fold f acc (cmp, elements) =
    List.fold_left f acc elements

end

(* Bonus Questions
 *
 *
 * 12.
 *   One issue stemming from the union and intersect functions
 *   comes from their comparator functions. If the two sets do
 *   not use the same comparator function, the results of these
 *   functions may be incorrect. For example, if one set orders
 *   by string length, and one alphabetically, the signature
 *   doesn't specify which comparator function to use for the
 *   resulting set.
 *   Another issue is the naming of the EmptySet exception.
 *   This exception is used in the remove function to indicate
 *   that the element to be removed is not in the set. However,
 *   a user may check a list of 10 elements and raise this
 *   exception, which may lead them to believe the set is empty,
 *   when it is not.
 *
 * 13.
 *  The difference between the standard library map function's
 *  type and ours comes from the comparator function. If our
 *  map function changed the type of the set elements, we would
 *  need a different comparator function to maintain the 
 *  ordered and unique invariants of the set.
 *
 * 14. 
 * This function defines an infix operator for set building
 * outside the module *)
 let ( ++ ) set element =
    FuncSet.insert set element