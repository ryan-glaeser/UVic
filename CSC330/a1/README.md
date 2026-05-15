# Assignment 1

## Problem 1: Date Manipulation Library
This component implements functional date operations using a strict set of constraints (no pattern matching or match statements allowed). Working with dates represented as (year, month, day) tuples, it performs the following:
Chronological Comparison: Determines if one date occurs before another.Calendar 
Calculations: Calculates the number of days in a month (accounting for leap year rules), generates a list of all valid dates in a given month, and converts back and forth between a specific calendar date and its ordinal day-of-the-year number (e.g., the $n$-th day).
Validation: Ensures all outputs are safely wrapped in option types (Some/None) based on whether the input years, months, and days fall within valid Gregorian calendar ranges (up to the year 3000).

## Problem 2: Inflation Data Analyzer
This component parses and analyzes a real-world World Bank CSV dataset containing global inflation rates from 1960 onward. In contrast to the first problem, this section relies heavily on pattern matching and tail-recursive functions to do the following:
Data Parsing: Converts a raw string of CSV data into structured OCaml records containing a country's name, three-letter ID, and a list of yearly inflation rates (handling missing data as None).
Statistical Metrics: Scans a country's record using efficient tail recursion to calculate the total number of years with available data, locate the most recent available data point, and identify the years with the historical minimum and maximum inflation rates.
Reporting: Generates a clean, formatted text summary of a specific country's inflation history by its ID, with a bonus utility function built to efficiently concatenate strings.
