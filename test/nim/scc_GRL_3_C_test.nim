# verify-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/3/GRL_3_C

include nim/graph/scc

include nim/utils/base

input:
  (V, E): int

var graph = newSeqWith(V, newSeq[int](0))
for i in range(E):
  input:
    (s, t): int
  graph[s].add t

let
  scc = stronglyConnectedComponents(graph)

input:
  Q: int

for i in range(Q):
  input:
    (a, b): int
  echo int(scc[a] == scc[b])
