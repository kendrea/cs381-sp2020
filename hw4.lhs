+==============+
|| Homework 4 ||
+==============+

CS 381 Spring 2020
Kendrea Beers, Robert Detjens, Jackson Golletz, Lyell Read, Zach Rogers

+-----------------+
| Exercise 1      |
| A Rank-Based    |
| Type System     |
| for the         |
| Stack Language  |
+-----------------+

"We extend the simple stack language from Homework 2 (Exercise 1) by the following three operations.
• INC increments the topmost element on the stack
• SWAP exchanges the two topmost elements on the stack 
• POP k pops k elements of the stack"

"The abstract syntax of this extended language is as follows."

> type Prog = [Cmd]
> data Cmd = LD Int
>          | ADD
>          | MULT
>          | DUP
>          | INC
>          | SWAP
>          | POP Int

"Even though the stack carries only integers, a type system can be defined for this language that assigns ranks to stacks and operations and ensures that a program does not result in a rank mismatch.
The rank of a stack is given by the number of its elements. The rank of a single stack operation is given by a pair of numbers (n, m) where n indicates the number of elements the operation takes from the top of the stack and m is number of elements the operation puts onto the stack. The rank for a stack program is defined to be the rank of the stack that would be obtained if the program were run on an empty stack. A rank error occurs in a stack program when an operation with rank (n, m) is executed on a stack with rank k < n. In other words, a rank error indicates a stack underflow."

+-+
(a)
+-+

"Use the following types to represent stack and operation ranks."

> type Rank = Int
> type CmdRank = (Int, Int)

"First, define a function rankC that maps each stack operation to its rank."

> rankC :: Cmd -> CmdRank
> rankC (LD _)  = (0,1)
> rankC ADD     = (2,1)
> rankC MULT    = (2,1)
> rankC DUP     = (0,1)
> rankC INC     = (1,1)
> rankC SWAP    = (2,2)
> rankC (POP k) = (k,0)

"Then define a function rankP that computes the rank of a program. The Maybe data type is used to capture rank errors, that is, a program that contains a rank error should be mapped to Nothing whereas ranks of other programs are wrapped by the Just container."

> -- rankP :: Prog -> Maybe Rank

"Hint: You might need to define an auxiliary function rank :: Prog -> Rank -> Maybe Rank and define rankP using rank."

> -- rank :: Prog -> Rank -> Maybe Rank

+-+
(b)
+-+

"Following the example of the function evalStatTC (defined in the file TypeCheck.hs),define a function semStatTC for evaluating stack programs that first calls the function rankP to check whether the stack program is type correct and evaluates the program only in that case. For performing the actual evaluation, semStatTC calls the function sem."

> -- semStatTC :: 

"Note that the function sem called by semStatTC can be simplified. Its type can be simplified and its definition. What is the new type of the function sem and why can the function definition be simplified to have this type? (You do not have to give the complete new definition of the function.)"

+-----------------+
| Exercise 2      |
| Shape Language  |
+-----------------+

"Recall the shape language defined in the slides on semantics. Here is the abstract syntax of the shape language (see also the file Shape.hs)."

> data Shape = X
>            | TD Shape Shape
>            | LR Shape Shape
>            deriving Show

"We define the type of a shape to be the pair of integers giving the width and height of its bounding box."

> type BBox = (Int, Int)

"A type can be understood as a characterization of values, summarizing a set of values at a higher level, abstracting away from some details and mapping value properties to a coarser description on the type level. In this sense, a bounding box can be considered as a type of shapes. The bounding box classifies shapes into different bounding box types. (The bounding box type information could be used to restrict, for example, the composition of shapes, such as applying TD only to shapes of the same width, although we won’t pursue this idea any further in this exercise.)"

+-+
(a)
+-+

"Define a type checker for the shape language as a Haskell function."

> -- bbox :: Shape -> BBox

+-+
(b)
+-+

"Rectangles are a subset of shapes and thus describe a more restricted set of types. By restricting the application of the TD and LR operations to rectangles only one could ensure that only convex shapes without holes can be constructed. Define a type checker for the shape language that assigns types only to rectangular shapes by defining a Haskell function."

> -- rect :: Shape -> Maybe BBox
