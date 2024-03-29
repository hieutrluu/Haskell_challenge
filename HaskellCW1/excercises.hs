-- Dummy Solutions to COMP2209 Coursework 1 Exercises
-- Please take these dummy functions and implement them as specified
-- To test this with the supplied test harness, rename to Exercises.hs
-- Submit your code using your tested version of this file
--
-- NOTE THAT NO EXTERNAL MODULES MAY BE USED IN SOLVING THESE EXERCISES AND
-- THAT YOU MAY NOT CHANGE THE FUNCTION SIGNATURES NOR TYPE DEFINITIONS

-- This module statement makes public only the specified functions and types
-- please do not change these lines either
module exercises (splitSort, longestCommonSubList,
    ModuleResult (ModuleResult), canProgress, DegreeClass (First, UpperSecond,
    LowerSecond, Third), classify, hillClimb, nearestRoot, Instruction (Duplicate,
    Pop, Add, Multiply), executeInstructionSequence, optimalSequence,
    findBusyBeavers, Rectangle (Rectangle), simplifyRectangleList, drawEllipse,
    extractMessage, differentStream, unPairAndApply, isShellTreeSum) where


--HELPER function

positions :: Eq a => a -> [a] -> [Int]
positions x xs = [ index | (y, index) <- zip xs [0..], x==y]

-- Exercise 1
-- split a given list into sub-lists
-- each of these must be strictly ascending, descending, or equal
orderList :: Ord a => [(a,a)] -> [Ordering]
orderList a = [ compare x y | (x,y) <- a  ]

helperFunc :: [(Ordering,Ordering)] -> [Bool]
helperFunc a = [ (x == y) | (x,y) <- a]

{--
splitSort :: Ord a => [a] -> [[a]]
splitSort ns = splitPlaces (positions False (list2 list(ns))) ns
    where list ns = positions False (helperFunc (orderList ns),
          list2 ns = [ x+1 | x <- ns]

-- NEED to fix the syntax of where
--}








-- Exercise 2
-- longest common sub-list of a finite list of finite list

longestCommonSubList :: Eq a => [[a]] -> [a]
longestCommonSubList xs = []


-- Exercise 3
-- check whether the given results are sufficient to pass the year
-- and progress using the University of Southampton Calendar regulations
data ModuleResult = ModuleResult { credit :: Float, mark :: Int} deriving Show
canProgress :: [ModuleResult] -> Bool
canProgress ms = False

checkModule :: ModuleResult -> Bool
checkModule [] = False
checkModule x |

-- Exercise 4
-- compute the degree classification associate with 3 or 4 year's worth of results
-- using the regulations given in the University of Southampton Calendar
data DegreeClass = First | UpperSecond | LowerSecond | Third deriving (Eq, Show)
classify :: [[ModuleResult]] -> DegreeClass
classify ms = Third

-- Exercise 5
-- search for the local maximum of f nearest x using an
-- approximation margin delta and initial step value s
hillClimb :: (Float -> Float) -> Float -> Float -> Float -> Float
hillClimb d x x' eps = 0.0

-- Exercise 6
nearestRoot :: [Float] -> Float -> Float -> Float -> Float
nearestRoot xs x x' eps = 0.0

-- Exercise 7
data Instruction = Add | Subtract | Multiply | Duplicate | Pop deriving (Eq, Show)
executeInstructionSequence :: [Int] -> [Instruction] -> [Int]
executeInstructionSequence ns ins = []

-- Exercise 8
optimalSequence :: Int -> [Instruction]
optimalSequence n = []

-- Exercise 9
findBusyBeavers :: [Int] -> [[Instruction]]
findBusyBeavers ns = []

-- Exercise 10
data Rectangle = Rectangle (Int, Int) (Int, Int) deriving (Eq, Show)
simplifyRectangleList :: [Rectangle] -> [Rectangle]
simplifyRectangleList rs = []

-- Exercise 11
-- convert an ellipse into a minimal list of rectangles representing its image
drawEllipse :: Float -> Float -> Float -> Float -> [Rectangle]
drawEllipse x y a b = []

-- Exercise 12
-- extract a message hidden using a simple steganography technique
extractMessage :: String -> String
extractMessage s = ""

-- Exercise 13
-- return a stream which is different from all streams of the given stream
-- use Cantor's diagonal method
-- the first element of the result is 1 more than the first element of the first stream
-- the second element of the result is 1 more than the second element of the first and second streams
-- and so on
differentStream :: [[Int]] -> [Int]
differentStream ss = []

-- Exercise 14
-- extract both components from a square shell pair and apply the (curried) function
unPairAndApply :: Int -> (Int -> Int -> a) -> a
unPairAndApply n f = f 0 0

-- Exercise 15
isShellTreeSum :: Int -> Bool
isShellTreeSum n = False
