include nim/math/ntt
include nim/utils/base

import strutils

input:
  (N, M): int
  a: seq[int]; it.initPolynomial
  b: seq[int]; it.initPolynomial

let
  c = nttConvolute_innerProc(a, b, 998244353, 3)

echo c[0..<N+M-1].join(" ")
