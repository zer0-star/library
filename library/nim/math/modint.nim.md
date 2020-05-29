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


# :warning: nim/math/modint.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#bd14bd52ccff4808e6325845b40c8b47">nim/math</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/math/modint.nim">View this file on GitHub</a>
    - Last commit date: 2020-01-02 00:38:45+09:00




## Code

<a id="unbundled"></a>
{% raw %}
```cpp
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

```
{% endraw %}

<a id="bundled"></a>
{% raw %}
```cpp
Traceback (most recent call last):
  File "/opt/hostedtoolcache/Python/3.8.3/x64/lib/python3.8/site-packages/onlinejudge_verify/docs.py", line 349, in write_contents
    bundled_code = language.bundle(self.file_class.file_path, basedir=pathlib.Path.cwd())
  File "/opt/hostedtoolcache/Python/3.8.3/x64/lib/python3.8/site-packages/onlinejudge_verify/languages/nim.py", line 86, in bundle
    raise NotImplementedError
NotImplementedError

```
{% endraw %}

<a href="../../../index.html">Back to top page</a>

