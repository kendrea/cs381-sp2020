Homework 1
CS 381 Spring 2020
Jackson Golletz, Kendrea Beers, Lyell Read, Robert Detjens

> import Data.List (nub,sort)

> norm :: Ord a => [a] -> [a]
> norm = sort . nub

> type Bag a = [(a,Int)]

Bag: [(x, n), ...]
  x: some element
  n: number of x's in the multiset

(a) Define the function ins that inserts an element into a multiset.

> ins :: Eq a => a -> Bag a -> Bag a
> ins new [] = [(new,1)]
> ins new (b:bs) = if new == fst b 
>                  then (new, snd b + 1):bs 
>                  else b:(ins new bs)


(b) Define the function del that removes an element from a multiset.

> del :: Eq a => a -> Bag a -> Bag a
> del el [] = []
> del el ((b1, 1):bs) = bs
> del el (b:bs) = if el == fst b 
>                  then (el, snd b - 1):bs 
>                  else b:(del el bs)


(c) Define a function bag that takes a list of values and produces a multiset representation.

 > bag :: Eq a => [a] -> Bag a


(d) Define a function subbag that determines whether or not its first argument bag is contained in the second.

 > subbag :: Eq a => Bag a -> Bag a -> Bool


e) Define a function isbag that computes the intersection of two multisets.

 > isbag :: Eq a => Bag a -> Bag a -> Bag a


(f) Define a function size that computes the number of elements contained in a bag.

 > size :: Bag a -> Int
