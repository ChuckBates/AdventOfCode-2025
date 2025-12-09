import std/[strutils, os, seqUtils, algorithm]
import aoc

const day = 8

var parent: seq[int]
var size: seq[int]

proc findRoot(x: int): int =
    if parent[x] != x:
        parent[x] = findRoot(parent[x])
    return parent[x]

proc unionSets(a: int, b: int) =
    var rootA = findRoot(a)
    var rootB = findRoot(b)
    if rootA == rootB:
        return

    if size[rootA] < size[rootB]:
        swap(rootA, rootB)

    parent[rootB] = rootA
    size[rootA] += size[rootB]

proc makeNConnections(n: int, sortedDistances: seq[(int, int, int)]) =
    for i in 0..<n:
        let sortedDistance = sortedDistances[i]
        let sortedDistanceX = sortedDistance[1]
        let sortedDistanceY = sortedDistance[2]
        if findRoot(sortedDistanceX) != findRoot(sortedDistanceY):
            unionSets(sortedDistanceX, sortedDistanceY)


proc getDistances(points: seq[(int, int, int)]): seq[(int, int, int)] =
    var distances: seq[(int, int, int)] = @[]
    for i in 0..<points.len:
        for j in (i + 1)..<points.len:
            let xDistance = points[i][0] - points[j][0]
            let yDistance = points[i][1] - points[j][1]
            let zDistance = points[i][2] - points[j][2]
            distances.add((
                xDistance*xDistance + yDistance*yDistance + zDistance*zDistance,
                i,
                j
            ))

    distances.sort(proc (distance1, distance2: auto): int =
        cmp(distance1[0], distance2[0])
    )

    result = distances

proc convertToPoints(input: seq[string]): seq[(int, int, int)] =
    var points: seq[(int, int, int)] = @[]
    for line in input:
        let parts = line.split(',')
        points.add((parseInt(parts[0]), parseInt(parts[1]), parseInt(parts[2])))

    return points


proc part1*(input: seq[string]): string =
    let points = convertToPoints(input)
    let distances = getDistances(points)
    parent = toSeq(0..<points.len)
    size = newSeqWith(points.len, 1)
    makeNConnections(10, distances) # for test input
    #makeNConnections(1000, distances)

    var circuits: seq[int] = @[]
    for i in 0..<points.len:
        if parent[i] == i:
            circuits.add(size[i])

    circuits.sort(Descending)

    var product = 1
    for i in 0..<3:
        product *= circuits[i]

    return $product

proc part2*(input: seq[string]): string =
    let points = convertToPoints(input)
    let distances = getDistances(points)
    parent = toSeq(0..<points.len)
    size = newSeqWith(points.len, 1)

    var components = points.len
    var lastA = 0
    var lastB = 0

    for distance in distances:
        let a = distance[1]
        let b = distance[2]

        let rootA = findRoot(a)
        let rootB = findRoot(b)

        if rootA != rootB:
            unionSets(a, b)
            dec components
            lastA = a
            lastB = b

            if components == 1:
                break

    result = $(points[lastA][0] * points[lastB][0])

when isMainModule:
    let input = readMultiLineInput(day, false)
    echo "Part 1: ", part1(input)
    echo "Part 2: ", part2(input)