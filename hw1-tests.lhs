+==============+
|| Homework 1 ||
+==============+

CS 381 Spring 2020
Kendrea Beers, Robert Detjens, Jackson Golletz, Lyell Read, Zach Rogers

This file contains the same code as hw1.lhs as well as some unit tests that
check our work.



+------------+
| Exercise 1 |
+------------+

> import Data.List (nub,sort)

> norm :: Ord a => [a] -> [a]
> norm = sort . nub

> type Bag a = [(a,Int)]

Bag: [(x, n), ...]
  x: some element
  n: number of x's in the multiset


(a) Define the function ins that inserts an element into a multiset.

    ins :: Eq a => a -> Bag a -> Bag a

    (Note: The class constraint ”Eq a =>” restricts the element type a to those
    types that allow the comparison of elements for equality with ==.)

> ins :: Eq a => a -> Bag a -> Bag a
> ins new [] = [(new,1)]
> ins new (b:bs) | new == fst b = (new, snd b + 1):bs
>                | otherwise = b:(ins new bs)


(b) Define the function del that removes an element from a multiset.

    del :: Eq a => a -> Bag a -> Bag a

> del :: Eq a => a -> Bag a -> Bag a
> del el [] = []
> del el ((b1, 1):bs) | el == b1 = bs
>                     | otherwise = (b1,1):(del el bs)
> del el (b:bs) | el == fst b = (el, snd b - 1):bs
>               | otherwise = b:(del el bs)


(c) Define a function bag that takes a list of values and produces a multiset
    representation.

    bag :: Eq a => [a] -> Bag a

    For example, with xs = [7,3,8,7,3,2,7,5] we get the following result.

    > bag xs
    [(5,1),(7,3),(2,1),(3,2),(8,1)]

    (Note: It’s a good idea to use of the function ins defined earlier.)

> bag :: Eq a => [a] -> Bag a
> bag (a:[]) = ins a []
> bag (a:as) = ins a (bag as)


(d) Define a function subbag that determines whether or not its first argument
    bag is contained in the second.

    subbag :: Eq a => Bag a -> Bag a -> Bool

    Note that a bag b is contained in a bag b′ if every element that occurs n
    times in b occurs also at least n times in b′.

> subbag :: Eq a => Bag a -> Bag a -> Bool
> subbag [] _     = True
> subbag _ []     = False
> subbag (a:as) b = if subbag' a b then subbag as b else False
>
> -- helper function, checks only one element
> subbag' :: Eq a => (a, Int) -> Bag a -> Bool
> subbag' _ []            = False
> subbag' (el, ec) (b:[]) = el == fst b && ec <= snd b
> subbag' e@(el, ec) (b:bs) | el /= fst b = subbag' e bs
>                           | ec <= snd b = True
>                           | otherwise = False


e) Define a function isbag that computes the intersection (common elements) of
   two multisets.

    isbag :: Eq a => Bag a -> Bag a -> Bag a

> isbag :: Eq a => Bag a -> Bag a -> Bag a
> isbag [] _     = []
> isbag _ []     = []
> isbag (a:as) b = isbag' a b ++ isbag as b
>
> -- helper function, checks only one element
> isbag' :: Eq a => (a, Int) -> Bag a -> Bag a
> isbag' _ [] = []
> isbag' e@(el, ec) (b:bs) | el /= fst b = isbag' e bs
>                          | otherwise = [(el, min ec (snd b))]


(f) Define a function size that computes the number of elements in a bag.

    size :: Bag a -> Int

> size :: Bag a -> Int
> size []            = 0
> size ((el, ec):es) = ec + size es



+------------+
| Exercise 2 |
+------------+

> type Node  = Int
> type Edge  = (Node,Node)
> type Graph = [Edge]
> type Path  = [Node]

> g :: Graph
> g = [(1,2),(1,3),(2,3),(2,4),(3,4)]
> h :: Graph
> h = [(1,2),(1,3),(2,1),(3,2),(4,4)]


