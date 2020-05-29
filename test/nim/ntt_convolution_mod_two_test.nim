# verify-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod

include nim/math/ntt
include nim/utils/base

import strutils

input:
  (N, M): int
  a: seq[int]; it.initPolynomial
  b: seq[int]; it.initPolynomial

let
  c = nttConvolute(a, b, 998244353)

var
  res: seq[int]

for i in range(N + M - 1):
  res.add c[i]

echo res.join(" ")
