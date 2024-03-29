-- Dummy Solutions to COMP2209 Coursework 1 Exercises
-- Please take these dummy functions and implement them as specified
-- To test this with the supplied test harness, rename to Exercises.hs
-- Submit your code using your tested version of this file
--
-- NOTE THAT NO EXTERNAL MODULES MAY BE USED IN SOLVING THESE EXERCISES AND
-- THAT YOU MAY NOT CHANGE THE FUNCTION SIGNATURES NOR TYPE DEFINITIONS

-- This module statement makes public only the specified functions and types
-- please do not change these lines either


module Exercises (splitSort, longestCommonSubList,
    ModuleResult (ModuleResult), canProgress, DegreeClass (First, UpperSecond,
    LowerSecond, Third), classify, hillClimb, nearestRoot, Instruction (Duplicate,
    Pop, Add, Multiply), executeInstructionSequence, optimalSequence,
    findBusyBeavers, Rectangle (Rectangle), simplifyRectangleList, drawEllipse,
    extractMessage, differentStream, unPairAndApply, isShellTreeSum) where

import Data.Set (Set)
import qualified Data.Set as Set
import Data.Function (on)
import Data.Ord (comparing)
import Data.List
import Data.List.Split
import Control.Monad

-- Exercise 1
-- split a given list into sub-lists
-- each of these must be strictly ascending, descending, or equal

--use recursion depend on the case of what list it is, descending, ascending or equal
splitSort :: [Int] -> [[Int]]
splitSort [] = []
splitSort xs | (length $ head asc) >1 = (head asc):splitSort (snd (splitAt (length $ head asc) xs))
             | (length $ head des) >1 = (head des):splitSort (snd (splitAt (length $ head des) xs))
             | (length $ head eq)  >1 = (head eq ):splitSort (snd (splitAt (length $ head eq ) xs))
             | otherwise = [(head xs)]:(splitSort $ tail xs)
 where
  asc = splitAsc xs
  des = splitDes xs
  eq = splitEQ xs

positions :: Eq a => a -> [a] -> [Int]
positions x xs = [ index | (y, index) <- zip xs [0..], x==y]
  
-- 3 function to seperate 3 case : descending list, ascending list and equalist
splitDes :: [Int] -> [[Int]]
splitDes = foldr f [] 
 where
  f x [] = [[x]]
  f x (y:ys) = if x > head y
      then (x:y):ys
      else [x]:y:ys


splitAsc :: [Int] -> [[Int]]
splitAsc = foldr f [] 
 where
  f x [] = [[x]]
  f x (y:ys) = if x < head y
      then (x:y):ys
      else [x]:y:ys

splitEQ :: [Int] -> [[Int]]
splitEQ = foldr f [] 
 where
  f x [] = [[x]]
  f x (y:ys) = if x == head y
      then (x:y):ys
      else [x]:y:ys


-- Exercise 2
-- longest common sub-list of a finite list of finite list
-- function that get longest common sublist between 2 list
lcs :: Eq a => [a] -> [a] -> [a]
lcs xs ys = snd $ lcs' xs ys

lcs' :: Eq a => [a] -> [a] -> (Int, [a])
lcs' (x:xs) (y:ys)
 | x == y = case lcs' xs ys of
                (len, zs) -> (len + 1, x:zs)
 | otherwise = let r1@(l1, _) = lcs' (x:xs) ys
                   r2@(l2, _) = lcs' xs (y:ys)
               in if l1 >= l2 then r1 else r2
lcs' [] _ = (0, [])
lcs' _ [] = (0, [])

-- method lcs and lcs' is taken from this website http://hackage.haskell.org/package/lcs
-- the idea of the implmentation of this exercises is checking common sublist between every 2 sublist
-- confirm that the list of sublist we get belong to every sublist in the initial list then the output is the longest list that we are processing


helper2 :: Eq a => [[a]] -> [[a]] -> [Bool]
helper2 xs input = [and (map (\x -> (lcs common x) == common) input) | common <- xs]

lsort :: [[a]] -> [[a]]
lsort = sortBy (comparing length)

getEltAt :: Int -> [a] -> a
getEltAt index list = head (snd $ splitAt index list)

helper :: Eq a => [[a]] -> [[a]]
helper xs = [lcs lists1 lists2 | lists1 <- xs, lists2 <- xs, lists1/=lists2]


