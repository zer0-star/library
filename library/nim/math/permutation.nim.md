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


# :warning: nim/math/permutation.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#bd14bd52ccff4808e6325845b40c8b47">nim/math</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/math/permutation.nim">View this file on GitHub</a>
    - Last commit date: 2020-05-29 21:27:56+09:00




## Code

<a id="unbundled"></a>
{% raw %}
```cpp
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

```
{% endraw %}

<a id="bundled"></a>
{% raw %}
```cpp
Traceback (most recent call last):
  File "/opt/hostedtoolcache/Python/3.8.5/x64/lib/python3.8/site-packages/onlinejudge_verify/docs.py", line 349, in write_contents
    bundled_code = language.bundle(self.file_class.file_path, basedir=pathlib.Path.cwd())
  File "/opt/hostedtoolcache/Python/3.8.5/x64/lib/python3.8/site-packages/onlinejudge_verify/languages/nim.py", line 86, in bundle
    raise NotImplementedError
NotImplementedError

```
{% endraw %}

<a href="../../../index.html">Back to top page</a>

