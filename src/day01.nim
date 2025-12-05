# src/day01.nim
import std/[strutils, os]
import aoc

const day = 1

proc part1*(input: seq[string]): string =
  var position = 50
  var zeroHits = 0

  for line in input:
    let direction = line[0]
    let count = parseInt(line[1..^1])

    case direction
    of 'L':
        position = (position - count) mod 100
    of 'R':
        position = (position + count) mod 100
    else:
        quit("unexpected direction: " & $direction, 1)

    if position == 0:
        inc zeroHits

  result = $zeroHits

proc clicks(position: int; direction: char; count: int): (int, int) =
  var pos = position
  var hits = 0
  for _ in 1..count:
    if direction == 'R':
      pos = (pos + 1) mod 100
    else:
      pos = (pos - 1) mod 100
    if pos == 0:
      inc hits
  (pos, hits)


proc part2*(input: seq[string]): string =
  var position = 50
  var totalHits = 0

  for line in input:
    let direction = line[0]
    let count = parseInt(line[1..^1])

    let (newPosition, hits) = clicks(position, direction, count)
    position = newPosition
    totalHits += hits

  result = $totalHits

when isMainModule:
    let input = readMultiLineInput(day, false)
    echo "Part 1: ", part1(input)
    echo "Part 2: ", part2(input)
