# verify-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind

include nim/datast/unionfind
include nim/utils/base

input:
  (N, Q): int

var
  uf = initUF(N)

for _ in range(Q):
  input:
    (t, a, b): int
  if t == 0:
    uf.union(a, b)
  else:
    echo int(uf.isSame(a, b))
