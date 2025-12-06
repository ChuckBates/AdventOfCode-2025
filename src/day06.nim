import std/[strutils, os, seqUtils]
import aoc

const day = 6

proc transpose(grid: seq[seq[string]]): seq[seq[string]] =
    let rows = grid.len
    let columns = grid[0].len

    result = newSeq[seq[string]](columns)
    for column in 0..<columns:
        result[column] = newSeq[string](rows)
        for row in 0..<rows:
            result[column][row] = grid[row][column]

proc operate(values: seq[string], operation: string): int = 
    var total: int = 0
    for value in values:
        if operation == "*":
            if total == 0:
                total = 1
            total = total * parseInt(value)
        else:
            total += parseInt(value)
    result = total

proc part1*(input: seq[string]): string =
    var trimmedInput: seq[seq[string]] = @[]
    for line in input:
        trimmedInput.add(line.splitWhitespace())
    let transposedGrid = transpose(trimmedInput)
    var total = 0
    for row in transposedGrid:
        let operation = row[row.len - 1]
        total += operate(row[0..row.len-2], operation)
    result = $total

proc isColumnEmpty(rows: seq[string], column: int): bool = 
    for row in rows:
        if row[column] != ' ':
            return false
    return true

proc readColumns(rows: seq[string]): seq[seq[string]] =
    var width = 0
    for row in rows:
        if row.len > width:
            width = row.len
    
    var paddedRows = newSeq[string](rows.len)
    for index, row in rows:
        if row.len < width:
            paddedRows[index] = row & repeat(' ', width - row.len)
        else:
            paddedRows[index] = row

    var digitBlocks: seq[seq[string]] = @[]
    var digitBlock: seq[string] = @[]
    for colum in 0..<width:
        var digits = ""
        if isColumnEmpty(paddedRows, colum):
            digitBlocks.add(digitBlock)
            digitBlock = @[]
        for row in 0..<paddedRows.len:
            let character = paddedRows[row][colum]
            if character != ' ':
                digits.add(character)
        if digits.len > 0:
            digitBlock.add(digits)
    digitBlocks.add(digitBlock)
    result = digitBlocks

proc part2*(input: seq[string]): string =
    var mutableInput: seq[string] = input
    let operations = mutableInput.pop().splitWhitespace()
    let digitBlocks = readColumns(mutableInput)
    var total: int = 0
    for index, digitBlock in digitBlocks:
        let operation = operations[index]
        let blockTotal = operate(digitBlock, operation)
        total += blockTotal
    result = $total

when isMainModule:
    let input = readMultiLineInput(day, false)
    echo "Part 1: ", part1(input)
    echo "Part 2: ", part2(input)