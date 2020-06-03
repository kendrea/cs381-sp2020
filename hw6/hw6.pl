
/* +============+ */
/* | Homework 6 | */
/* +============+ */

/* CS 381 Spring 2020 */
/* Jackson Golletz, Lyell Read, Robert Detjens, and Kendrea Beers */

/* +------------+ */
/* | Exercise 1 | */
/* +------------+ */

when(275,10).
when(261,12).
when(381,11).
when(398,12).
when(399,12).

where(275,owen102).
where(261,dear118).
where(381,cov216).
where(398,dear118).
where(399,cov216).

enroll(mary,275).
enroll(john,275).
enroll(mary,261).
enroll(john,381).
enroll(jim,399).

/* Note: C = course, T = time, P = place, S = student */

/* (a) */
schedule(S,P,T) :- enroll(S,C), when(C,T), where(C,P).

/* (b) */
usage(P,T) :- where(C,P), when(C,T).

/* (c) */
conflict(C1,C2) :- when(C1,T), when(C2,T), where(C1,P), where(C2,P), C1 \= C2.

/* (d) */
meet(S1,S2) :- enroll(S1,C), enroll(S2,C), S1 \= S2;
               enroll(S1,C1), enroll(S2,C2), when(C1,T1), when(C2,T2), succ(T1,T2), S1 \= S2.

/* +------------+ */
/* | Exercise 2 | */
/* +------------+ */

/* (2a) */

/* rdup(L,M) { M = L.uniq } */
rdup([],[]).
rdup([I|L],M) :- \+member(I,M), append(I,M,N), rdup(L,N).
rdup([I|L],M) :- member(I,M), rdup(L,M).

/* (2b) */

/* flat(L,F) { F = L.flatten } */
flat([],[]).

/* (2c) */

/* project(I,L,R) { R = L[I.foreach] } */
project([],_,[]).


