when not declared(INCLUDE_GUARD_UTILS_BASE_NIM):
  const INCLUDE_GUARD_UTILS_BASE_NIM = 1
  import macros
  macro Please(x): untyped = nnkStmtList.newTree()

  Please give me AC
  Please give me AC
  Please give me AC

  {.hints: off, overflowChecks: on.}

  import strutils, sequtils, math, algorithm
  when (not (NimMajor <= 0)) or NimMinor >= 19:
    import sugar
  else:
    import future

  iterator range(x, y: int): int {.inline.} =
    var res = x
    while res < y:
      yield res
      inc(res)
  iterator range(x: int): int {.inline.} =
    var res = 0
    while res < x:
      yield res
      inc(res)
  proc range(x, y: int): seq[int] {.inline.} =
    toSeq(x..y-1)
  proc range(x: int): seq[int] {.inline.} =
    toSeq(0..x-1)
  proc discardableId[T](x: T): T {.inline, discardable.} =
    return x
  macro `:=`(x, y: untyped): untyped =
    if (x.kind == nnkIdent):
      return quote do:
        when declaredInScope(`x`):
          `x` = `y`
        else:
          var `x` = `y`
        discardableId(`x`)
    else:
      return quote do:
        `x` = `y`
        discardableId(`x`)
  when NimMajor <= 0 and NimMinor <= 17:
    proc count[T](co: openArray[T]; obj: T): int =
      for itm in items(co):
        if itm == obj:
          inc result
  proc divmod(x, y: SomeInteger): (int, int) =
    (x div y, x mod y)
  proc `min=`[T](x: var T; y: T): bool {.discardable.} =
    if x > y:
      x = y
      return true
    else:
      return false
  proc `max=`[T](x: var T; y: T): bool {.discardable.} =
    if x < y:
      x = y
      return true
    else:
      return false

  when NimMajor <= 0 and NimMinor <= 17:
    iterator pairs(n: NimNode): (int, NimNode) {.inline.} =
      for i in 0 ..< n.len:
        yield (i, n[i])

  #[
  when NimMajor <= 0 and NimMinor <= 18:
    macro parseInnerType(x: NimNode): untyped =
      newIdentNode("parse" & x[1][1].repr)
  else:
    macro parseInnerType(x: typedesc): untyped =
      newIdentNode("parse" & x.getType[1][1].repr)
  ]#

  proc parseInnerType(x: NimNode): NimNode =
    newIdentNode("parse" & x[1].repr)

  proc inputAsTuple(ty: NimNode): NimNode =
    result = nnkStmtListExpr.newTree()
    t := genSym()
    result.add quote do: (let `t` = stdin.readLine.split)
    var p : NimNode
    if ty.kind == nnkPar:
      p = nnkPar.newTree()
    elif ty.kind == nnkTupleConstr:
      p = nnkTupleConstr.newTree()
    for i, typ_tmp in ty.pairs:
      var ece, typ: NimNode
      if typ_tmp.kind == nnkExprColonExpr:
        ece = nnkExprColonExpr.newTree(typ_tmp[0])
        typ = typ_tmp[1]
      else:
        ece = nnkExprColonExpr.newTree(ident("f" & $i))
        typ = typ_tmp
      if typ.repr == "string":
        ece.add quote do: `t`[`i`]
      else:
        parsefn := newIdentNode("parse" & typ.repr)
        ece.add quote do: `t`[`i`].`parsefn`
      p.add ece
    result.add p

  macro inputAsType(ty: untyped): untyped =
    if ty.kind == nnkBracketExpr:
      if ty[1].repr == "string":
        return quote do: stdin.readLine.split
      else:
        parsefn := parseInnerType(ty)
        return quote do: stdin.readLine.split.map(`parsefn`)
        #[
          when NimMajor <= 0 and NimMinor <= 18:
            stdin.readLine.split.map(parseInnerType(ty.getType))
          else:
            stdin.readLine.split.map(parseInnerType(ty))
        ]#
    elif ty.kind == nnkTupleConstr or ty.kind == nnkPar: # support Nim version < 1.6.0
      return inputAsTuple(ty)
    elif ty.repr == "string":
      return quote do: stdin.readLine
    else:
      parsefn := ident("parse" & ty.repr)
      return quote do: stdin.readLine.`parsefn`

  macro input(query: untyped): untyped =
    doAssert query.kind == nnkStmtList
    result = nnkStmtList.newTree()
    letSect := nnkLetSection.newTree()
    for defs in query:
      if defs[0].kind == nnkIdent:
        tmp := nnkIdentDefs.newTree(defs[0], newEmptyNode())
        typ := defs[1][0]
        var val: NimNode
        if typ.len <= 2:
          val = quote do: inputAsType(`typ`)
        else:
          op := typ[2]
          typ.del(2, 1)
          val = quote do: inputAsType(`typ`).mapIt(`op`)
        if defs[1].len > 1:
          op := defs[1][1]
          it := ident"it"
          tmp.add quote do:
            block:
              var `it` = `val`
              `op`
        else:
          tmp.add val
        letSect.add tmp
      elif defs[0].kind == nnkTupleConstr or defs[0].kind == nnkPar:
        vt := nnkVarTuple.newTree()
        for id in defs[0]:
          vt.add id
        vt.add newEmptyNode()
        sle := nnkStmtListExpr.newTree()
        t := genSym()
        sle.add quote do: (let `t` = stdin.readLine.split)
        var p: NimNode
        if defs[0].kind == nnkTupleConstr:
          p = nnkTupleConstr.newTree()
        else: 
          # defs[0].kind == nnkPar
          # support Nim version < 1.6.0
          p = nnkPar.newTree()
        if defs[1][0].kind == nnkTupleConstr or defs[1][0].kind == nnkPar:
          for i, typ in defs[1][0].pairs:
            if typ.repr == "string":
              p.add quote do: `t`[`i`]
            else:
              parsefn := newIdentNode("parse" & typ.repr)
              p.add quote do: `t`[`i`].`parsefn`
        else:
          typ := defs[1][0]
          if typ.repr == "string":
            for i in 0..<defs[0].len:
              p.add quote do: `t`[`i`]
          else:
            parsefn := newIdentNode("parse" & typ.repr)
            for i in 0..<defs[0].len:
              p.add quote do: `t`[`i`].`parsefn`
        sle.add p
        vt.add sle
        letSect.add vt
      elif defs[0].kind == nnkBracketExpr:
        ids := nnkIdentDefs.newTree(defs[0][0], newEmptyNode())
        cnt := defs[0][1]
        typ := defs[1][0]
        var input: NimNode
        if typ.kind == nnkBracketExpr and typ.len > 2:
          op := typ[2]
          typ.del(2, 1)
          input = quote do: inputAsType(`typ`).mapIt(`op`)
        else:
          input = quote do: inputAsType(`typ`)
        var val: NimNode
        if defs[0].len > 2:
          op := defs[0][2]
          it := ident"it"
          val = quote do:
            block:
              var `it` = `input`
              `op`
        else:
          val = input
        if defs[1].len > 1:
          op := defs[1][1]
          it := ident"it"
          ids.add(quote do:
            block:
              var `it` = newSeqWith(`cnt`, `val`)
              `op`)
        else:
          ids.add(quote do: newSeqWith(`cnt`, `val`))
        letSect.add ids
    result.add letSect

  proc makeSeq[T, Idx](num: array[Idx, int]; init: T): auto =
    when num.len == 1:
      return newSeqWith(num[0], init)
    else:
      var tmp: array[num.len-1, int]
      for i, t in tmp.mpairs: t = num[i+1]
      return newSeqWith(num[0], makeSeq(tmp, init))
