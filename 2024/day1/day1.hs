import Data.List (sort)
import qualified Data.Map as Map



calculateTotalDist:: [Int] -> [Int] -> Int
calculateTotalDist p1 p2 = sum $ map abs $ zipWith (-) (sort p1) (sort p2)

countDuplicates:: (Ord a) => [a] -> Map.Map a Int
countDuplicates locs = Map.fromListWith (+) [(x,1) | x <- locs]


calculateSimilarityScore:: (Ord k, Num v) => Map.Map k v -> Map.Map k v -> Map.Map k v
calculateSimilarityScore = Map.intersectionWith (*)



parsePairs:: String -> ([Int], [Int])
parsePairs content =
    let rows = lines content
        columns = map words rows
        pair1 = map (read . head) columns
        pair2 = map (read . (!! 1)) columns
    in (pair1, pair2)

main :: IO ()
main = do
    -- let pair1 = [3, 4, 2, 1, 3, 3]
    -- let pair2 = [4, 3, 5, 3, 9, 3]

    content <- readFile "input.txt"
    let (pair1, pair2) = parsePairs content
    print $ calculateTotalDist pair1 pair2
    let dp1 = countDuplicates pair1
    let dp2 = countDuplicates pair2

    let simScores = calculateSimilarityScore dp1 dp2
    let totalScore =  Map.foldrWithKey (\k v acc -> acc + (k * v)) 0 simScores

    print totalScore
