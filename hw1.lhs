Homework 1
CS 381 Spring 2020
Jackson Golletz and Kendrea Beers

> import Data.List (nub,sort)

> norm :: Ord a => [a] -> [a]
> norm = sort . nub
