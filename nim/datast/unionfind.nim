when not declared(INCLUDE_GUARD_DATAST_UNIONFIND_NIM):
  const INCLUDE_GUARD_DATAST_UNIONFIND_NIM = 1
  import tables, sequtils

  type
    UnionFind[T] = ref object
      when T is int:
        par: seq[int]
        siz: seq[int]
      else:
        par: Table[T, T]
        siz: Table[T, int]

  proc find[T](t: UnionFind[T]; o: T): T =
    if t.par[o] == o: return o
    t.par[o] = t.find(t.par[o])
    return t.par[o]
  proc union[T](t: UnionFind[T]; x, y: T) =
    let (rx, ry) = (t.find(x), t.find(y))
    if rx == ry: return
    if t.siz[rx] < t.siz[ry]:
      t.par[rx] = ry
      t.siz[ry] += t.siz[rx]
    else:
      t.par[ry] = rx
      t.siz[rx] += t.siz[ry]
  proc isSame[T](t: UnionFind[T]; x, y: T): bool =
    return t.find(x) == t.find(y)
  proc size[T](t: UnionFind[T]; x: T): int =
    return t.siz[t.find(x)]
  proc initUF(size: int): UnionFind[int] =
    return UnionFind[int](par: toSeq(0..<size), siz: newSeqWith(size, 1))
  proc initUF[T](field: openArray[T]): UnionFind[T] =
    var
      par = initTable[T, T]()
      siz = initTable[T, int]()
    for t in field:
      par[t] = t
      siz[t] = 1
    return UnionFind[T](par: par, siz: siz)