longestCommonSubList :: Eq a => [[a]] -> [a]
longestCommonSubList [] = []
longestCommonSubList [[]] = []
longestCommonSubList input = getEltAt index common
 where
  common = (lsort (helper input))
  helper xs = lsort [lcs lists1 lists2 | lists1 <- xs, lists2 <- xs, lists1/=lists2]
  lsort = sortBy (comparing length)
  index = head $ positions True (helper2 common input)

-- Exercise 3
-- check whether the given results are sufficient to pass the year
-- and progress using the University of Southampton Calendar regulations
data ModuleResult = ModuleResult { credit :: Float, mark :: Int} deriving Show

isEnoughCredit :: [ModuleResult] -> Bool
isEnoughCredit xs = totalcredit >= 60
 where
  totalcredit = sum [mark x | x <- xs ]

--enoughCredit :: [ModuleResult] -> Bool
--enoughCredit xs = foldr (+) 0

yearPass :: [ModuleResult] -> Bool
yearPass list = and (map (\x -> (mark x >= 40)) list)

yearQualify :: [ModuleResult] -> Bool
yearQualify list = and (map (\x -> (mark x >= 25)) list)

isEnoughCompensate :: Bool -> [ModuleResult] -> Bool
isEnoughCompensate False [] = False
isEnoughCompensate False xs = False
isEnoughCompensate True xs | averageMark xs >= 40 = True
                           | otherwise = False

totalMark ::[ModuleResult] -> Int
totalMark [] = 0
totalMark (x:xs) = mark x + totalMark xs

averageMark :: [ModuleResult] -> Int
averageMark [] = 0
averageMark list = (totalMark list ) `div` (length list)

canProgress :: [ModuleResult] -> Bool
canProgress [] = False
canProgress list | (yearPass list) && (isEnoughCredit list)  == True = True
                 | (yearPass list) == False && and (map (\x -> credit x >=15) failModule) = False 
                 | isEnoughCompensate (yearQualify list) list && (isEnoughCredit list) == True = True
                 | yearQualify list == False = False
                 | otherwise = False
 where
  failModule = (filter (\x -> mark x < 40) list)

-- Exercise 4
-- compute the degree classification associate with 3 or 4 year's worth of results
-- using the regulations given in the University of Southampton Calendar
data DegreeClass = First | UpperSecond | LowerSecond | Third deriving (Eq, Show)
calculateDegree :: [[ModuleResult]] -> Int -> Int
calculateDegree (x:xs) 3 =  ((averageMark $ head xs) + (averageMark $ head $ tail xs )* 2) `div` 3
calculateDegree (x:xs) 4 =  ((averageMark $ head xs) + (averageMark $ head $ tail xs )* 2 + (averageMark $ head $ tail $ tail xs )* 2) `div` 5
 where
  yearThree = averageMark $ head $ tail xs
  yearFour = averageMark $ head $ tail $ tail xs

classify :: [[ModuleResult]] -> DegreeClass
classify ms | averageMark >= 70 = First
            | averageMark >= 60 = UpperSecond
            | averageMark >= 50 = LowerSecond
            | averageMark >= 40 = Third
 where
   averageMark = calculateDegree ms (length ms)


-- Exercise 5
-- search for the local maximum of f nearest x using an
-- approximation margin delta and initial step value s
goldenRatio = (1 + sqrt 5)/2
hillClimb :: (Float -> Float) -> Float -> Float -> Float -> Float
hillClimb f x y tol | (b - a) <= tol = a
                    | (f c) >= (f d) = hillClimb f a d tol
                    | (f c) < (f d) = hillClimb f c b tol
 where
  a = min x y
  b = max x y
  c = a + (b-a)/(goldenRatio+1)
  d = b - (b-a)/(goldenRatio+1)

-- Exercise 6
nearestRoot :: [Float] -> Float -> Float -> Float -> Float
nearestRoot xs x x' eps = hillClimb' f x x' eps
 where
  f = (^2) . (list2Polinomial xs (length xs))

list2Polinomial :: [Float] -> Int -> Float -> Float
list2Polinomial [] _ _ = 0
list2Polinomial (x:xs) n input = result
 where
  result = x*input^( n- (length xs)) + (list2Polinomial xs n input )