(a) Define the function nodes :: Graph -> [Node] that computes the list of nodes
    contained in a given graph. For example, nodes g = [1,2,3,4].

List Comprehension:

> nodes :: Graph -> [Node]
> nodes g = norm $ concat [[fst a, snd a] | a <- g]

Recursive with Tuple Access:

> --nodes :: Graph -> [Node]
> --nodes []     = []
> --nodes (x:xs) = norm $ fst x : snd x : nodes xs

Recursive with Segmenting

> --nodes :: Graph -> [Node]
> --nodes []         = []
> --nodes ((a,b):xs) = nub ([a,b] ++ nodes xs)


(b) Define the function suc :: Node -> Graph -> [Node] that computes the list of
    successors for a node in a given graph.
    For example, suc 2 g = [3,4], suc 4 g = [], and suc 4 h = [4].

List Comprehension:

> suc :: Node -> Graph -> [Node]
> suc n g = [y | (x,y) <- g, x == n]

List Comprehension with Tuple Access:

> --suc :: Node -> Graph -> [Node]
> --suc n g = [snd a | a <- g, fst a == n]

Recursive:

> --suc :: Node -> Graph -> [Node]
> --suc _ []     = []
> --suc n (x:xs) = if fst x == n then snd x : suc n xs else suc n xs


(c) Define the function detach :: Node -> Graph -> Graph that removes a node
    together with all of its incident edges from a graph.
    For example, detach 3 g = [(1,2),(2,4)] and detach 2 h = [(1,3),(4,4)].

List Comprehension:

> detach :: Node -> Graph -> Graph
> detach n g = [a | a <- g , fst a /= n, snd a /= n]

Alt. List Comprehension:

> --detach :: Node -> Graph -> Graph
> --detach n g = [(x,y) | (x,y) <- g, not (x == n || y == n)]

Recursive:

> --detach :: Node -> Graph -> Graph
> --detach _ []     = []
> --detach n (x:xs) = if fst x /= n && snd x /= n then x : detach n xs else detach n xs


(d) Define the function cyc :: Int -> Graph that creates a cycle of any given
    number. For example, cyc 4 = [(1,2),(2,3),(3,4),(4,1)].

List Comprehension:

> cyc :: Int -> Graph
> cyc n = [(a, a `mod` n + 1) | a <- [1..n]]

Alt. List Comprehension:

> --cyc :: Int -> Graph
> --cyc 0 = []
> --cyc c = [(x, x+1) | x <- [1 .. c-1]] ++ [(c, 1)]

Iterative:

> --cyc :: Int -> Graph
> --cyc n = zip [1..n] $ [2..n] ++ [1]



+------------+
| Exercise 3 |
+------------+

> type Number   = Int
> type Point    = (Number,Number)
> type Length   = Number
> data Shape    = Pt Point
>   | Circle Point Length
>   | Rect Point Length Length
>   deriving Show
> type Figure   = [Shape]
> type BBox     = (Point,Point)


(a) Define the function width that computes the width of a shape.

    width :: Shape -> Length

    For example, the widths of the shapes in the figure f are as follows.
    > f = [Pt (4,4), Circle (5,5) 3, Rect (3,3) 7 2]
    > map width f
    [0,6,7]

> width :: Shape -> Length
> width (Pt _)       = 0
> width (Circle _ r) = r * 2
> width (Rect _ w _) = w


(b) Define the function bbox that computes the bounding box of a shape.

    bbox :: Shape -> BBox

    The bounding boxes of the shapes in the figure f are as follows.

    > map bbox f
    [((4,4),(4,4)),((2,2),(8,8)),((3,3),(10,5))]

> bbox :: Shape -> BBox
> bbox (Pt p)       = (p, p)
> bbox (Circle p r) = ((fst p - r, snd p - r), (fst p + r, snd p + r))
> bbox (Rect p w h) = (p, (fst p + w, snd p + h))


