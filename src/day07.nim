import std/[strutils, os, seqUtils]
import aoc

const day = 7

proc propagateBeamLocations(grid: seq[seq[char]]): int = 
    var newGrid = grid.mapIt(it.toSeq)
    var previousRow: seq[char] = @[]
    var splits: int = 0
    var paths: seq[seq[int]] = @[]
    for rowIndex, row in newGrid:
        for columnIndex, colum in row:
            if previousRow.len > 0 and previousRow[columnIndex] == 'S':
                newGrid[rowIndex][columnIndex] = '|'
                continue
            if row[columnIndex] == '^' and previousRow[columnIndex] == '|':
                newGrid[rowIndex][columnIndex - 1] = '|'
                newGrid[rowIndex][columnIndex + 1] = '|'
                splits += 1
                continue
            if previousRow.len > 0 and previousRow[columnIndex] == '|':
                newGrid[rowIndex][columnIndex] = '|'
        previousRow = newGrid[rowIndex]
    result = splits

proc propagatePaths(grid: seq[seq[char]]): int = 
    var paths = newSeqWith(grid.len, newSeq[int](grid[0].len))
    for rowIndex in 0..<grid.len:
        for columnIndex in 0..<grid[0].len:
            if grid[rowIndex][columnIndex] == 'S':
                paths[rowIndex+1][columnIndex] += 1
            if grid[rowIndex][columnIndex] == '.' and rowIndex + 1 < grid.len:
                paths[rowIndex+1][columnIndex] += paths[rowIndex][columnIndex]
            if grid[rowIndex][columnIndex] == '^':
                paths[rowIndex+1][columnIndex-1] += paths[rowIndex][columnIndex]
                paths[rowIndex+1][columnIndex+1] += paths[rowIndex][columnIndex]

    var pathCount: int = 0
    for column in paths[grid.len - 1]:
        pathCount += column

    result = pathCount

proc part1*(input: seq[string]): string =
    let grid = input.mapIt(it.toSeq)
    let splits = propagateBeamLocations(grid)
    result = $splits

proc part2*(input: seq[string]): string =
    let grid = input.mapIt(it.toSeq)
    let pathCount = propagatePaths(grid)
    result = $pathCount

when isMainModule:
    let input = readMultiLineInput(day, false)
    echo "Part 1: ", part1(input)
    echo "Part 2: ", part2(input)