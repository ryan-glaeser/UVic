(* Assignment 4 *)
(* Do not make changes to this code except where you see comments containing the word TODO. *)


(* Expressions in a little language for 2D geometry objects
     Values:   points, lines, vertical lines, line segments
     The rest: intersection of two expressions, lets, variables,
               and shifts (added by you) *)
type geom_exp =
  | Nope
  (* represents point (x,y) *)
  | Point of (float * float)
  (* represents line (slope, intercept) *)
  | Line of (float * float)
  (* x value *)
  | VerticalLine of float
  (* x1, y1 to x2, y2 *)
  | LineSegment of (float * float * float * float)
  (* intersection expression *)
  | Intersect of (geom_exp * geom_exp)
  (* let s = e1 in e2 *)
  | Let of (string * geom_exp * geom_exp)
  | Var of string
(** TODO: add shifts for expressions of the form Shift(deltaX, deltaY, exp) **)
  | Shift of (float * float * geom_exp)

exception BadProgram of string
exception Impossible of string


(* Helpers for comparing float numbers since rounding means we should never compare for equality *)
let epsilon = 0.00001
let eq r1 r2 = Float.abs (r1 -. r2) < epsilon
let eq_point (x1, y1) (x2, y2) = eq x1 x2 && eq y1 y2


(* Helper: return the Line or VerticalLine containing points (x1, y1) and (x2, y2).
   Used only when intersecting line segments. *)
let two_points_to_line (x1, y1, x2, y2) =
  if eq x1 x2 then VerticalLine x1
  else
    let m = (y1 -. y2) /. (x1 -. x2) in
    let b = y2 -. (m *. x2) in
    Line (m, b)


(* Helper for interpreter: return value that is the intersection of the arguments.
   There are 25 cases because there are 5 kinds of values, but many cases can be combined,
   especially because intersection is commutative.
   Note: do *not* call this function with non-values (e.g., shifts or lets)! *)
let rec intersect v1 v2 =
  match (v1, v2) with
  | Nope, _ | _, Nope -> Nope (* 9 cases *)
  | Point p1, Point p2 -> if eq_point p1 p2 then v1 else Nope
  | Point (x, y), Line (m, b) ->
      if eq y ((m *. x) +. b) then v1 else Nope
  | Point (x1, _), VerticalLine x2 -> if eq x1 x2 then v1 else Nope
  | Point _, LineSegment _ | Line _, Point _ -> intersect v2 v1
  | Line (m1, b1), Line (m2, b2) ->
      if eq m1 m2 then
        if eq b1 b2 then v1 (* same line *) else Nope (* parallel *)
      else
        (* one-point intersection *)
        let x = (b2 -. b1) /. (m1 -. m2) in
        let y = (m1 *. x) +. b1 in
        Point (x, y)
  | Line (m1, b1), VerticalLine x2 -> Point (x2, (m1 *. x2) +. b1)
  | Line _, LineSegment _ | VerticalLine _, Point _ | VerticalLine _, Line _ ->
      intersect v2 v1
  | VerticalLine x1, VerticalLine x2 ->
      if eq x1 x2 then v1 (* same line *) else Nope (* parallel *)
  | VerticalLine _, LineSegment seg -> intersect v2 v1
  | LineSegment seg, _ -> (
      (* The hardest case: 4 cases because v2 could be a point, line, vertical line, or line segment *)
      (* First compute the intersection of:
          (1) the line containing the segment, and
          (2) v2.
         Then use that result to compute what we need. *)
      match intersect (two_points_to_line seg) v2 with
      | Nope -> Nope
      | Point (x0, y0) ->
          (* See if the point is within the segment bounds (assumes v1 was preprocessed) *)
          let inbetween v end1 end2 =
            (end1 -. epsilon <= v && v <= end2 +. epsilon) ||
            (end2 -. epsilon <= v && v <= end1 +. epsilon)
          in
          let x1, y1, x2, y2 = seg in
          if inbetween x0 x2 x1 && inbetween y0 y2 y1 then Point (x0, y0)
          else Nope
      | Line _ -> v1 (* So segment seg is on line v2 *)
      | VerticalLine _ -> v1 (* So segment seg is on vertical-line v2 *)
      | LineSegment seg2 ->
          (* The hard case within the hardest case:
             seg and seg2 are on the same line (or vertical line), but they could be
              (1) disjoint, or
              (2) overlapping, or
              (3) one inside the other, or
              (4) just touching.
             And we treat vertical segments differently, so there are 4*2 cases. *)
          let x1end, y1end, x1start, y1start = seg in
          let x2end, y2end, x2start, y2start = seg2 in
          if eq x1start x1end then
            (* The segments are on a vertical line *)
            (* Let segment a start at or below start of segment b *)
            let (aXend, aYend, aXstart, aYstart), (bXend, bYend, bXstart, bYstart) =
              if y1start < y2start then (seg, seg2) else (seg2, seg)
            in
            if eq aYend bYstart then Point (aXend, aYend) (* just touching *)
            else if aYend < bYstart then Nope (* disjoint *)
            else if aYend > bYend then LineSegment (bXend, bYend, bXstart, bYstart) (* b inside a *)
            else LineSegment (aXend, aYend, bXstart, bYstart) (* overlapping *)
          else
            (* The segments are on a (non-vertical) line *)
            (* Let segment a start at or to the left of start of segment b *)
            let (aXend, aYend, aXstart, aYstart), (bXend, bYend, bXstart, bYstart) =
              if x1start < x2start then (seg, seg2) else (seg2, seg)
            in
            if eq aXend bXstart then Point (aXend, aYend) (* just touching *)
            else if aXend < bXstart then Nope (* disjoint *)
            else if aXend > bXend then LineSegment (bXend, bYend, bXstart, bYstart) (* b inside a *)
            else LineSegment (aXend, aYend, bXstart, bYstart) (* overlapping *)
      | _ -> raise (Impossible "bad result from intersecting with a line"))
  | _ -> raise (Impossible "bad call to intersect: only for shape values")


