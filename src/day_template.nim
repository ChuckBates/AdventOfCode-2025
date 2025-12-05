import std/[strutils, os]
import aoc

const day = 3

proc part1*(input: seq[string]): string =
    result = "not implemented"

proc part2*(input: seq[string]): string =
    result = "not implemented"

when isMainModule:
    let input = readMultiLineInput(day, false)
    echo "Part 1: ", part1(input)
    echo "Part 2: ", part2(input)