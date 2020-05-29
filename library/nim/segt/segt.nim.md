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


# :warning: nim/segt/segt.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#1698669b3e8f840124934f80c60539e2">nim/segt</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/segt/segt.nim">View this file on GitHub</a>
    - Last commit date: 2020-01-02 00:38:45+09:00




## Code

<a id="unbundled"></a>
{% raw %}
```cpp
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