(* Interpreter for our language:
   - Takes a geometry expression and returns a geometry value
   - For simplicity we have the top-level function take an environment,
     (which should be [] for the whole program
   - We assume the expression e has already been "preprocessed" as described in the assignment:
      * line segments are not actually points (endpoints not float close), and
      * lines segment have right (or, if vertical, top) coordinate first. *)
let rec eval_prog e env =
  match e with
  (* Values: no computation *)
  | Nope | Point _ | Line _ | VerticalLine _ | LineSegment _ -> e
  | Var s -> (
      match List.find_opt (fun (n, _) -> s = n) env with
      | None -> raise (BadProgram ("var not found: " ^ s))
      | Some (_, v) -> v)
  | Let (s, e1, e2) -> eval_prog e2 ((s, eval_prog e1 env) :: env)
  | Intersect (e1, e2) -> intersect (eval_prog e1 env) (eval_prog e2 env)
(** TODO: Add a case for Shift expressions **)
  | Shift (deltaX, deltaY, e) -> 
      let v = eval_prog e env in
      match v with
      | Nope -> Nope
      | Point (x, y) -> Point (x +. deltaX, y +. deltaY)
      | Line (m, b) -> Line (m, b +. deltaY -. (m *. deltaX))
      | VerticalLine x -> VerticalLine (x +. deltaX)
      | LineSegment (x1, y1, x2, y2) ->
          LineSegment (x1 +. deltaX, y1 +. deltaY, x2 +. deltaX, y2 +. deltaY)
      | _ -> raise (Impossible "bad value for shift")

(** TODO: Add function preprocess_prog of type geom_exp -> geom_exp **)
let rec preprocess_prog e =
  match e with
  | LineSegment (x1, y1, x2, y2) ->
      if eq x1 x2 && eq y1 y2 then Point (x1, y1)
      else if eq x1 x2 && y1 < y2 then LineSegment (x2, y2, x1, y1)
      else if eq y1 y2 && x1 < x2 then LineSegment (x2, y2, x1, y1)
      else if x1 < x2 && y1 < y2 then LineSegment (x2, y2, x1, y1)
      else LineSegment (x1, y1, x2, y2)
  | Intersect (e1, e2) -> Intersect (preprocess_prog e1, preprocess_prog e2)
  | Let (s, e1, e2) -> Let (s, preprocess_prog e1, preprocess_prog e2)
  | Shift (deltaX, deltaY, e) -> Shift (deltaX, deltaY, preprocess_prog e)
  | _ -> e
