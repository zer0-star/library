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


# :x: test/nim/dinic_GRL_6_A_test.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#b0410b68ca655a4ccae07472b9036d44">test/nim</a>
* <a href="{{ site.github.repository_url }}/blob/master/test/nim/dinic_GRL_6_A_test.nim">View this file on GitHub</a>
    - Last commit date: 2020-05-31 12:53:14+09:00




## Depends on

* :x: <a href="../../../library/nim/datast/deque.nim.html">nim/datast/deque.nim</a>
* :x: <a href="../../../library/nim/flow/dinic.nim.html">nim/flow/dinic.nim</a>
* :question: <a href="../../../library/nim/utils/base.nim.html">nim/utils/base.nim</a>


## Code

<a id="unbundled"></a>
{% raw %}
```cpp
include nim/flow/dinic

include nim/utils/base

input:
  (V, E): int

var
  dnc = initDinic[int](V)

for _ in range(E):
  input:
    (u, v, c): int
  dnc.addEdge(u, v, c)

echo dnc.calc(0, V-1)

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