(c) Define the function minX that computes the minimum x coordinate of a shape.

    minX :: Shape -> Number

    The minimum x coordinates of the shapes in the figure f are as follows.

    > map minX f
    [4,2,3]

> minX :: Shape -> Number
> minX (Pt p)       = fst p
> minX (Circle p r) = fst p - r
> minX (Rect p _ _) = fst p


(d) Define a function move that moves the position of a shape by a vector
    given by a point as its second argument.

    move :: Shape -> Point -> Shape

    It is probably a good idea to define and use an auxiliary function
    addPt :: Point -> Point -> Point, which adds two points component wise.

> addPt :: Point -> Point -> Point
> addPt (ax, ay) (bx, by) = (ax + bx, ay + by)

> move :: Shape -> Point -> Shape
> move (Pt p) d       = Pt (addPt p d)
> move (Circle p r) d = Circle (addPt p d) r
> move (Rect p w h) d = Rect (addPt p d) w h


(e) Define a function alignLeft that transforms one figure into another one in
    which all shapes have the same minX coordinate but are otherwise unchanged.

    alignLeft :: Figure -> Figure

    Note: It might be helpful to define an auxiliary function
    moveToX :: Number -> Shape -> Shape that changes a shape’s position so that
    its minX coordinate is equal to the number given as first argument.

    * Programmer's Note: assuming the end x-coordinate can be whatever as long
      as all shapes are aligned to it, as opposed to aligning all shapes to the
      x-coord of the leftmost shape

> alignLeft :: Figure -> Figure
> alignLeft []     = []
> alignLeft (s:ss) = moveToX 0 s : alignLeft ss
>
> moveToX :: Number -> Shape -> Shape
> moveToX x' (Pt (x,y))       = Pt (x',y)
> moveToX x' (Circle (x,y) r) = Circle (x'+r,y) r
> moveToX x' (Rect (x,y) l w) = Rect (x',y) l w


(f) Define a function inside that checks whether one shape is inside of another
    one, that is, whether the area covered by the first shape is also covered by
    the second shape.

    inside :: Shape -> Shape -> Bool

    Hint: Think about what one shape being inside another means for the bounding
    boxes of both shapes. Note that this remark is meant to help with some
    cases, but it doesn’t solve all.

> -- Helper function for inside
> toRect :: BBox -> Shape
> toRect ((ax, ay), (bx, by)) = (Rect (ax, ay) (bx - ax) (by - ay))

> inside :: Shape -> Shape -> Bool
> -- Rect
> inside (Pt (x, y)) (Rect (rx, ry) w h) = ((x >= rx) && (y >= ry)
>                                        && (x <= rx + w)
>                                        && (y <= ry + h))
> inside a@(Circle _ _) b@(Rect _ _ _) = inside (toRect (bbox a)) b
> inside (Rect a@(x, y) w h) b@(Rect _ _ _) = inside (Pt a) b && inside (Pt (x + w, y + h)) b


> -- Circle
> inside (Rect (x, y) w h) c@(Circle _ _) = inside (Pt (x, y)) c
>                                         && inside (Pt (x + w, y + h)) c
>                                         && inside (Pt (x + w, y)) c && inside (Pt (x, y + h)) c
> inside (Circle (ax, ay) ar) (Circle (bx, by) br) = (((ax - bx)^2) + ((ay - by)^2) <= ((br^2) - (ar^2)))
> inside (Pt a) b@(Circle (_, _) _) = inside (Circle a 0) b

> -- Pt
> inside a b@(Pt _) = inside (toRect (bbox a)) (toRect (bbox b))



+------------+
| Unit Tests |
+------------+

Note: These are not our work or our code, they were sourced from another student
      who shared them during lecture.

> f = [Pt (4,4), Circle (5,5) 3, Rect (3,3) 7 2]

> test_bag = [(5,1),(7,3),(2,1),(3,2),(8,1)]

Unit tests

> main = do
>   print "Nodes"
>   print $ nodes g == [1,2,3,4]
>   print $ nodes h == [1,2,3,4]
>   print $ nodes [(1, 0)]

