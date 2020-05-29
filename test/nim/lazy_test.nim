# verify-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_range_sum

include "nim/segt/lazy"

include "nim/utils/base"

include "nim/math/modint"

const MOD = 998244353

type
  mi = ModInt[MOD]

input:
  (N, Q): int
  a: seq[int, (it.initModInt, 1.initModInt)]

var
  segt = initLazySegT[(mi, mi), (mi, mi)](
    a,
    (((mi, mi), (mi, mi)) -> (mi, mi)) => (i0[0] + i1[0], i0[1] + i1[1]),
    (((mi, mi), (mi, mi)) -> (mi, mi)) => (i1[0] * i0[0] + i1[1] * i0[1], i0[1]),
    (((mi, mi), (mi, mi)) -> (mi, mi)) => (i0[0] * i1[0], i0[1] * i1[0] + i1[1]),
    (initModInt(0), initModInt(1)),
    (initModInt(1), initModInt(0))
  )

for _ in range(Q):
  let
    tmp = stdin.readLine.split.map(parseInt)
  if tmp[0] == 0:
    segt.updateRange(tmp[1], tmp[2], (initModInt(tmp[3]), initModInt(tmp[4])))
  else:
    echo segt.fold(tmp[1], tmp[2])[0]
