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


# :heavy_check_mark: nim/math/mathMod.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#bd14bd52ccff4808e6325845b40c8b47">nim/math</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/math/mathMod.nim">View this file on GitHub</a>
    - Last commit date: 2020-01-02 00:38:45+09:00




## Required by

* :heavy_check_mark: <a href="modint.nim.html">nim/math/modint.nim</a>
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
when not declared(INCLUDE_GUARD_MATH_MATHMOD_NIM):
  const INCLUDE_GUARD_MATH_MATHMOD_NIM = 1
  proc `mod`(x, y: int): int {.inline.} =
    if x < 0:
      y - system.`mod`(-x, y)
    else:
      system.`mod`(x, y)

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

