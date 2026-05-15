# Assignment 4

## The Geometry Language & Semantics
The core program models and evaluates expressions consisting of five geometric values:
 - Empty sets (Nope)
 - Sub-atomic floating-point shapes (Point, Line, VerticalLine, LineSegment)
 - Functional execution nodes (Var for variable environment lookups, Let bindings, Shift operations to translate coordinates, and Intersect nodes to dynamically compute geometric overlap).
To prevent precision bugs, the program uses custom delta-threshold testing ($0.00001$) instead of standard float equality.

## Part 1: The OCaml Implementation (Functional Paradigm)
The OCaml half acts as the structural baseline for the project, relying heavily on variant types, algebraic data structures, and deep pattern matching.
 - Expression Preprocessing: Implements preprocess_prog to enforce language invariants. It cleanses incoming data trees by flattening invalid, zero-length LineSegment shapes into single Point primitives and systematically reordering segment endpoints to a fixed spatial layout (higher $x$-axis, or higher $y$-axis on vertical stacks).
 - Environment Execution: Extends the pre-existing interpreter to evaluate Shift mechanics via immutable environment tracking.

## Part 2: The Ruby Implementation (Object-Oriented Paradigm)
The Ruby half replicates the exact behavior of the OCaml interpreter but strictly reformats it into an object-oriented architecture. It maps the variant constructors into distinct class blueprints subclassing GeometryExpression and GeometryValue.
 - OOP Translation: Spreads the logic of execution and structural cleanup natively into individual instance methods (preprocess_prog, eval_prog, and shift) embedded directly inside their respective data classes, avoiding mutation and keeping objects immutable.
 - Double Dispatch Matrix (omatch via Messaging): To calculate intersections without violating pure OOP design principles (explicitly forbidden from using type/class reflection methods like is_a? or instance_of?), the program implements double dispatching. When two shapes intersect, they trade messages (e.g., a Point calls intersectPoint back onto the target shape). This handles a 25-case geometric intersection matrix purely through dynamic routing and object-oriented polymorphism.
