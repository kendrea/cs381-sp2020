Homework 1
CS 381 Spring 2020
Jackson Golletz, Kendrea Beers, Lyell Read, Robert Detjens

> import Data.List (nub,sort)

> norm :: Ord a => [a] -> [a]
> norm = sort . nub
