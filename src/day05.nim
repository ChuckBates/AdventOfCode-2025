import std/[strutils, sequtils, algorithm]
import aoc

const day = 5

proc part1*(input: seq[string]): string =
    var ingredientRanges: seq[string]
    var ingredientIds: seq[string]
    for line in input:
        if line.len == 0:
            continue
        if line.contains('-'):
            ingredientRanges.add(line)
        else: 
            ingredientIds.add(line)
    
    var parsedIngredientRanges: seq[seq[int]]
    for ingredientRange in ingredientRanges:
        let parts = ingredientRange.split('-')
        parsedIngredientRanges.add(@[parseInt(parts[0]),parseInt(parts[1])])

    var ingredientCount: int = 0
    var freshIngredients: int
    for ingredientId in ingredientIds:
        var ingredientFound: bool = false
        for parsedIngredientRange in parsedIngredientRanges:
            if (parsedIngredientRange[0] <= parseInt(ingredientId)) and (parseInt(ingredientId) <= parsedIngredientRange[1]):
                ingredientFound = true
                break
        if ingredientFound:
            freshIngredients += 1
        ingredientCount += 1
    

    result = $freshIngredients

proc mergeRanges(ranges: seq[tuple[first, last: int]]): seq[tuple[first, last: int]] =
  var sortedRanges = ranges
  sortedRanges.sort(proc(a, b: tuple[first, last: int]): int =
    cmp(a.first, b.first)
  )

  var current = sortedRanges[0]
  result = @[]

  for i in 1 ..< sortedRanges.len:
    let next = sortedRanges[i]

    if next.first <= current.last + 1:
      if next.last > current.last:
        current.last = next.last
    else:
      result.add(current)
      current = next

  result.add(current)

proc part2*(input: seq[string]): string =
  var ranges: seq[tuple[first, last: int]] = @[]

  for line in input:
    if line.len == 0:
      break

    let parts = line.split('-')
    let first = parseInt(parts[0])
    let last = parseInt(parts[1])
    ranges.add((first: first, last: last))

  let mergedRanges = mergeRanges(ranges)

  var possibleFreshIngredients = 0
  for mergedRange in mergedRanges:
    possibleFreshIngredients += mergedRange.last - mergedRange.first + 1

  result = $possibleFreshIngredients

when isMainModule:
    let input = readMultiLineInput(day, false)
    echo "Part 1: ", part1(input)
    echo "Part 2: ", part2(input)