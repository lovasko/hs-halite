{- |
Module      : Halite
Description : Client library for Halite server
Copyright   : (c) 2017 Daniel Lovasko
License     : BSD2

Maintainer  : Daniel Lovasko <daniel.lovasko@gmail.com>
Stability   : stable
Portability : portable
-}

module Halite
( Direction(..) -- *
, Move(..)      -- *
, Board(..)     -- *
, Game(..)      -- *
, readGame      -- Board  -> IO Game
, writeGame     -- [Move] -> IO ()
, startGame     -- String -> IO (Board, Game)
) where

import Control.Monad
import Control.Monad.Loops
import Data.Char


-- | Direction of a move.
data Direction
 = North -- ^ north
 | East  -- ^ east
 | South -- ^ south
 | West  -- ^ west

-- | Purposeful printing of the Direction type.
instance Show Direction where
  show North = "1"
  show East  = "2"
  show South = "3"
  show West  = "4"

-- | Move of a unit located at a field in a direction.
data Move = Move Direction Int Int

-- | Purposeful printing of the Move type.
instance Show Move where
  show (Move dir x y) = unwords [show dir, show x, show y]

-- | Immutable game board settings - player ID, width, height and field
-- productions.
data Board = Board Int Int Int [Int] deriving (Show)

-- | A state of the game defined by field owners and their strenghts.
data Game = Game [Int] [Int] deriving (Show)

-- | Parse an unsigned integer from the standard input.
getInt :: IO Int -- ^ unsigned integer
getInt = fmap read (unfoldWhileM isDigit getChar)

-- | Decode the run-length encoded list of owners.
getOwners :: [Int]    -- ^ accumulator list
          -> Int      -- ^ expected count
          -> IO [Int] -- ^ owners
getOwners xs n
  | length xs == n = return xs
  | otherwise      = do
    ys <- replicate <$> getInt <*> getInt
    getOwners (xs ++ ys) n

-- | Handle the initial communication with the server.
startGame :: String           -- ^ player name
          -> IO (Board, Game) -- ^ board setup & initial game state
startGame name = do
  tag    <- getInt
  width  <- getInt
  height <- getInt
  prods  <- replicateM   (width * height) getInt
  owners <- getOwners [] (width * height)
  strens <- replicateM   (width * height) getInt
  putStrLn name
  return (Board tag width height prods, Game owners strens)

-- | Parse the current state of the board.
readGame :: Board   -- ^ board
         -> IO Game -- ^ new game state
readGame (Board _ w h _) = Game <$> getOwners [] size <*> replicateM size getInt
  where size = w * h

-- | Send a list of moves to the server.
writeGame :: [Move] -- ^ moves
          -> IO ()  -- ^ action
writeGame moves = putStr (unwords (map show moves)) >> putStr " "
