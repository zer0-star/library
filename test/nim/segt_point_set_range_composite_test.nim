# verify-helper: PROBLEM https://judge.yosupo.jp/problem/point_set_range_composite

include nim/segt/segt
include nim/utils/base
include nim/math/modint

const MOD = 998244353

input:
  (N, Q): int
  data[N]: (ModInt, ModInt)

var
  segt = initSegT(
    data,
    (x, y) => (x[0] * y[0], x[1] * y[0] + y[1]),
    (initModInt(1), initModInt(0))
  )

for _ in range(Q):
  input:
    (t, a, b, c): int
  if t == 0:
    segt.update(a, (initModInt(b), initModInt(c)))
  else:
    let (x, y) = segt.query(a, b)
    echo x * c + y
