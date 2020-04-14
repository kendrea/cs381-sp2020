-- Unit tests
main = do
    print "Nodes"
    print $ nodes g == [1,2,3,4]
    print $ nodes h == [1,2,3,4]
    print $ nodes [(1, 0)]
 
    print "Suc"
    print $ suc 2 g == [3, 4]
    print $ suc 2 h == [1]
 
    print "Detach"
    print $ detach 3 g == [(1,2),(2,4)]
    print $ detach 2 h == [(1,3),(4,4)]
 
    print "Cyc"
    print $ cyc 4 == [(4,1),(1,2),(2,3),(3,4)]
    print "Insertion:"
    print $ ins 99 test_bag == [(5,1),(7,3),(2,1),(3,2),(8,1),(99,1)]
    print $ ins 3 test_bag == [(5,1),(7,3),(2,1),(3,3),(8,1)]
    print $ (ins 7 $ ins 8 test_bag) == [(5,1),(7,4),(2,1),(3,2),(8,2)]
 
    print "Deletion:"
    print $ del 99 test_bag == test_bag
    print $ del 3 test_bag == [(5,1),(7,3),(2,1),(3,1),(8,1)]
    print $ del 2 test_bag == [(5,1),(7,3),(3,2),(8,1)]
 
    print "Creation:"
    print $ bag [2,3,3,5,7,7,7,8] == [(8,1),(7,3),(5,1),(3,2),(2,1)]
    print $ bag [7,3,8,7,3,2,7,5] == [(5,1),(7,3),(2,1),(3,2),(8,1)]
 
    print "Check:"
    print $ checkbag (5,3) test_bag == False
    print $ checkbag (3,1) test_bag == True
    print $ checkbag (99,1) test_bag == False
 
    print "Sub:"
    print $ subbag [(5,1),(7,5),(2,1),(3,2),(8,1)] test_bag == False
    print $ subbag [(5,1),(7,1),(2,1),(3,1),(8,1)] test_bag == True
    print $ subbag [(5,1),(7,3),(2,1),(8,1)] test_bag == True
    print $ subbag test_bag [(5,1),(7,3),(2,1),(8,1)] == False
    print $ subbag test_bag test_bag == True
 
    print "IsBag"
    print $ isbag [(5,2),(7,3),(2,1),(8,1)] [(5,1),(99,1)] == [(5,1)]
    print $ isbag [(1, 1)] [] == []
    print $ isbag [] [(1, 1)] == []
 
    print "Size"
    print $ size [] == 0
    print $ size [(1, 1)] == 1
    print $ size [(1, 8)] == 8
    print $ size [(1, 3),(2,7)] == 10
    print $ size test_bag == 8
 
    print "Width"
    print $ map width f == [0,6,7]
 
    print "BBox"
    print $ map bbox f == [((4,4),(4,4)),((2,2),(8,8)),((3,3),(10,5))]
 
    print "MinX"
    print $ map minX f == [4,2,3]
 
    print "Move"
    print $ map (\l -> move l (1, -2)) f -- == [Pt (5,2), Circle (6,3) 3, Rect (4,1) 7 2]
 
    print "AlignLeft"
    print $ map minX (alignLeft f) == [0, 0, 0]
 
    print "Inside"
    print $ inside (Pt (1, 1)) (Pt (1, 1)) == True
    print $ inside (Pt (1, 2)) (Pt (1, 1)) == False
    print $ inside (Pt (1, 2)) (Rect (1, 1) 5 6) == True
    print $ inside (Rect (1, 1) 5 6) (Pt (1, 2)) == False
    print $ inside (Circle (1, 1) 1) (Circle (0, 0) 6) == True
    print $ inside (Circle (1, 1) 6) (Circle (0, 0) 1) == False
    print $ inside (Circle (1, 1) 6) (Circle (1, 1) 6) == True
    print $ inside (Rect (1, 1) 3 4) (Rect (0, 0) 5 6) == True
    print $ inside (Circle (1, 1) 4) (Rect (0, 0) 2 2) == False
    print $ inside (Circle (1, 1) 1) (Rect (0, 0) 2 2) == True
    print $ inside (Rect (0, 0) 1 1) (Circle (0, 0) 8) == True
    print $ inside (Rect (0, 0) 1 1) (Circle (0, 0) 1) == False