invphi = (sqrt(5) - 1) / 2 -- 1/phi
invphi2 = (3 - sqrt(5)) / 2 -- 1/phi^2

gssRecursive :: (Float -> Float) -> Float -> Float -> Float -> Float -> Float -> Float -> Float -> Float -> Float
gssRecursive f x y tol h c d fc fd | h <= tol = a
                                   | fc < fd = gssRecursive f a d tol (h*invphi) (a + invphi2*h) c (f c) fc
                                   | otherwise = gssRecursive f c b tol (h*invphi) d (a + invphi*h) fd (f d)
 where
  a = (min x y)
  b = (max x y)
  h = b-a
  c = a + h*invphi2
  d = a + h*invphi
  fc = f c
  fd = f d
  
hillClimb' :: (Float -> Float) -> Float -> Float -> Float -> Float
hillClimb' f x y tol = gssRecursive f a b tol h c d fc fd
 where
     a = (min x y)
     b = (max x y)
     h = b-a -- b is max, a is min
     c = a + h*invphi2
     d = a + h*invphi
     fc = f c
     fd = f d
  
-- Exercise 7
data Instruction = Add | Subtract | Multiply | Duplicate | Pop deriving (Eq, Show)

executeOperations :: [Int] -> Instruction -> [Int]
executeOperations [] _ = []
executeOperations (x:xs) Pop = xs
executeOperations (x:xs) Add = (x + head xs):(tail xs)
executeOperations (x:xs) Multiply = (x * head xs):(tail xs)
executeOperations (x:xs) Duplicate = x:x:xs

executeInstructionSequence :: [Int] -> [Instruction] -> [Int]
executeInstructionSequence [] ins = []
executeInstructionSequence list [] = list
executeInstructionSequence list (x:xs) = executeInstructionSequence (executeOperations list x) xs


-- Exercise 8
log2 :: Int -> Int
log2 n
    | n < 1     = error "argument of logarithm must be positive"
    | otherwise = go 0 1
      where
        go exponent prod
            | prod < n  = go (exponent + 1) (2*prod)
            | otherwise = exponent

non2 :: Int -> (Int,Int)
non2 n | upperDistance <= lowerDistance = (log2 n , upperDistance )
       | upperDistance > lowerDistance = ((log2 n) - 1, lowerDistance )
 where upperDistance = 2^(log2 n) - n
       lowerDistance = n - 2^((log2 n) - 1)

-- non2 return a tuple of (fst ,snd )
-- where fst is the "closest power of 2 to the variable" and snd is the remainder




optimalSequence :: Int -> [Instruction]
optimalSequence 0 = [Pop]
optimalSequence 1 = []
optimalSequence n = concat [top , mid, bot]
 where
  top = concat $ replicate  (snd $ non2 n) [Duplicate]
  mid = concat $ replicate  (fst $ non2 n) [Duplicate, Multiply]
  bot = concat $ replicate  (snd $ non2 n) [Multiply]
-- Exercise 9

finalUpUntilN :: [Int] -> [Instruction] -> Int
finalUpUntilN listInt listIns | length buffer == 1 = head buffer
                              | otherwise = error("not correct ex 9")
 where
   buffer = executeInstructionSequence listInt listIns


bruteForce9 :: [Int] -> [([Instruction],Int)]
bruteForce9 inputList = [(x,(finalUpUntilN inputList x)) |x <- possibleIns ]
 where
  possibleIns = replicateM (length inputList - 1) [Add, Pop, Multiply]
  --buffer = (finalUpUntilN inputList x)

getHighestFinal :: [([Instruction],Int)] -> Int
getHighestFinal xs = maximum [snd x | x<-xs ]

compareSnd :: Int -> (a,Int) -> Bool
compareSnd max (x,num) = (max == num)

filter9 :: [([Instruction],Int)] -> [[Instruction]]
filter9 xs = map fst (filter (compareSnd max) xs)
 where
  max = getHighestFinal xs

findBusyBeavers :: [Int] -> [[Instruction]]
findBusyBeavers [] = []
findBusyBeavers ns = filter9 (bruteForce9 ns)

-- Exercise 10
data Rectangle = Rectangle (Int, Int) (Int, Int) deriving (Eq, Show)
--TODO: I have include Ord in the definition of Rectangle, need to remove it
data Position = Position (Int, Int) deriving (Eq, Show)

