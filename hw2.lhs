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
>           | Def String Pars Cmd
>           | Call String Vals
>           | Cons Cmd Cmd
>           deriving Show
> data Mode = Up      | Down
>           deriving Show
> data Pos  = Lit Int | Ref String
>           deriving Show
> type Pars = [String]
> type Vals = [Int]

Code comments: 
The abstract grammar uses parentheses and commas for clarification only; we can ignore them.
Line 27 defines a function "String" with parameters "Pars" that executes a program "Prog".

(b) Write a Mini Logo macro `vector` that draws a line from a given position (x1, y1) to a given position (x2, y2). Represent the macro in abstract syntax, that is, as a Haskell data type value.

`arrToCons` is a helper function to avoid piles of nested parentheses and instead use a nice array of commands.

> arrToCons :: [Cmd] -> Cmd
> arrToCons (x:[]) = x
> arrToCons (x:xs) = Cons x (arrToCons xs)

`vector` is the Mini Logo macro that answers the question.

> vector :: Cmd
> vector = Def "vector" ["x0", "y0", "x1", "y1"] 
>          (arrToCons [Pen Up, 
>          Moveto (Ref "x0") (Ref "y0"),
>          Pen Down, 
>          Moveto (Ref "x1") (Ref "y1")])

Just for reference, here's what `vector` could look like as a Haskell function:
vectorHaskell :: Int -> Int -> Int -> Int -> Cmd
vectorHaskell x0 y0 x1 y1 = [Pen Up, Moveto (Lit x0) (Lit y0), Pen Down, Moveto (Lit x1) (Lit y1)]

(c) Define a Haskell function `steps :: Int -> Cmd` that constructs a Mini Logo program which draws a stair of n steps. Your solution should not use the macro `vector`.

This function draws a stairstep from top right to bottom left, starting at (n,n) and ending at (0,0).

Example run-through of `steps 3`: The pen moves to (3,3), draws to (2,3), draws to (2,2), checks that it is at (2,2), draws to (1,2), draws to (1,1), checks that it is at (1,1), draws to (0,1), draws to (0,0), and finally lifts up.

> steps :: Int -> Cmd
> steps n 
>   | n<=0      = Pen Up
>   | otherwise = arrToCons
>                 [Pen Up,
>                 Moveto (Lit n) (Lit n),
>                 Pen Down,
>                 Moveto (Lit (n-1)) (Lit (n)),
>                 Moveto (Lit (n-1)) (Lit (n-1)),
>                 steps (n-1)]

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