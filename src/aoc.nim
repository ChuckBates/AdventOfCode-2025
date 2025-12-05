# src/aoc.nim
import std/[strutils, strformat]

when defined(js):
    import std/jsffi

    let fs = require("fs")

    proc existsJs(fs: JsObject; path: cstring): bool {.importjs: "#.existsSync(#)".}
    proc readFileJs(fs: JsObject; path: cstring; enc: cstring): cstring {.importjs: "#.readFileSync(#, #)".}

    proc readTextFile(path: string): string =
        if not existsJs(fs, path.cstring):
            quit(fmt"Input file not found: {path}", 1)
        result = $readFileJs(fs, path.cstring, "utf8")
else:
    import std/os

    proc readTextFile(path: string): string = 
        if not fileExists(path):
            quit(fmt"Input file not found: {path}", 1)
        result = readFile(path)

proc splitLineBySeparator*(input: string; separator: char): seq[string] =
    var sequence = newSeq[string](0)
    for part in split(input, {separator}):
        sequence.add(part)
    result = sequence

proc readMultiLineInput*(day: int; test = false): seq[string] =
    let suffix = if test: "_test" else: ""
    let path = fmt"inputs/day{day:02}{suffix}.txt"
    let input = readTextFile(path)
    result = splitLines(input)

proc readSingleLineInput*(day: int; separator = ','; test = false): seq[string] =
    let suffix = if test: "_test" else: ""
    let path = fmt"inputs/day{day:02}{suffix}.txt"
    let input = readTextFile(path)
    result = splitLineBySeparator(input, separator)

proc ints*(input: string): seq[int] =
  result = @[]
  for line in input.splitLines():
    let t = line.strip()
    if t.len == 0: continue
    result.add parseInt(t)
