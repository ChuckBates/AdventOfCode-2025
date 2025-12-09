import std/sequtils

# n items: 0, 1, 2, ..., n-1
let n = 10

# Each item starts as its own parent (its own circuit)
var parent = toSeq(0 ..< n)
var size   = newSeqWith(n, 1)

proc findRoot(x: int): int =
  ## Follow parents until we reach the root.
  if parent[x] != x:
    parent[x] = findRoot(parent[x])  # path compression
  parent[x]

proc unionSets(a, b: int) =
  ## Merge the circuits that contain a and b.
  var rootA = findRoot(a)
  var rootB = findRoot(b)
  if rootA == rootB:
    return            # already in the same circuit

  # attach smaller tree under larger tree
  if size[rootA] < size[rootB]:
    swap(rootA, rootB)

  parent[rootB] = rootA
  size[rootA] += size[rootB]

# ---- tiny demo ----

# connect 0-1 and 1-2  → circuit {0,1,2}
unionSets(0, 1)
unionSets(1, 2)

echo "root of 0 = ", findRoot(0)
echo "root of 2 = ", findRoot(2)
echo "same circuit? ", findRoot(0) == findRoot(2)

# connect 5-6  → circuit {5,6}
unionSets(5, 6)
echo "same circuit (0 and 5)? ", findRoot(0) == findRoot(5)