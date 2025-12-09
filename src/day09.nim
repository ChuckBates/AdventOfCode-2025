import std/[strutils, os, algorithm, sets]
import aoc

const day = 9

proc getAreas(points: seq[(int, int)]): seq[(int, (int, int), (int, int))] =
    var areas: seq[(int, (int, int), (int, int))] = @[]
    for i in 0 ..< points.len:
        for j in i + 1 ..< points.len:
            let x1 = points[i][0]
            let x2 = points[j][0]
            let y1 = points[i][1]
            let y2 = points[j][1]
            let area = (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
            areas.add((
                area,
                (points[i][0], points[i][1]),
                (points[j][0], points[j][1]),
            ))

    areas.sort(proc (distance1, distance2: auto): int =
        cmp(distance2[0], distance1[0])
    )

    result = areas

proc convertToPoints(input: seq[string]): seq[(int, int)] =
    var points: seq[(int, int)] = @[]
    for line in input:
        let parts = line.split(',')
        points.add((parseInt(parts[0]), parseInt(parts[1])))

    return points

proc part1*(input: seq[string]): string =
    let points = convertToPoints(input)
    let areas = getAreas(points)
    result = $areas[0][0]

proc edgeCrossesInterior(edge: ((int, int), (int, int)), a, b: (int, int)): bool = 
    let (x1, y1) = edge[0]
    let (x2, y2) = edge[1]

    let minX = min(a[0], b[0])
    let maxX = max(a[0], b[0])
    let minY = min(a[1], b[1])
    let maxY = max(a[1], b[1])

    if x1 == x2:
        if not (minX < x1 and x1 < maxX):
            return false
        let edgeYMin = min(y1, y2)
        let edgeYMax = max(y1, y2)
        let interiorYMin = minY + 1
        let interiorYMax = maxY - 1

        let lo = max(edgeYMin, interiorYMin)
        let hi = min(edgeYMax, interiorYMax)

        return lo <= hi
    else:
        if not (minY < y1 and y1 < maxY):
            return false
        let edgeXMin = min(x1, x2)
        let edgeXMax = max(x1, x2)
        let interiorXMin = minX + 1
        let interiorXMax = maxX - 1

        let lo = max(edgeXMin, interiorXMin)
        let hi = min(edgeXMax, interiorXMax)

        return lo <= hi

proc buildEdges(points: seq[(int, int)]): seq[((int, int), (int, int))] = 
    var edges: seq[((int, int), (int, int))] = @[]
    for i in 0..<points.len:
        let j = (i + 1) mod points.len
        edges.add((points[i], points[j]))
    return edges

proc part2*(input: seq[string]): string =
    let points = convertToPoints(input)
    let areas = getAreas(points)
    let edges = buildEdges(points)
    var largestArea = 0
    for area in areas:
        let point1 = area[1]
        let point2 = area[2]

        if area[0] <= largestArea:
            break

        var crosses = false
        for edge in edges:
            if edgeCrossesInterior(edge, point1, point2):
                crosses = true
                break
        
        if not crosses:
            largestArea = area[0]
            break

    return $largestArea

when isMainModule:
    let input = readMultiLineInput(day, false)
    echo "Part 1: ", part1(input)
    echo "Part 2: ", part2(input)