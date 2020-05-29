when not declared(INCLUDE_GUARD_MATH_POLYNOMIAL_NIM):
  const INCLUDE_GUARD_MATH_POLYNOMIAL_NIM = 1
  import sequtils, math

  type
    Polynomial[T] = object
      coeffs: seq[T]

  proc initPolynomial[T](a: seq[T]): Polynomial[T] {.inline.} =
    Polynomial[T](coeffs: a)

  proc initPolynomial[T](n: int): Polynomial[T] {.inline.} =
    Polynomial[T](coeffs: newSeq[T](n))

  proc expand[T](a: var Polynomial[T]; size: int) {.inline.} =
    if a.len < size:
      a.coeffs.setLen(size)

  proc `+`[T](a, b: Polynomial[T]): Polynomial[T] =
    result = a
    result.expand(max(a.coeffs.len, b.coeffs.len))
    for i, t in b:
      result.coeffs[i] += t

  proc `-`[T](a: Polynomial[T]): Polynomial[T] {.inline.} =
    result.coeffs = a.coeffs.mapIt(-it)

  proc `-`[T](a, b: Polynomial[T]): Polynomial[T] {.inline.} =
    a + (-b)

  proc at[T](a: Polynomial[T]; t: int): T {.inline.} =
    a.coeffs[t]

  proc `[]`[T](a: Polynomial[T]; t: int): T {.inline.} =
    a.at(t)

  proc `[]=`[T](a: var Polynomial[T]; t: Natural; c: T) {.inline.} =
    a.coeffs[t] = c

  proc call[T, S](a: Polynomial[T]; x: S): S {.inline.} =
    var t = x
    result = a[0]
    for i in 1 ..< a.len:
      result += t * a[i]
      t *= x

  proc len[T](a: Polynomial[T]): int {.inline.} =
    a.coeffs.len
