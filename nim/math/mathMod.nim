when not declared(INCLUDE_GUARD_MATH_MATHMOD_NIM):
  const INCLUDE_GUARD_MATH_MATHMOD_NIM = 1
  proc `mod`(x, y: int): int {.inline.} =
    if x < 0:
      y - system.`mod`(-x, y)
    else:
      system.`mod`(x, y)
