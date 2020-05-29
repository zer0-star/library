# verify-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum

include nim/segt/segt
include nim/utils/base

input:
  (N, Q): int
  a: seq[int]

var
  segt = initSegT(
    a,
    (x, y) => x + y,
    0
  )

for _ in range(Q):
  input:
    (t, a, b): int
  if t == 0:
    segt.update(a, segt.get(a) + b)
  else:
    echo segt.query(a, b)
