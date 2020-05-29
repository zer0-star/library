when not declared(INCLUDE_GUARD_MATH_PERMUTATION_NIM):
  const INCLUDE_GUARD_MATH_PERMUTATION_NIM = 1

  import sequtils

  type
    Permutation = object
      size: int
      data: seq[int]

  proc initPerm(size: int): Permutation {.inline.} =
    Permutation(size: size, data: toSeq(0 .. size-1))

  proc nonInitializedPermutation(size: int): Permutation {.inline.} =
    Permutation(size: size, data: newSeq[int](size))

  proc swap(p: var Permutation; x, y: int) {.inline.} =
    swap(p.data[x], p.data[y])

  proc `[]`(p: Permutation; x: int): int {.inline.} =
    p.data[x]

  proc inv(p: Permutation): Permutation {.inline.} =
    result = nonInitializedPermutation(p.size)
    for i in 0 ..< p.size:
      result.data[p[i]] = i

  proc `*`(p, q: Permutation): Permutation {.inline.} =
    assert p.size == q.size
    result = nonInitializedPermutation(p.size)
    for i in 0 ..< p.size:
      result.data[i] = q[p[i]]

  proc `*=`(p: var Permutation; q: Permutation) {.inline.} =
    p = p*q

  proc pow(p: Permutation; x: int): Permutation {.inline.} =
    var
      x = x
      p = p
    result = initPerm(p.size)
    while x > 0:
      if (x and 1) > 0:
        result *= p
      p *= p
      x = x shr 1

  proc apply[T](p: Permutation; xs: seq[T]): seq[T] =
    result = newSeq[T](xs.len)
    for i in 0 ..< xs.len:
      result[p[i]] = xs[i]
