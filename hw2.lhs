+==============+
|| Homework 2 ||
+==============+

CS 381 Spring 2020
Kendrea Beers, Robert Detjens, Jackson Golletz, Lyell Read, Zach Rogers

+------------+
| Exercise 1 |
| Mini Logo  |
+------------+

(a) Define the abstract syntax for Mini Logo as a Haskell data type.

(b) Write a Mini Logo macro `vector` that draws a line from a given position (x1, y1) to a given position (x2, y2). Represent the macro in abstract syntax, that is, as a Haskell data type value.

(c) Define a Haskell function `steps :: Int -> Cmd` that constructs a Mini Logo program which draws a stair of n steps. Your solution should not use the macro `vector`.

+-------------------------------+
| Exercise 2                    |
| Digital Logic Design Language |
+-------------------------------+

(a) Define the abstract syntax for the DiCiDL language as a Haskell data type.

(b) Represent the half adder circuit in abstract syntax, that is, as a Haskell data type value.

(c) Define a Haskell function that implements a pretty printer for the abstract syntax.