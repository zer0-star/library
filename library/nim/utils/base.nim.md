---
layout: default
---

<!-- mathjax config similar to math.stackexchange -->
<script type="text/javascript" async
  src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML">
</script>
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    TeX: { equationNumbers: { autoNumber: "AMS" }},
    tex2jax: {
      inlineMath: [ ['$','$'] ],
      processEscapes: true
    },
    "HTML-CSS": { matchFontHeight: false },
    displayAlign: "left",
    displayIndent: "2em"
  });
</script>

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery-balloon-js@1.1.2/jquery.balloon.min.js" integrity="sha256-ZEYs9VrgAeNuPvs15E39OsyOJaIkXEEt10fzxJ20+2I=" crossorigin="anonymous"></script>
<script type="text/javascript" src="../../../assets/js/copy-button.js"></script>
<link rel="stylesheet" href="../../../assets/css/copy-button.css" />


# :heavy_check_mark: nim/utils/base.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#004982f169dc86a24617d5ee8c1574a7">nim/utils</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/utils/base.nim">View this file on GitHub</a>
    - Last commit date: 2020-05-30 00:01:34+09:00




## Verified with

* :heavy_check_mark: <a href="../../../verify/test/nim/lazy_test.nim.html">test/nim/lazy_test.nim</a>
* :heavy_check_mark: <a href="../../../verify/test/nim/ntt_convolution_mod_1000000007_test.nim.html">test/nim/ntt_convolution_mod_1000000007_test.nim</a>
* :heavy_check_mark: <a href="../../../verify/test/nim/ntt_convolution_mod_one_test.nim.html">test/nim/ntt_convolution_mod_one_test.nim</a>
* :heavy_check_mark: <a href="../../../verify/test/nim/ntt_convolution_mod_two_test.nim.html">test/nim/ntt_convolution_mod_two_test.nim</a>
* :heavy_check_mark: <a href="../../../verify/test/nim/segt_point_add_range_sum_test.nim.html">test/nim/segt_point_add_range_sum_test.nim</a>
* :heavy_check_mark: <a href="../../../verify/test/nim/segt_point_set_range_composite_test.nim.html">test/nim/segt_point_set_range_composite_test.nim</a>
* :heavy_check_mark: <a href="../../../verify/test/nim/unionfind_test.nim.html">test/nim/unionfind_test.nim</a>


## Code

<a id="unbundled"></a>
{% raw %}
```cpp
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
    p := nnkPar.newTree()
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
    elif ty.kind == nnkPar:
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
      elif defs[0].kind == nnkPar:
        vt := nnkVarTuple.newTree()
        for id in defs[0]:
          vt.add id
        vt.add newEmptyNode()
        sle := nnkStmtListExpr.newTree()
        t := genSym()
        sle.add quote do: (let `t` = stdin.readLine.split)
        p := nnkPar.newTree()
        if defs[1][0].kind == nnkPar:
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

```
{% endraw %}

<a id="bundled"></a>
{% raw %}
```cpp
Traceback (most recent call last):
  File "/opt/hostedtoolcache/Python/3.8.3/x64/lib/python3.8/site-packages/online_judge_verify_helper-4.10.3-py3.8.egg/onlinejudge_verify/docs.py", line 349, in write_contents
    bundled_code = language.bundle(self.file_class.file_path, basedir=pathlib.Path.cwd())
  File "/opt/hostedtoolcache/Python/3.8.3/x64/lib/python3.8/site-packages/online_judge_verify_helper-4.10.3-py3.8.egg/onlinejudge_verify/languages/nim.py", line 86, in bundle
    raise NotImplementedError
NotImplementedError

```
{% endraw %}

<a href="../../../index.html">Back to top page</a>

