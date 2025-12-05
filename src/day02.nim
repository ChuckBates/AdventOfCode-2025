import std/[strutils, os]
import aoc

const day = 2

proc parseI64(s0: string): int64 =
  var s = s0.strip()
  if s.len == 0: raise newException(ValueError, "empty integer")
  var i = 0
  var neg = false
  if s[0] == '-':
    neg = true
    i = 1
  var acc: int64 = 0
  while i < s.len:
    let c = s[i]
    if c < '0' or c > '9':
      raise newException(ValueError, "bad digit in: " & s0)
    acc = acc * 10 + (ord(c) - ord('0')).int64
    inc i
  if neg: -acc else: acc

proc isInvalid(num: int64): bool = 
    let number = $num
    if (number.len and 1) == 1:
        return false
    let m = number.len div 2
    result = number[0..<m] == number[m..<2*m] 

proc isRepeated(digits: string): bool =
    let length = digits.len
    for digit in 1..(length div 2):
        if (length mod digit) != 0: continue
        let repeatCount = length div digit
        if repeatCount < 2: continue
        var ok = true
        for index in 0..<length:
            if digits[index] != digits[index mod digit]:
                ok = false
                break
        if ok: return true
    false

proc part1*(input: seq[string]): string =
    var total: int64 = 0
    for line in input:
        let parts = line.split('-')
        let first = parseI64(parts[0])
        let last = parseI64(parts[1])
        for num in first..last:
            if isInvalid(num):
                total += num
    result = $total

proc part2*(input: seq[string]): string =
    var total: int64 = 0
    for line in input:
        let parts = line.split('-')
        let first = parseI64(parts[0])
        let last = parseI64(parts[1])
        for num in first..last:
            if isRepeated($num):
                total += num
    result = $total


when isMainModule:
    let input = readSingleLineInput(day, ',')
    echo "Part 1: ", part1(input)
    echo "Part 2: ", part2(input)
