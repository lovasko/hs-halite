# hs-halite
Would you like to create a killer Halite client? Do you find that monad is just
a monoid in the category of endofunctors? Great! That means the `hs-halite`
module is just for you!

## API
### Types
As you probably know, there are four possible `Direction`s to choose when
moving. Each `Move` is defined by the field that we are moving from (`Int` and
`Int` for width and height respectively) and the `Direction`.

Overarching setup of the game `Board` contains your own numerical ID, size of
the board (both horizontally and vertically) and list of productions for each
field. A state of the `Game` contains the current field owners and their
strengths.

```haskell
data Direction = North | East | South | West
data Move      = Move Direction Int Int
data Board     = Board Int Int Int [Int]
data Game      = Game [Int] [Int]
```

### Functions
First thing you will need to do is to `startGame`. It takes one parameter,
which is your username. In order to stay informed before each move, call the
`readGame` function. Once you found the most fearsome move, run `writeGame` to
execute it!

```haskell
startGame :: String -> IO (Board, Game)
readGame  :: Board  -> IO Game
writeGame :: [Move] -> IO ()
```

## License
The `hs-halite` package is licensed under the terms of the [2-clause BSD
license](LICENSE). In case you need any other license, feel free to
contact the author.

## Author
Daniel Lovasko <daniel.lovasko@gmail.com>
