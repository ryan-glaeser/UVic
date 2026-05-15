# Assignment 3

## Problem 1: Stream Warm-up & Macros
This component implements functional programming utilities for lazy sequences (streams) and introduces dynamic syntax creation using Racket macros.
 - Stream Evaluation: Implements functions to safely extract and list the first $n$ steps of a stream, and creates a functional filter-stream primitive to dynamically filter infinite sequences.
 - Mathematical Sequences: Builds a standard, infinite Fibonacci sequence stream (fibo-stream).
 - Custom Macro Integration: Constructs a Racket macro named create-stream. This macro defines a domain-specific syntax (create-stream name using f starting at i0 with increment delta) that generates customizable numeric sequences, ensuring strict lazy evaluation rules for its starting value and structural step increments.

## Problem 2: The MF/PL Language Interpreter & Ecosystem
This component builds an entire tree-walking interpreter, macro system, and standard library for a custom functional programming language called MF/PL (My First Programming Language), embedded directly inside Racket structs.
 - Data Marshalling: Implements bridge functions (rkt-list->mfpl-list and vice versa) to translate standard native Racket list structures into and out of nested MF/PL data pairs that terminate with an empty (aunit).
 - The Core Interpreter (eval-exp): Implements the primary evaluation engine. It handles variable scoping using environment lookup lists, computes basic arithmetic (add), and handles conditional branches (if>). It implements lexically-scoped first-class functions (creating internal closure values) and manages explicit memory/tuple tracking through pair commands (apair, fst, snd). It includes robust runtime exception handling for unbound variables and type mismatches.
 - Syntactic Sugar / Macros: Expands the language without changing the core interpreter by writing Racket functions that output complex MF/PL code structures. These include ifaunit (a unit-testing conditional), mlet* (sequential, nested variable bindings), and if= (an equality conditional built purely out of the interpreter's original "greater-than" logic).
 - Standard Library Programs: Uses the newly created language to write native, curried MF/PL software utilities. This includes binding a fully functional mapping framework (mfpl-map) for lists, and a specialized application (mfpl-map-add-N) that increments lists of integers using the language's own closures and variables.
