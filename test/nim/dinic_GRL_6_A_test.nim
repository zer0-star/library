# verify-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/6/GRL_6_A

include nim/flow/dinic

include nim/utils/base

input:
  (V, E): int

var
  dnc = initDinic[int](V)

for _ in range(E):
  input:
    (u, v, c): int
  dnc.addEdge(u, v, c)

echo dnc.calc(0, V-1)
