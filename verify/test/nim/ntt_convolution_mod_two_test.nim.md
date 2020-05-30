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


# :heavy_check_mark: test/nim/ntt_convolution_mod_two_test.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#b0410b68ca655a4ccae07472b9036d44">test/nim</a>
* <a href="{{ site.github.repository_url }}/blob/master/test/nim/ntt_convolution_mod_two_test.nim">View this file on GitHub</a>
    - Last commit date: 2020-05-30 00:01:34+09:00


* see: <a href="https://judge.yosupo.jp/problem/convolution_mod">https://judge.yosupo.jp/problem/convolution_mod</a>


## Depends on

* :heavy_check_mark: <a href="../../../library/nim/math/mathMod.nim.html">nim/math/mathMod.nim</a>
* :heavy_check_mark: <a href="../../../library/nim/math/modint.nim.html">nim/math/modint.nim</a>
* :heavy_check_mark: <a href="../../../library/nim/math/ntt.nim.html">nim/math/ntt.nim</a>
* :heavy_check_mark: <a href="../../../library/nim/math/polynomial.nim.html">nim/math/polynomial.nim</a>
* :heavy_check_mark: <a href="../../../library/nim/utils/base.nim.html">nim/utils/base.nim</a>


## Code

<a id="unbundled"></a>
{% raw %}
```cpp
# verify-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod

include nim/math/ntt
include nim/utils/base

import strutils

input:
  (N, M): int
  a: seq[int]; it.initPolynomial
  b: seq[int]; it.initPolynomial

let
  c = nttConvolute(a, b, 998244353)

var
  res: seq[int]

for i in range(N + M - 1):
  res.add c[i]

echo res.join(" ")

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

