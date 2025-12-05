import std/[strutils, os, seqUtils]
import aoc

const day = 3

proc stringToIntSeq*(line: string): seq[int] =
    result = @[]


proc part1*(input: seq[string]): string =
    var outputJoltage = 0
    for line in input:
        let sequenceOfNumbers = line.toSeq.mapIt(parseInt($it))
        let highest = max(sequenceOfNumbers)
        let indexOfHighest = sequenceOfNumbers.find(highest)
        var subStringToCheck = sequenceOfNumbers[indexOfHighest+1..^1]
        if (indexOfHighest == sequenceOfNumbers.len - 1):
            subStringToCheck = sequenceOfNumbers[0..<indexOfHighest]
        var subHighest = 0
        for number in subStringToCheck:
            if number > subHighest:
                subHighest = number
        
        var joltage = $highest & $subHighest
        if (indexOfHighest == sequenceOfNumbers.len - 1):
            joltage = $subHighest & $highest
        outputJoltage += parseInt(joltage)       
            
    result = $outputJoltage

proc getBestTwelve(digits: string): string = 
    let digitsAsInts: seq[int] = digits.toSeq.mapIt(ord(it) - ord('0'))
    var digitsToDrop = digitsAsInts.len - 12
    var chosenDigits: seq[int] = @[]

    for value in digitsAsInts:
        while digitsToDrop > 0 and chosenDigits.len > 0 and chosenDigits[^1] < value:
            discard chosenDigits.pop()
            dec digitsToDrop
        chosenDigits.add(value)
    
    chosenDigits.setLen(12)
    result = newStringOfCap(12)
    for value in chosenDigits:
        result.add(char(value + ord('0')))

proc part2*(input: seq[string]): string =
    var outputJoltage: int64 = 0
    for line in input:
        let bestTwelve = getBestTwelve(line)
        outputJoltage += parseInt(bestTwelve).int64

    result = $outputJoltage

when isMainModule:
    let input = readMultiLineInput(day, false)
    echo "Part 1: ", part1(input)
    echo "Part 2: ", part2(input)