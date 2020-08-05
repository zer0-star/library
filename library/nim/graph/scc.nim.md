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


# :x: nim/graph/scc.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#d7814be0005a769cae255fd4fcded0e9">nim/graph</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/graph/scc.nim">View this file on GitHub</a>
    - Last commit date: 2020-08-05 22:14:10+09:00




## Verified with

* :x: <a href="../../../verify/test/nim/scc_GRL_3_C_test.nim.html">test/nim/scc_GRL_3_C_test.nim</a>


## Code

<a id="unbundled"></a>
{% raw %}
```cpp
when not declared(INCLUDE_GUARD_GRAPH_SCC_NIM):
  const INCLUDE_GUARD_GRAPH_SCC_NIM = 1

  import sequtils

  proc stronglyConnectedComponents(g: seq[seq[int]]): seq[int] =
    let
      n = g.len
    var
      rg = newSeqWith(n, newSeq[int](0))
      visited = newSeq[bool](n)
      stack = newSeq[int](0)

    result = newSeqWith(n, -1)

    proc dfs(i: int) =
      if visited[i]: return
      visited[i] = true
      for e in g[i]:
        dfs(e)
      stack.add i

    proc rdfs(i: int; res: var seq[int]; upd = true) =
      var
        count {.global.} = 0
      if res[i] != -1: return
      res[i] = count
      for e in rg[i]:
        rdfs(e, res, false)
      if upd: count.inc

    for i, w in g:
      for e in w:
        rg[e].add i

    for i in 0 ..< n:
      dfs(i)
    for i in 0 ..< n:
      rdfs(i, result)

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

