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


# :heavy_check_mark: nim/math/modint.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#bd14bd52ccff4808e6325845b40c8b47">nim/math</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/math/modint.nim">View this file on GitHub</a>
    - Last commit date: 2020-05-30 00:01:34+09:00




## Depends on

* :heavy_check_mark: <a href="mathMod.nim.html">nim/math/mathMod.nim</a>


## Required by

* :heavy_check_mark: <a href="ntt.nim.html">nim/math/ntt.nim</a>


## Verified with

* :heavy_check_mark: <a href="../../../verify/test/nim/lazy_test.nim.html">test/nim/lazy_test.nim</a>
* :heavy_check_mark: <a href="../../../verify/test/nim/ntt_convolution_mod_1000000007_test.nim.html">test/nim/ntt_convolution_mod_1000000007_test.nim</a>
* :heavy_check_mark: <a href="../../../verify/test/nim/ntt_convolution_mod_one_test.nim.html">test/nim/ntt_convolution_mod_one_test.nim</a>
* :heavy_check_mark: <a href="../../../verify/test/nim/ntt_convolution_mod_two_test.nim.html">test/nim/ntt_convolution_mod_two_test.nim</a>
* :heavy_check_mark: <a href="../../../verify/test/nim/segt_point_set_range_composite_test.nim.html">test/nim/segt_point_set_range_composite_test.nim</a>


## Code

<a id="unbundled"></a>
{% raw %}
```cpp
# %lib-executor: replace math/mathMod.nim
include nim/math/mathMod
# %lib-executor: end
when not declared(INCLUDE_GUARD_MATH_MODINT_NIM):
  const INCLUDE_GUARD_MATH_MODINT_NIM = 1
  import math, sequtils
  import strutils

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
      con = newSeqWith(n, newSeq[int](P))
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

  template parseModInt(x: string): ModInt =
    initModInt(x.parseInt)

```
{% endraw %}

<a id="bundled"></a>
{% raw %}
```cpp
Traceback (most recent call last):
  File "/opt/hostedtoolcache/Python/3.8.3/x64/lib/python3.8/site-packages/online_judge_verify_helper-4.10.2-py3.8.egg/onlinejudge_verify/docs.py", line 349, in write_contents
    bundled_code = language.bundle(self.file_class.file_path, basedir=pathlib.Path.cwd())
  File "/opt/hostedtoolcache/Python/3.8.3/x64/lib/python3.8/site-packages/online_judge_verify_helper-4.10.2-py3.8.egg/onlinejudge_verify/languages/nim.py", line 86, in bundle
    raise NotImplementedError
NotImplementedError

```
{% endraw %}

<a href="../../../index.html">Back to top page</a>

