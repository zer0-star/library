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


