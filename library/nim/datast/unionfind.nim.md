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


# :warning: nim/datast/unionfind.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#1b8732700e69194ebf9f993f934ce42d">nim/datast</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/datast/unionfind.nim">View this file on GitHub</a>
    - Last commit date: 2020-01-02 00:38:45+09:00




## Code

<a id="unbundled"></a>
{% raw %}
```cpp
when not declared(INCLUDE_GUARD_DATAST_UNIONFIND_NIM):
  const INCLUDE_GUARD_DATAST_UNIONFIND_NIM = 1
  import tables, sequtils

  type
    UnionFind[T] = ref object
      when T is int:
        par: seq[int]
        siz: seq[int]
      else:
        par: Table[T, T]
        siz: Table[T, int]

  proc find[T](t: UnionFind[T]; o: T): T =
    if t.par[o] == o: return o
    t.par[o] = t.find(t.par[o])
    return t.par[o]
  proc union[T](t: UnionFind[T]; x, y: T) =
    let (rx, ry) = (t.find(x), t.find(y))
    if rx == ry: return
    if t.siz[rx] < t.siz[ry]:
      t.par[rx] = ry
      t.siz[ry] += t.siz[rx]
    else:
      t.par[ry] = rx
      t.siz[rx] += t.siz[ry]
  proc isSame[T](t: UnionFind[T]; x, y: T): bool =
    return t.find(x) == t.find(y)
  proc size[T](t: UnionFind[T]; x: T): int =
    return t.siz[t.find(x)]
  proc initUF(size: int): UnionFind[int] =
    return UnionFind[int](par: toSeq(0..<size), siz: newSeqWith(size, 1))
  proc initUF[T](field: openArray[T]): UnionFind[T] =
    var
      par = initTable[T, T]()
      siz = initTable[T, int]()
    for t in field:
      par[t] = t
      siz[t] = 1
    return UnionFind[T](par: par, siz: siz)

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

