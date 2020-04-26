+==============+
|| Homework 2 ||
+==============+

CS 381 Spring 2020
Kendrea Beers, Robert Detjens, Jackson Golletz, Lyell Read, Zach Rogers

+------------+
| Exercise 1 |
| Mini Logo  |
+------------+

cmd  ::= pen mode
      | moveto (pos, pos)
      | def name (pars) cmd
      | call name (vals)
      | cmd; cmd
mode ::= up | down
pos  ::= num | name
pars ::= name, pars | name
vals ::= num, vals | num

(a) Define the abstract syntax for Mini Logo as a Haskell data type.

> data Cmd  = Pen Mode 
>           | Moveto Pos Pos
>           | Def String Pars [Cmd]
>           | Call String Vals
> data Mode = Up      | Down
> data Pos  = Lit Int | Ref String
> type Pars = [String]
> type Vals = [Int]

Code comments: 
The abstract grammar uses parentheses and commas for clarification only; we can ignore them.
Line 27 defines a function "String" with parameters "Pars" that executes a program (array of "Cmd"s).
The line "cmd; cmd" in the abstract syntax shows that a command can be a series of commands; this is accounted for by making Line 27 use an array of commands instead of just "Cmd".

(b) Write a Mini Logo macro `vector` that draws a line from a given position (x1, y1) to a given position (x2, y2). Represent the macro in abstract syntax, that is, as a Haskell data type value.

(c) Define a Haskell function `steps :: Int -> Cmd` that constructs a Mini Logo program which draws a stair of n steps. Your solution should not use the macro `vector`.

+-------------------------------+
| Exercise 2                    |
| Digital Logic Design Language |
+-------------------------------+

circuit ::= gates links
gates   ::= num:gateFn ; gates | epsilon
gateFn  ::= and | or | xor | not
links   ::= from num.num to num.num; links | epsilon

(a) Define the abstract syntax for the DiCiDL language as a Haskell data type.

> data Circuit = BuildCircuit Gates Links
> type Gates   = [(Int, GateFn)]
> data GateFn  = And | Or | Xor | Not
> type Links   = [((Int, Int), (Int, Int))]

(b) Represent the half adder circuit in abstract syntax, that is, as a Haskell data type value.

Half Adder for A and B --> Carry = A & B; Sum = A XOR B

(c) Define a Haskell function that implements a pretty printer for the abstract syntax.