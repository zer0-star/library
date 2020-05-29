# %lib-executor: replace math/mathMod.nim
include nim/math/mathMod
# %lib-executor: end
when not declared(INCLUDE_GUARD_MATH_MODINT_NIM):
  const INCLUDE_GUARD_MATH_MODINT_NIM = 1
  import math, sequtils

  proc extgcd(x, y: SomeInteger): (int, int) =
    if x < y:
      let (a, b) = extgcd(y, x)
      return (b, a)
    if y == 0 or x mod y == 0: return (0, 1)
    let (a, b) = extgcd(y, x mod y)
    return (b, -(x div y) * b + a)

  type ModInt[M: static[int]] = object
    v: int

  template initModInt(val: int): auto =
    when declared(MOD):
      ModInt[MOD](v: val mod MOD)
    else:
      ModInt[1000000007](v: val mod 1000000007)

  proc `$`[M](n: ModInt[M]): string {.inline.} =
    $n.v

  proc inv[M](n: ModInt[M]): ModInt[M] {.inline.} =
    result.v = (extgcd(n.v, M)[0]) mod M

  proc modinv(n: int, m: int): int {.inline.} =
    result = (extgcd(n, m)[0]) mod m

  proc `+`[M](n, m: ModInt[M]): ModInt[M] {.inline.} =
    result.v = (n.v + m.v)
    if result.v >= M: result.v -= M

  proc `+`[M](n: ModInt[M]; m: int): ModInt[M] {.inline.} =
    result.v = (n.v + m) mod M

  proc `*`[M](n, m: ModInt[M]): ModInt[M] {.inline.} =
    result.v = n.v * m.v mod M

  proc `*`[M](n: ModInt[M]; m: int): ModInt[M] {.inline.} =
    result.v = n.v * m mod M

  proc `-`[M](n: ModInt[M]): ModInt[M] {.inline.} =
    result.v = M - n.v

  proc `-`[M](n: ModInt[M]; m: int): ModInt[M] {.inline.} =
    result.v = (n.v - m) mod M

  proc `-`[M](n, m: ModInt[M]): ModInt[M] {.inline.} =
    result.v = (n.v - m.v) mod M

  proc `/`[M](n, m: ModInt[M]): ModInt[M] {.inline.} =
    n * inv(m)

  proc `/`[M](n: ModInt[M]; m: int): ModInt[M] {.inline.} =
    n / initModInt(m)

  proc `+=`[M](n: var ModInt[M]; m: int|ModInt[M]) {.inline.} =
    n = n + m

  proc `-=`[M](n: var ModInt[M]; m: int|ModInt[M]) {.inline.} =
    n = n - m

  proc `*=`[M](n: var ModInt[M]; m: int|ModInt[M]) {.inline.} =
    n = n * m

  proc `/=`[M](n: var ModInt[M]; m: int|ModInt[M]) {.inline.} =
    n = n / m

  proc fac[M](n: ModInt[M]): ModInt[M] =
    result.v = 1
    for i in 2..n.v:
      result.v = result.v * i mod M

  proc perm[M](n, m: ModInt[M]): ModInt[M] =
    result.v = 1
    for i in n.v-m.v+1..n.v:
      result.v = result.v * i mod M

  proc binom[M](n, m: ModInt[M]): ModInt[M] {.inline.} =
    perm(n, m) / (fac(m))

  proc modfac(n: int; M: static[int]): int =
    result = 1
    for i in 2..n:
      result = result * i mod M

  proc modperm(n, m: int; M: static[int]): int =
    result = 1
    for i in n-m+1..n:
      result = result * i mod M

  proc modbinom(n, m: int; M: static[int]): int {.inline.} =
    modperm(n, m, M) / (modfac(m, M))

  proc garner(args: openArray[(int, int)]; modulo = -1): (int, int) =
    result = (1, 0)
    let n = args.len
    var coe, con = newSeq[int](n)
    for c in coe.mitems:
      c = 1
    for i in 0..<n:
      let t = (args[i][1] - con[i]) * modinv(coe[i], args[i][0]) mod args[i][0]
      for k in i+1 ..< n:
        con[k] = (con[k] + coe[k] * t) mod args[k][0]
        coe[k] = coe[k] * args[i][0] mod args[k][0]
      result[1] = result[1] + result[0] * t
      result[0] = result[0] * args[i][0]
      if modulo > 0:
        result[0] = result[0] mod modulo
        result[1] = result[1] mod modulo
    if modulo > 0: result[0] = modulo

  proc garner(args: openArray[(int, seq[int])]; modulo = -1): (int, seq[int]) =
    let P = args[0][1].len
    result = (1, newSeq[int](P))
    let n = args.len
    var
      coe = newSeq[int](n)
      con = newSeqWith(P, newSeq[int](n))
    for c in coe.mitems:
      c = 1
    for i in 0..<n:
      for p in 0..<P:
        let t = (args[i][1][p] - con[i][p]) * modinv(coe[i], args[i][
            0]) mod args[i][0]
        for k in i+1 ..< n:
          con[k][p] = (con[k][p] + coe[k] * t mod args[k][0]) mod args[k][0]
        if modulo > 0:
          result[1][p] = (result[1][p] + result[0] * t mod modulo) mod modulo
        else:
          result[1][p] = (result[1][p] + result[0] * t)
      for k in i+1 ..< n:
        coe[k] = coe[k] * args[i][0] mod args[k][0]
      result[0] = result[0] * args[i][0] mod modulo
      if modulo > 0:
        result[0] = result[0] mod modulo
    if modulo > 0: result[0] = modulo

  proc modpow(n, p, m: int): int =
    var
      p = p
      t = n
    result = 1
    while p > 0:
      if (p and 1) == 1:
        result = result * t mod m
      t = t * t mod m
      p = p shr 1
