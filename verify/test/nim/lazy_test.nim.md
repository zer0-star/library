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


# :heavy_check_mark: test/nim/lazy_test.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#b0410b68ca655a4ccae07472b9036d44">test/nim</a>
* <a href="{{ site.github.repository_url }}/blob/master/test/nim/lazy_test.nim">View this file on GitHub</a>
    - Last commit date: 2020-05-30 00:01:34+09:00


* see: <a href="https://judge.yosupo.jp/problem/range_affine_range_sum">https://judge.yosupo.jp/problem/range_affine_range_sum</a>


## Depends on

* :heavy_check_mark: <a href="../../../library/nim/math/mathMod.nim.html">nim/math/mathMod.nim</a>
* :heavy_check_mark: <a href="../../../library/nim/math/modint.nim.html">nim/math/modint.nim</a>
* :heavy_check_mark: <a href="../../../library/nim/segt/lazy.nim.html">nim/segt/lazy.nim</a>
* :question: <a href="../../../library/nim/utils/base.nim.html">nim/utils/base.nim</a>


## Code

<a id="unbundled"></a>
{% raw %}
```cpp
# verify-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_range_sum

include nim/segt/lazy

include nim/utils/base

include nim/math/modint

const MOD = 998244353

type
  mi = ModInt[MOD]

input:
  (N, Q): int
  a: seq[int, (it.initModInt, 1.initModInt)]

var
  segt = initLazySegT[(mi, mi), (mi, mi)](
    a,
    (((mi, mi), (mi, mi)) -> (mi, mi)) => (i0[0] + i1[0], i0[1] + i1[1]),
    (((mi, mi), (mi, mi)) -> (mi, mi)) => (i1[0] * i0[0] + i1[1] * i0[1], i0[1]),
    (((mi, mi), (mi, mi)) -> (mi, mi)) => (i0[0] * i1[0], i0[1] * i1[0] + i1[1]),
    (initModInt(0), initModInt(1)),
    (initModInt(1), initModInt(0))
  )

for _ in range(Q):
  let
    tmp = stdin.readLine.split.map(parseInt)
  if tmp[0] == 0:
    segt.updateRange(tmp[1], tmp[2], (initModInt(tmp[3]), initModInt(tmp[4])))
  else:
    echo segt.fold(tmp[1], tmp[2])[0]

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

