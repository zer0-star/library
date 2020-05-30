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


# :warning: nim/datast/deque.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#1b8732700e69194ebf9f993f934ce42d">nim/datast</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/datast/deque.nim">View this file on GitHub</a>
    - Last commit date: 2020-01-02 00:38:45+09:00




## Required by

* :warning: <a href="../flow/dinic.nim.html">nim/flow/dinic.nim</a>


## Code

<a id="unbundled"></a>
{% raw %}
```cpp
when not declared(INCLUDE_GUARD_DATAST_DEQUE_NIM):
  const INCLUDE_GUARD_DATAST_DEQUE_NIM = 1
  import math
  type
    Deque[T] = ref object
      data: seq[T]
      ## [head, tail)
      head, tail, count, mask: int

  proc initDeque[T](size = 4): Deque[T] =
    assert isPowerOfTwo(size)
    let mask = size-1
    return Deque[T](data: newSeq[T](size), head: 0, tail: 0, count: 0, mask: mask)

  template emptyCheck(deq: untyped) =
    # Bounds check for the regular deque access.
    when compileOption("boundChecks"):
      if unlikely(deq.count < 1):
        raise newException(IndexError, "Empty deque.")

  template xBoundsCheck(deq, i: untyped) =
    # Bounds check for the array like accesses.
    when compileOption("boundChecks"): # d:release should disable this.
      if unlikely(i >= deq.count): # x < deq.low is taken care by the Natural parameter
        raise newException(IndexError, "Out of bounds: " & $i & " > " & $(
            deq.count - 1))
      if unlikely(i < 0): # when used with BackwardsIndex
        raise newException(IndexError, "Out of bounds: " & $i & " < 0")

  proc len[T](deq: Deque[T]): int {.inline.} =
    deq.count

  proc `[]`[T](deq: Deque[T]; index: int): T {.inline.} =
    xBoundsCheck(deq, index)
    deq.data[(deq.head + index) and deq.mask]

  proc expandIfNeeded[T](deq: Deque[T]) =
    if unlikely(deq.data.len == deq.count):
      let lastLen = deq.data.len
      deq.data.setLen(lastLen * 2)
      deq.mask = (deq.mask shl 1) + 1
      if deq.head >= deq.tail:
        for i in deq.head..<lastLen:
          deq.data[i+lastLen] = deq.data[i]
        deq.head += lastLen

  proc addFirst[T](deq: Deque[T]; val: T) =
    expandIfNeeded(deq)
    deq.count.inc
    deq.head = (deq.head-1) and deq.mask
    deq.data[deq.head] = val

  proc addLast[T](deq: Deque[T]; val: T) =
    expandIfNeeded(deq)
    deq.count.inc
    deq.data[deq.tail] = val
    deq.tail = (deq.tail+1) and deq.mask

  proc peekFirst[T](deq: Deque[T]): T {.inline.} =
    emptyCheck(deq)
    return deq.data[deq.head]

  proc peekLast[T](deq: Deque[T]): T {.inline.} =
    emptyCheck(deq)
    return deq.data[(deq.tail-1) and deq.mask]

  proc popFirst[T](deq: Deque[T]): T {.inline, discardable.} =
    emptyCheck(deq)
    deq.count.dec
    result = deq.data[deq.head]
    deq.head = (deq.head+1) and deq.mask

  proc popLast[T](deq: Deque[T]): T {.inline, discardable.} =
    emptyCheck(deq)
    deq.count.dec
    deq.tail = (deq.tail-1) and deq.mask
    result = deq.data[deq.tail]



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