-- isOverlapse :: Rectangle -> Rectangle -> Bool
-- isOverlapse x y =
getX :: Position -> Int
getX (Position(x,y)) = x

getY :: Position -> Int
getY (Position(x,y)) = y


getTopRight :: Rectangle -> (Int, Int)
getTopRight (Rectangle (a,b) (c,d)) = (c,d)

getBottomLeft :: Rectangle -> (Int, Int)
getBottomLeft (Rectangle (a,b) (c,d)) = (a,b)

acceptRectangle :: Rectangle -> Bool
acceptRectangle input = (fst $ getTopRight input) > (fst $ getBottomLeft input) && (snd $ getTopRight input) > (snd $ getBottomLeft input)

isOverlapse :: Rectangle -> Rectangle -> [Rectangle]
isOverlapse a b | (ya1 >= yb1) && (xa2 <= xb2) = [a]
                | (ya1 <= yb1) && (xa2 >= xb2) = [b]
                | otherwise = [a,b]
 where
  xa1 = fst $ getTopRight a
  xb1 = fst $ getTopRight b
  xa2 = fst $ getBottomLeft a
  xb2 = fst $ getBottomLeft b
  ya1 = snd $ getTopRight a
  yb1 = snd $ getTopRight b
  ya2 = snd $ getBottomLeft a
  yb2 = snd $ getBottomLeft b

a = Rectangle (10, 10) (0,0)
b = Rectangle (20, 10) (10,0)
test = isOverlapse a b

c = Rectangle (20, 20) (0,0)
d = Rectangle (20, 20) (10,10)
test2 = isOverlapse c

e = Rectangle (20, 10) (5,0)
f = Rectangle (10, 10) (0,0)
test3 = isCombined e f

isCombined :: Rectangle -> Rectangle -> [Rectangle]
isCombined a b
 | (ya1 == yb1) && (ya2 == yb2) && (xa1 > xb1) = [Rectangle (xa1, ya1) (xb2, yb2)]
 | (ya1 == yb1) && (ya2 == yb2) && (xa1 < xb1) = [Rectangle (xb1, ya1) (xa2, yb2)]
 | (xa1 == xa2) && (xa2 == xb2) && (ya1 > yb1) = [Rectangle (xa1, ya1) (xb2, yb2)]
 | (xa1 == xa2) && (xa2 == xb2) && (ya1 < yb1) = [Rectangle (xb1, yb1) (xa2, ya2)]
 | otherwise = [a,b]
  where
    xa1 = fst $ getTopRight a
    xb1 = fst $ getTopRight b
    xa2 = fst $ getBottomLeft a
    xb2 = fst $ getBottomLeft b
    ya1 = snd $ getTopRight a
    yb1 = snd $ getTopRight b
    ya2 = snd $ getBottomLeft a
    yb2 = snd $ getBottomLeft b

-- testCombined = isCombined a b

getCentre :: Rectangle -> Position
getCentre rectangle = Position (x,y)
 where
  x = ((fst $ getBottomLeft rectangle) + (fst $ getTopRight rectangle)) `div` 2
  y = ((snd $ getBottomLeft rectangle) + (snd $ getTopRight rectangle)) `div` 2

getCentreList :: [Rectangle] -> [Position]
getCentreList (x:xs) = getCentre x : (getCentreList xs)

compareXcentre :: Rectangle -> Rectangle -> Ordering
compareXcentre a b = compare (getX $ getCentre a) (getX $ getCentre b)

compareYcentre :: Rectangle -> Rectangle -> Ordering
compareYcentre a b = compare (getY $ getCentre a) (getY $ getCentre b)

sortedList = sortBy (compareXcentre ) [Rectangle (0,0) (2,2), Rectangle (0,0) (10,10)]

checkCombined :: [Rectangle] -> [Rectangle]
checkCombined list = list2Set $ [ head $ isCombined x y| x<-list, y<-list,x/=y ]
--TODO : checkCombined is incorrect !!!

checkOverlapse :: [Rectangle] -> [Rectangle]
checkOverlapse list = list2Set $ [ head $ isOverlapse x y| x<-list, y<-list,x/=y ]

simplifyRectangleList :: [Rectangle] -> [Rectangle]
-- TODO: do i check overlapse first or combine first ?
simplifyRectangleList list = checkOverlapse $ checkCombined list

