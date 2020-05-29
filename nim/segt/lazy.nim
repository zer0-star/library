when not declared(INCLUDE_GUARD_SEGT_LAZY_NIM):
  const INCLUDE_GUARD_SEGT_LAZY_NIM = 1

  import sequtils, math, bitops

  when (not (NimMajor <= 0)) or NimMinor >= 19:
    import sugar
  else:
    import future

  type
    LazySegmentTree[T, O] = ref object
      n: int
      node: seq[T]
      lazy: seq[O]
      ad: (T, T) -> T
      op: (T, O) -> T
      marge: (O, O) -> O
      zeroT: T
      zeroO: O

  proc initLazySegT[T, O](data: seq[T];
                          ad: (T, T) -> T;
                          op: (T, O) -> T;
                          marge: (O, O) -> O;
                          zeroT: T;
                          zeroO: O): LazySegmentTree[T, O] =
    let
      n = data.len.nextPowerOfTwo
      lazy = newSeqWith(2*n, zeroO)
    var
      node = newSeq[T](2*n)
    for i in 0..<data.len:
      node[i+n] = data[i]
    for i in data.len..<n:
      node[i+n] = zeroT
    for i in countdown(n-1, 1):
      node[i] = ad(node[i*2], node[i*2+1])
    return LazySegmentTree[T, O](
      n: n,
      node: node,
      lazy: lazy,
      ad: ad,
      op: op,
      marge: marge,
      zeroT: zeroT,
      zeroO: zeroO
    )

  proc propagate[T, O](segt: LazySegmentTree[T, O]; i: int) =
    segt.lazy[2*i] = segt.marge(segt.lazy[2*i], segt.lazy[i])
    segt.lazy[2*i+1] = segt.marge(segt.lazy[2*i+1], segt.lazy[i])
    segt.lazy[i] = segt.zeroO

  proc propagateBound[T, O](segt: LazySegmentTree[T, O]; i: int) =
    if i == 0: return
    let ctz = countTrailingZeroBits(i)
    for h in countdown(63 - countLeadingZeroBits(i), ctz+1):
      segt.propagate(i shr h)

  proc recalc[T, O](segt: LazySegmentTree[T, O]; i: int) =
    segt.node[i] = segt.ad(segt.op(segt.node[2*i], segt.lazy[2*i]), segt.op(
        segt.node[2*i+1], segt.lazy[2*i+1]))

  proc recalcBound[T, O](segt: LazySegmentTree[T, O]; i: int) =
    if i == 0: return
    var i = i shr countTrailingZeroBits(i)
    while i > 1:
      i = i div 2
      segt.recalc(i)

  proc updateRange[T, O](segt: LazySegmentTree[T, O]; left, right: int; v: O) =
    var
      left = left + segt.n
      right = right + segt.n
    segt.propagateBound(left)
    segt.propagateBound(right)
    let
      leftOrig = left
      rightOrig = right
    while left < right:
      if left mod 2 == 1:
        segt.lazy[left] = segt.marge(segt.lazy[left], v)
        left.inc
      if right mod 2 == 1:
        right.dec
        segt.lazy[right] = segt.marge(segt.lazy[right], v)
      left = left div 2
      right = right div 2
    segt.recalcBound(leftOrig)
    segt.recalcBound(rightOrig)

  proc updatePoint[T, O](segt: LazySegmentTree[T, O]; x: int; v: T) =
    var i = segt.n + x
    for h in countdown(63 - countLeadingZeroBits(i), 1):
      segt.propagate(i shr h)
    segt.node[i] = v
    segt.lazy[i] = segt.zeroO
    while i > 1:
      i = i div 2
      segt.recalc(i)

  proc fold[T, O](segt: LazySegmentTree[T, O]; left, right: int): T =
    var
      left = left + segt.n
      right = right + segt.n
      accL, accR = segt.zeroT
    segt.propagateBound(left)
    segt.recalcBound(left)
    segt.propagateBound(right)
    segt.recalcBound(right)
    while left < right:
      if left mod 2 == 1:
        accL = segt.ad(accL, segt.op(segt.node[left], segt.lazy[left]))
        left.inc
      if right mod 2 == 1:
        right.dec
        accR = segt.ad(segt.op(segt.node[right], segt.lazy[right]), accR)
      left = left div 2
      right = right div 2
    result = segt.ad(accL, accR)

  proc getPoint[T, O](segt: LazySegmentTree[T, O]; i: int): T =
    let i = segt.n + i
    for h in countdown(63 - countLeadingZeroBits(i), 1):
      segt.propagate(i shr h)
    return segt.op(segt.node[i], segt.lazy[i])
