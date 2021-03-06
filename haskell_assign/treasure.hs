module Main where

import System.Environment
import Data.Monoid
import Data.Array

-- Types

newtype Maze = Maze { unMaze :: Array Int MRow }
type MRow = Array Int Node
data Node = PASS | BLOCK | PATH | NOACCESS | GOAL
            deriving (Eq, Enum)
type Row = Int
type Column = Int
type Point = (Row, Column)

instance Show Node where
  show PASS     = "-"
  show BLOCK    = "#"
  show PATH     = "+"
  show NOACCESS = "!"
  show GOAL     = "@"

toNode :: Char -> Node
toNode '-' = PASS
toNode '#' = BLOCK
toNode '@'   = GOAL
toNode _   = NOACCESS

isOutside :: Maze     
           -> Point
           -> Bool
isOutside m (r, c) = let (rows, cols) = mazeSize m in
                     r < 1 || r > rows || c < 1 || c > cols

isGoal :: Maze -> Point -> Bool
isGoal m p = GOAL == mazeNode m p

isOpen :: Maze -> Point -> Bool
isOpen m p = PASS == mazeNode m p

north, south, east, west :: Point -> Point
north (r, c) = (r-1, c)
south (r, c) = (r+1, c)
east  (r, c) = (r, c+1)
west  (r, c) = (r, c-1)

mazeSize :: Maze -> (Int, Int)
mazeSize (Maze ass) = let (_, rows) = bounds ass
                          (_, cols) = bounds (ass ! 1) in
                      (rows, cols)

mazeNode :: Maze -> Point -> Node
mazeNode m (r, c) = unMaze m ! r ! c


mkMaze :: [[Node]] -> Maze
mkMaze xss = let ln = length xss
                 ix = (1, ln)
                 axss = listArray ix [ listArray (1, length xs) xs | xs <- xss ] in
             Maze axss


findPath :: Maze -> ([Point], [Point])
findPath m = findPath2 m (1,1)

findPath2 :: Maze -> Point -> ([Point], [Point])
findPath2 m p =
  let (result, accessed) = findPath' m p [] in
  case result of
    [] -> ([], accessed)
    _ -> (result, accessed `diffP` result)


diffP :: [Point]         -- ^ All PASS nodes has been visited
         -> [Point]      -- ^ All PATH nodes
         -> [Point]
diffP xss yss = filter ep xss
                where ep p = p `notElem` yss

findPath' :: Maze                   -- ^ The Maze
             -> Point               -- ^ Start point
             -> [Point]             -- ^ Points has been visited
             -> ([Point], [Point])  -- ^ A possible route and all visited nodes
findPath' m p ns
  | isOutside m p = ([], ns)
  | isGoal m p = (p: ns, ns)
  | not (isOpen m p) = ([], ns)
  | p `elem` ns = ([], ns)
  | otherwise = let nss = p : ns in
                findPath' m (north p) nss
                `mappend`
                findPath' m (east p) nss
                `mappend`
                findPath' m (south p) nss
                `mappend`
                findPath' m (west p) nss

-- | Find route in a maze and generate new Maze base on found route.
--   Will error out while no route found.

playMaze :: Maze
            -> Either Maze Maze     -- ^ A Maze has a successful route or not
playMaze m = let (paths, accesses) = findPath m
                 (rows, cols) = mazeSize m
                 nodes = [ [genNode (r, c) paths accesses | c <- [1..cols] ] | r <- [1..rows] ]
                 mz = mkMaze nodes in
             if null paths then Right mz else Left mz
             where genNode p path access
                     | isGoal m p      = GOAL       -- ^ Keep the GOAL position
                     | p `elem` path   = PATH
                     | p `elem` access = NOACCESS
                     | otherwise       = mazeNode m p

printMaze :: Maze -> IO ()
printMaze (Maze axss) = let rows = elems axss
                            rowElems = map (concat . map show . elems) rows in
                        mapM_ putStrLn rowElems

play :: Maze -> IO ()
play m = do
  putStrLn "This is my challenge:\n"
  printMaze m
  rm <- case playMaze m of
    Right r -> putStrLn "\nUh oh, I could not find the treasure :-(\n" >> return r
    Left l ->  putStrLn "\nWoo hoo, I found the treasure :-)\n" >> return l
  printMaze rm

readMaze :: String        -- ^ Map file name
            -> IO Maze
readMaze f = do
  contents <- fmap lines $ readFile f
  return $ mkMaze $ map (map toNode) $ words.filter (/='\r') $ unwords contents

main :: IO ()
main = do
    readMaze "map.txt" >>= play
