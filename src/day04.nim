import std/[strutils, os, seqUtils]
import aoc

const day = 4

type Matrix = seq[seq[char]]

proc buildMatrix(input: seq[string]): Matrix = 
    result = newSeq[seq[char]](input.len)
    for rowIndex, row in input:
        result[rowIndex] = row.toSeq

proc getNeighbors(matrix: Matrix, x: int, y: int): seq[char] = 
    var neighbors: seq[char]
    let rows = matrix.len
    let column = matrix[0].len
    if (x > 0): 
        if (y > 0):
            neighbors.add(matrix[x-1][y-1]) #top-left
        neighbors.add(matrix[x-1][y])   #top-middle
        if (y < column-1):
            neighbors.add(matrix[x-1][y+1]) #top-right
    if (y > 0):
        neighbors.add(matrix[x][y-1])   #left
    if (y < column-1):
        neighbors.add(matrix[x][y+1])   #right
    if (x < rows-1):
        if (y > 0):
            neighbors.add(matrix[x+1][y-1]) #bottom-left
        neighbors.add(matrix[x+1][y]) #bottom-middle
        if (y < column-1):
            neighbors.add(matrix[x+1][y+1]) #bottom-right
    result = neighbors

proc isRollAccessible(matrix: Matrix, rowIndex: int, columnIndex: int): bool = 
    if matrix[rowIndex][columnIndex] != '@':
        return false

    let neighbors = getNeighbors(matrix, rowIndex, columnIndex)
    let neighborRolls = count(neighbors, '@')
    result = neighborRolls < 4

proc part1*(input: seq[string]): string =
    let matrix = buildMatrix(input)
    var totalRolls = 0
    for rowIndex in 0..< matrix.len:
        for columnIndex in 0..< matrix[0].len:
            if (isRollAccessible(matrix, rowIndex, columnIndex)):
                totalRolls += 1

    result = $totalRolls

proc moveRolls(matrix: Matrix, rollsToMove: seq[seq[int]]): Matrix = 
    var updatedMatrix = matrix
    for roll in rollsToMove: 
        updatedMatrix[roll[0]][roll[1]] = '.'
    result = updatedMatrix

proc cycle(matrix: Matrix): (Matrix, int) = 
    var updatedMatrix = matrix
    var rollsToMove: seq[seq[int]]
    for rowIndex in 0..< updatedMatrix.len:
        for columnIndex in 0..< updatedMatrix[0].len:
            if (isRollAccessible(updatedMatrix, rowIndex, columnIndex)):
                rollsToMove.add(@[rowIndex, columnIndex])
    return (moveRolls(updatedMatrix, rollsToMove), rollsToMove.len)

proc part2*(input: seq[string]): string =
    var matrix = buildMatrix(input)
    var totalRolls = 0

    while true:
        var rollsMoved: int
        (matrix, rollsMoved) = cycle(matrix)
        totalRolls += rollsMoved
        if (rollsMoved == 0):
            break

    result = $totalRolls

when isMainModule:
    let input = readMultiLineInput(day, false)
    echo "Part 1: ", part1(input)
    echo "Part 2: ", part2(input)