>   print "Suc"
>   print $ suc 2 g == [3, 4]
>   print $ suc 2 h == [1]

>   print "Detach"
>   print $ detach 3 g == [(1,2),(2,4)]
>   print $ detach 2 h == [(1,3),(4,4)]

>   print "Cyc"
>   print $ cyc 4 == [(4,1),(1,2),(2,3),(3,4)]

>   print "Insertion:"
>   print $ ins 99 test_bag == [(5,1),(7,3),(2,1),(3,2),(8,1),(99,1)]
>   print $ ins 3 test_bag == [(5,1),(7,3),(2,1),(3,3),(8,1)]
>   print $ (ins 7 $ ins 8 test_bag) == [(5,1),(7,4),(2,1),(3,2),(8,2)]

>   print "Deletion:"
>   print $ del 99 test_bag == test_bag
>   print $ del 3 test_bag == [(5,1),(7,3),(2,1),(3,1),(8,1)]
>   print $ del 2 test_bag == [(5,1),(7,3),(3,2),(8,1)]

>   print "Creation:"
>   print $ bag [2,3,3,5,7,7,7,8] == [(8,1),(7,3),(5,1),(3,2),(2,1)]
>   print $ bag [7,3,8,7,3,2,7,5] == [(5,1),(7,3),(2,1),(3,2),(8,1)]

>   print "Sub:"
>   print $ subbag [(5,1),(7,5),(2,1),(3,2),(8,1)] test_bag == False
>   print $ subbag [(5,1),(7,1),(2,1),(3,1),(8,1)] test_bag == True
>   print $ subbag [(5,1),(7,3),(2,1),(8,1)] test_bag == True
>   print $ subbag test_bag [(5,1),(7,3),(2,1),(8,1)] == False
>   print $ subbag test_bag test_bag == True

>   print "IsBag"
>   print $ isbag [(5,2),(7,3),(2,1),(8,1)] [(5,1),(99,1)] == [(5,1)]
>   print $ isbag [(1, 1)] [] == []
>   print $ isbag [] [(1, 1)] == []

>   print "Size"
>   print $ size [] == 0
>   print $ size [(1, 1)] == 1
>   print $ size [(1, 8)] == 8
>   print $ size [(1, 3),(2,7)] == 10
>   print $ size test_bag == 8

>   print "Width"
>   print $ map width f == [0,6,7]

>   print "BBox"
>   print $ map bbox f == [((4,4),(4,4)),((2,2),(8,8)),((3,3),(10,5))]

>   print "MinX"
>   print $ map minX f == [4,2,3]

>   print "Move"
>   print $ map (\l ->  move l (1, -2)) f
>   -- ^ == [Pt (5,2), Circle (6,3) 3, > Rect (4,1) 7 2]

>   print "AlignLeft"
>   print $ map minX (alignLeft f) == [0, 0, 0]

>   print "Inside"
>   print $ inside (Pt (1, 1)) (Pt (1, 1)) == True
>   print $ inside (Pt (1, 2)) (Pt (1, 1)) == False
>   print $ inside (Pt (1, 2)) (Rect (1, 1) 5 6) == True
>   print $ inside (Rect (1, 1) 5 6) (Pt (1, 2)) == False
>   print $ inside (Circle (1, 1) 1) (Circle (0, 0) 6) == True
>   print $ inside (Circle (1, 1) 6) (Circle (0, 0) 1) == False
>   print $ inside (Circle (1, 1) 6) (Circle (1, 1) 6) == True
>   print $ inside (Rect (1, 1) 3 4) (Rect (0, 0) 5 6) == True
>   print $ inside (Circle (1, 1) 4) (Rect (0, 0) 2 2) == False
>   print $ inside (Circle (1, 1) 1) (Rect (0, 0) 2 2) == True
>   print $ inside (Rect (0, 0) 1 1) (Circle (0, 0) 8) == True
>   print $ inside (Rect (0, 0) 1 1) (Circle (0, 0) 1) == False
