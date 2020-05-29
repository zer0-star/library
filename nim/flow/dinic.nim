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