list2Set :: Eq a => [a] -> [a]
-- list2Set list = Set.toList $ Set.fromList list
list2Set list = Set.toList $ Set.fromAscList list

-- Exercise 11
-- convert an ellipse into a minimal list of rectangles representing its image
merge :: [a] -> [a] -> [a]
merge xs     []     = xs
merge []     ys     = ys
merge (x:xs) (y:ys) = x : y : merge xs ys

createRectangles :: (Int, Int) -> [Rectangle]
--arguments are a,b from the elipse equation
--the function create multiple smaller rectangle with numbers a,b
createRectangles (0,_) = [Rectangle (0,0) (0,0)]
createRectangles (_,0) = [Rectangle (0,0) (0,0)]
createRectangles (a,b) = merge [Rectangle (-a,-b) (a,b), Rectangle (-a,0) (a,0), Rectangle (0,-b) (0,b) ] ( merge (createRectangles (a-1,b)) (createRectangles (a,b-1)) )

checkOverlapse' :: [Rectangle] -> [Rectangle]
checkOverlapse' list = list2Set $ [ head $ isOverlapse x y| x<-list, y<-list ]


isInEclipse :: Float -> Float -> Float -> Float -> Rectangle -> Bool
isInEclipse x y a b (Rectangle (mx,nx) (px,qx)) | (m-x)^2 / a^2 + (n-x)^2 / b^2 > 1 = False
                                                | (p-x)^2 / a^2 + (q-x)^2 / b^2 > 1 = False
                                                | otherwise = True
 where
  m = fromIntegral mx
  n = fromIntegral nx
  p = fromIntegral px
  q = fromIntegral qx
-- TODO: might have to use isCombined and isOverlapse from ex10

drawEllipse :: Float -> Float -> Float -> Float -> [Rectangle]
drawEllipse x y a b = filter (isInEclipse x y a b) list
 where
  ax = floor a
  bx = floor b
  list = list2Set $ checkOverlapse' $ createRectangles (ax,bx)

-- Exercise 12
-- extract a message hidden using a simple steganography technique

extractMessage :: String -> String
extractMessage s = outputString
 where
  numList = seperateString (filter isEncoded s)
  outputString = [decoded x | x<- numList]

isEncoded :: Char -> Bool
isEncoded '0' = True
isEncoded '1' = True
isEncoded _ = False

seperateString :: String -> [String]
seperateString s = splitPlaces (generateDuplicate2List (length s)) s

--TODO: what does this method do again ?
generateDuplicate2List :: Int -> [Int]
generateDuplicate2List x = 2:generateDuplicate2List (x-1)

decoded :: String -> Char
decoded "00" = 'a'
decoded "01" = 'b'
decoded "10" = 'c'
decoded "11" = 'd'

-- Exercise 13
-- return a stream which is different from all streams of the given stream
-- you may choose to use Cantor's diagonal method

differentStream :: [[Int]] -> [Int]
differentStream ss = [ toBinary (recurseHead (snd x) (fst x) +1 )|x<-buffer]
 where
  buffer = zip [0..] ss

--given a list and an int -> get the int element of the list
recurseHead :: [Int] -> Int -> Int
recurseHead [] _ = error "empty list"
recurseHead ss 0 = head ss
recurseHead ss n = recurseHead (tail ss) (n-1)

toBinary :: Int -> Int
toBinary 1 = 0
toBinary 0 = 1
toBinary s = 1

-- Exercise 14
-- extract both components from a square shell pair and apply the (curried) function

unPairAndApply :: Int -> (Int -> Int -> a) -> a
unPairAndApply n f = f x y
 where
  x = fst $ unPair n
  y = snd $ unPair n

unPair :: Int -> (Int,Int)
unPair z | (z - m^2) < m = (z - m^2, m)
         | otherwise = (m , m^2 + 2*m -z)
 where m = isqrt z

--method to solve the problem of sqrt only taken Float
isqrt :: Int -> Int
isqrt = floor . sqrt . fromIntegral

-- Exercise 15
--seperate tree data to a list of 1 and 0
listOfNode :: Int -> [Int]
listOfNode 0 = [0]
listOfNode n = x:(listOfNode x)
 where
  x = fst $ unPair n

isShellTreeSum :: Int -> Bool
isShellTreeSum n = (sum $ tail $ listOfNode n) == snd (unPair n)
