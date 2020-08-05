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
    for i in stack.reversed:
      rdfs(i, result)
