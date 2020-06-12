# Homework 5

CS 381 Spring 2020
Kendrea Beers, Robert Detjens, Jackson Golletz, Lyell Read, Zach Rogers

## Exercise 1: Runtime Stack

Consider the following block. Assume static scoping and call-by-value parameter passing.

```
	{
1		int x;
2		int y;
3		y := 1;
		{
4			int f(int x) {
5				if x=0 then {
6					y := 1
7				} else {
8					y := f(x-1)*y+1
				};
9			return y;
10			};
11		x := f(2);
12		};
13	}
```

Illustrate the computations that take place during the evaluation of this block, that is, draw a sequence of pictures each showing the complete runtime stack with all activation records after each statement or function call.

Static, CBValue

```
1  [x:?]
2  [y:?  x:?]
3  [y:1  x:?]
4  [f:{} y:1  x:?]
11 >>
    4 [x:2 f:{} y:1 x:?]
    8 >>
        4 [x:1 x:2 f:{} y:1 x:?]
        8 >>
            4 [x:0 x:1 x:2 f:{} y:1 x:?]
            6 [x:0 x:1 x:2 f:{} y:1 x:?]
            9 [ret:1 x:0 x:1 x:2 f:{} y:1 x:?]
          <<
        8 [x:1 x:2 f:{} y:2 x:?]
        9 [ret:2 x:1 x:2 f:{} y:2 x:?]
      <<
    8 [x:2 f:{} y:5 x:?]
    9 [ret:5 x:2 f:{} y:5 x:?]
   <<
11 [f:{} y:5 x:5]
12 [y:5, x:5]
13 []
```

**Note**: Corrections made 6/11/2020: Arithmetic error gave us result of y:6, x:6 as opposed to correct y:5, x:5. Also extended trace to end.

**Note:** Do not use the alternative model of “temporary stack evaluation” that was briefly illustrated on slides 20 and 25 to explain the implementation given in FunStatScope.hs and FunRec.hs. Rather use one stack onto which a new activation record is pushed on each recursive function call.

## Exercise 2: Static and Dynamic Scope

Consider the following block. Assume call-by-value parameter passing.

```
{
	int x;
	int y;
	int z;
	x := 3;
	y := 7;
	{
		int f(int y) {
			return x*y
		};
		int y;
		y := 11;
		{
			int g(int x) {
				return f(y)
			};
			{
				int y;
				y := 13;
				z := g(2);
			};
		};
	};
}
```

(a) Which value will be assigned to z in line 12 under static scoping?

[y:11 x:2 z:? y:13 g:{} y:11 f:{} z:? y:7 x:3]

```
z := 33
```


(b) Which value will be assigned to z in line 12 under dynamic scoping?

[y:13 x:2 z: y:13 g:{} y:11 f:{} z:? y:7 x:3]

```
z := 26
```

**Note:** It might be instructive to draw the runtime stack for different times of the execution, but it is not strictly required.

## Exercise 3: Parameter Passing

Consider the following block. Assume dynamic scoping.

```
{
1	int y;
2	int z;
3	y := 7;
4	{
5		int f(int a) {
6			y := a+1;
7			return (y+a)
8		};
9		int g(int x) {
10			y := f(x+1)+1;
11			z := f(x-y+3);
12			return (z+1)
13		}
14		z := g(y*2);
	};
}
```

What are the values of y and z at the end of the above block under the assumption that both parameters a and x are passed:

(a) Call-by-Name

```
1  [y:?]
2  [z:? y:?]
3  [z:? y:7]
5  [f:{} z:? y:7]
9  [g:{} f:{} z:? y:7]
14 >> g()
    9  [x:(y*2) g:{} f:{} z:? y:7]
    10 >> f()
        5 [a:(y*2+1) x:(y*2) g:{} f:{} z:? y:7]
        6 [a:(y*2+1) x:(y*2) g:{} f:{} z:? y:16]
        7 [ret:49 a:(y*2+1) x:(y*2) g:{} f:{} z:? y:16]
       <<
    10 [x:(y*2) g:{} f:{} z:? y:50]
    11 >> f()
        5 [a:(x-y+3) x:(y*2) g:{} f:{} z:? y:50]
        6 [a:(x-y+3) x:(y*2) g:{} f:{} z:? y:54]
        7 [ret:111 a:(x-y+3) x:(y*2) g:{} f:{} z:? y:54]
       <<
    11 [x:(y*2) g:{} f:{} z:111 y:54]
    12 [ret:112 x:(y*2) g:{} f:{} z:111 y:54]
   <<
14 [g:{} f:{} z:112 y:54]

y := 112
z := 54
```

(b) Call-by-Need

```
1  [y:?]
2  [z:? y:?]
3  [z:? y:7]
5  [f:{} z:? y:7]
9  [g:{} f:{} z:? y:7]
14 >> g()
    9  [x:(y*2) g:{} f:{} z:? y:7]
    10 [x:15 g:{} f:{} z:? y:7]
    10 >> f()
        5 [a:(x+1) x:15 g:{} f:{} z:? y:7]
        6 [a:16 x:15 g:{} f:{} z:? y:17]
        7 [ret:33 a:16 x:15 g:{} f:{} z:? y:17]
       <<
    10 [x:15 g:{} f:{} z:? y:34]
    11 >> f()
        5 [a:(x-y+3) x:15 g:{} f:{} z:? y:34]
        6 [a:-16 x:15 g:{} f:{} z:? y:-15]
        7 [ret:-31 a:-16 x:15 g:{} f:{} z:? y:-15]
       <<
    11 [x:15 g:{} f:{} z:-31 y:-15]
    12 [ret:-30 x:15 g:{} f:{} z:-31 y:-15]
   <<
14 [g:{} f:{} z:-30 y:-15]

y := -15
z := -30
```

Correct Answer (from key):

```
14  [g={}, f={}, z=?, y=7] 
15  >>
    10  [x=y*2, g={}, f={}, z=?, y=7] 
    11  >>
        4  [a=x+1, x=y*2, g={}, f={}, z=?, y=7] 
        5  [a=15, x=14, g={}, f={}, z=?, y=16]
             { x=14, a=15  ==>  y:=a+1=16  }
        8  [res=31, a=15, x=14, g={}, f={}, z=?, y=16] 
             { y=16, a=15   ==>  res=y+a=16+15=31 }
        <<
    11  [x=14, g={}, f={}, z=?, y=32]
    12  >>
        4  [a=x-y+3, x=14, g={}, f={}, z=?, y=32] 
        5  [a=-15, x=14, g={}, f={}, z=?, y=31]
             { x=14, a=-15  ==>  y:=a+1=-14  }
        8  [res=-29, a=-15, x=14, g={}, f={}, z=?, y=-14] 
             { y=-14, a=-15   ==>  res=y+a=-14+-15=-29 }
        <<
    12  [x=14, g={}, f={}, z=-29, y=-14]
    13  [res=-28, x=14, g={}, f={}, z=-29, y=-14] 
    <<
15  [g={}, f={}, z=-28, y=-14]
```

**Note:** It might be instructive to draw the runtime stack for different times of the execution, but it is not strictly required.
