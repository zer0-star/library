when not declared(INCLUDE_GUARD_SEGT_SEGT_NIM):
  const INCLUDE_GUARD_SEGT_SEGT_NIM = 1

  import future, sequtils

  type
    SegmentTree[T] = object
      n: int
      node: seq[T]
      ad: (T, T) -> T
      zero: T

  proc initSegT[T](data: seq[T]; ad: (T, T) -> T; zero: T): SegmentTree[T] =
    let n = data.len.nextPowerOfTwo
    var node = newSeq[T](2*n)
    for i in range(data.len):
      node[i+n] = data[i]
    for i in range(data.len, n):
      node[i+n] = zero
    for i in countdown(n-1, 1):
      node[i] = ad(node[2*i], node[2*i+1])
    return SegmentTree[T](n: n, node: node, ad: ad, zero: zero)

  proc initSegT[T](siz: int; ad: (T, T) -> T; zero: T): SegmentTree[T] =
    let n = siz.nextPowerOfTwo
    var node = newSeqWith(2*n, zero)
    return SegmentTree[T](n: n, node: node, ad: ad, zero: zero)

  proc get[T](segt: SegmentTree[T]; x: int): T =
    segt.node[x + segt.n]

  proc update[T](segt: var SegmentTree[T]; x: int; val: T) =
    var i = x + segt.n
    segt.node[i] = val
    i = i div 2
    while i > 0:
      segt.node[i] = segt.ad(segt.node[2*i], segt.node[2*i+1])
      i = i div 2

  proc query[T](segt: SegmentTree[T]; a, b: int): T =
    if segt.n <= a or b <= 0: return segt.zero
    var
      (l, r) = (max(segt.n, a+segt.n), min(b+segt.n, segt.n * 2))
      leftVal, rightVal = segt.zero
    while l < r:
      if l mod 2 == 1:
        leftVal = segt.ad(leftVal, segt.node[l])
        l.inc
      if r mod 2 == 1:
        r.dec
        rightVal = segt.ad(segt.node[r], rightVal)
      l = l shr 1
      r = r shr 1
    return segt.ad(leftVal, rightVal)
