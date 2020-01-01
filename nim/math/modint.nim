# %lib-executor: replace math/mathMod.nim
include mathMod
# %lib-executor: end
when not declared(INCLUDE_GUARD_MATH_MODINT_NIM):
  const INCLUDE_GUARD_MATH_MODINT_NIM = 1
  import math

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

  proc `$`[M](n: ModInt[M]): string =
    $n.v

  proc inv[M](n: ModInt[M]): ModInt[M] =
    result.v = (extgcd(n.v, M)[0]) mod M

  proc inv(n: int, M: static[int]): ModInt[M] =
    result.v = (extgcd(n, M)[0]) mod M

  proc `+`[M](n, m: ModInt[M]): ModInt[M] =
    result.v = (n.v + m.v) mod M

  proc `+`[M](n: ModInt[M]; m: int): ModInt[M] =
    result.v = (n.v + m)

  proc `*`[M](n, m: ModInt[M]): ModInt[M] =
    result.v = n.v * m.v mod M

  proc `*`[M](n: ModInt[M]; m: int): ModInt[M] =
    result.v = n.v * m mod M

  proc `-`[M](n: ModInt[M]): ModInt[M] =
    result.v = -n.v mod M

  proc `-`[M](n: ModInt[M]; m: int): ModInt[M] =
    result.v = (n.v - m) mod M

  proc `-`[M](n, m: ModInt[M]): ModInt[M] =
    result.v = (n.v - m.v) mod M

  proc `/`[M](n, m: ModInt[M]): ModInt[M] =
    n * inv(m)

  proc `/`[M](n: ModInt[M]; m: int): ModInt[M] =
    n / initModInt(m)

  proc fac[M](n: ModInt[M]): ModInt[M] =
    result.v = 1
    for i in 2..n.v:
      result.v = result.v * i mod M

  proc perm[M](n, m: ModInt[M]): ModInt[M] =
    result.v = 1
    for i in n.v-m.v+1..n.v:
      result.v = result.v * i mod M

  proc binom[M](n, m: ModInt[M]): ModInt[M] =
    perm(n, m) / (fac(m))

  proc modfac(n: int; M: static[int]): ModInt[M] =
    result.v = 1
    for i in 2..n:
      result.v = result.v * i mod M

  proc modperm(n, m: int; M: static[int]): ModInt[M] =
    result.v = 1
    for i in n-m+1..n:
      result.v = result.v * i mod M

  proc modbinom(n, m: int; M: static[int]): ModInt[M] =
    modperm(n, m, M) / (modfac(m, M))
