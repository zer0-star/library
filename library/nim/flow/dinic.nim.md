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


# :warning: nim/flow/dinic.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#49819a369e0575799fa91c6b01a4bf57">nim/flow</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/flow/dinic.nim">View this file on GitHub</a>
    - Last commit date: 2020-05-29 21:27:56+09:00




## Depends on

* :warning: <a href="../datast/deque.nim.html">nim/datast/deque.nim</a>


## Code

<a id="unbundled"></a>
{% raw %}
```cpp
# %lib-executor: replace datast/deque.nim
include nim/datast/deque
# %lib-executor: end
when not declared(INCLUDE_GUARD_FLOW_DINIC_NIM):
  const INCLUDE_GUARD_FLOW_DINIC_NIM = 1

  import sequtils

  type
    DinicGraph[T] = seq[seq[tuple[to: int; cap: T; rev: int]]]
    Dinic[T] = ref object
      n: int
      graph: DinicGraph[T]

  proc initDinic[T](n: int): Dinic[T] =
    let
      graph: DinicGraph[T] = newSeqWith(n, newSeq[(int, T, int)](0))
    return Dinic[T](n: n, graph: graph)

  proc addEdge[T](dnc: Dinic[T]; frm, to: int; cap: T) =
    dnc.graph[frm].add((to, cap, dnc.graph[to].len))
    dnc.graph[to].add((frm, 0, dnc.graph[frm].len - 1))

  proc calc[T](dnc: Dinic[T]; source, target: int): T =

    proc bfs(graph: DinicGraph[T]): seq[int] =
      var deq = initDeque[int](dnc.n.nextPowerOfTwo)
      result = newSeqWith(dnc.n, -1)
      deq.addLast(source)
      result[source] = 0
      while deq.len > 0:
        let v = deq.popFirst()
        for to, cap, _ in graph[v].items:
          if result[to] < 0 and cap > 0:
            result[to] = result[v] + 1
            deq.addLast(to)

    proc dfs(graph: var DinicGraph[T]; depth: seq[int]; v: int; flow: T): T =
      if v == source: return flow
      var flowable = flow
      let d = depth[v]
      for i in graph[v].len.range:
        let (w, _, rev) = graph[v][i]
        if depth[w] >= d: continue
        let
          t = dfs(graph, depth, w, min(graph[w][rev].cap, flowable))
        graph[v][i].cap += t
        graph[w][rev].cap -= t
        flowable -= t
      return flow - flowable

    var graph = dnc.graph
    while true:
      let depth = graph.bfs()
      if depth[target] < 0: break
      result += graph.dfs(depth, target, result.high)

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

