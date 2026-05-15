# Assignment 5

## Problem 1: Functional Sets in Ruby (MySet)
This component implements a polymorphic functional set data structure (MySet) by wrapping Ruby’s native Array class internally through composition (subclassing Array is explicitly prohibited).
 - The Core Invariant: The internally managed array must maintain elements that are strictly unique (no duplicates) and ordered according to a customizable comparison strategy.
 - Custom Callbacks & Formats: The constructor accepts an optional block defining custom sort behavior (defaulting to the spaceship operator <=> if missing). It also overrides to_s to cleanly display the set in standard array notation and drops nil values upon insertion.
 - Mixin Integration: By integrating core Ruby mixins and a custom module, the class unlocks powerful ecosystem syntax:
   + Enumerable: Implementing the core .each iterator grants the set free access to structural methods like .map, .count, and .find.
   + FuncSet: Integrating this custom mixin overrides the bitwise operators for Union (|) and Intersection (&) to enable functional, set-theoretic math.
 - Safety Evaluation (Bonus): Features a theoretical discussion on whether the .map method inherited from Enumerable safely preserves the structural uniqueness and sorted invariants required by a functional set.

## Problem 2: DNA Analysis and Matrix Testing in APL
This component utilizes the dense, symbolic vector math of APL to build highly compact, single-line mathematical algorithms. For each task, the program must implement the algorithm twice: once using the standard direct function style (scoped dfn blocks using ⍺/⍵) and once using a purely tacit (point-free) format completely devoid of variable arguments.
 - Nucleotide Counter (count / count_t): Analyzes a string of biological text to accurately index and return the occurrence counts of the four standard DNA bases ('A', 'C', 'G', 'T'), safely defaulting to zeroes for empty or invalid strings.
 - GC Content Calculator (gc / gc_t): Measures genomic composition by calculating the strict percentage of character nodes in a string that belong to either 'C' or 'G'.
 - Magic Square Validator (magic / magic_t): Runs a structural matrix check on a 2D square array. It computes and compares the arithmetic summation of every horizontal row, vertical column, and both cross-sectional main diagonals, returning 1 if all values match perfectly (a magic square) and 0 otherwise.
