# %lib-executor: replace math/modint.nim
include nim/math/modint
# %lib-executor: end
# %lib-executor: replace math/polynomial.nim
include nim/math/polynomial
# %lib-executor: end
when not declared(INCLUDE_GUARD_MATH_FFT_NIM):
  const INCLUDE_GUARD_MATH_FFT_NIM = 1
  import sequtils, math
  import bitops

  # NTT_PRIMES from:
  # https://lumakernel.github.io/ecasdqina/math/FFT/NTT
  const NTT_PRIMES = [
    (1224736769, 3), # 2^24 * 73 + 1,
    (1053818881, 7), # 2^20 * 3 * 5 * 67 + 1
    (1051721729, 6), # 2^20 * 17 * 59 + 1
    (1045430273, 3), # 2^20 * 997 + 1
    (1012924417, 5), # 2^21 * 3 * 7 * 23 + 1
    (1007681537, 3), # 2^20 * 31^2 + 1
    (1004535809, 3), # 2^21 * 479 + 1
    (998244353, 3),  # 2^23 * 7 * 17 + 1
    (985661441, 3),  # 2^22 * 5 * 47 + 1
    (976224257, 3),  # 2^20 * 7^2 * 19 + 1
    (975175681, 17), # 2^21 * 3 * 5 * 31 + 1
    (962592769, 7),  # 2^21 * 3^3 * 17 + 1
    (950009857, 7),  # 2^21 * 4 * 151 + 1
    (943718401, 7),  # 2^22 * 3^2 * 5^2 + 1
    (935329793, 3),  # 2^22 * 223 + 1
    (924844033, 5),  # 2^21 * 3^2 * 7^2 + 1
    (469762049, 3),  # 2^26 * 7 + 1
    (167772161, 3),  # 2^25 * 5 + 1
  ]

  proc ntt(f: Polynomial[int]; zeta: seq[int]; M: int; lev: int): Polynomial[int] =
    assert f.len.isPowerOfTwo
    if lev == -1:
      return initPolynomial(@[f[0]])
    let
      dlen = f.len div 2
      mask = dlen-1
    result = initPolynomial[int](f.len)
    var f0, f1 = initPolynomial[int](dlen)
    for i in 0..<dlen:
      f0[i] = f[2*i]
      f1[i] = f[2*i+1]
    let
      ff0 = ntt(f0, zeta, M, lev-1)
      ff1 = ntt(f1, zeta, M, lev-1)
    var t = 1
    for i in 0 ..< f.len:
      result[i] = (ff0[i and mask] + ff1[i and mask] * t mod M) mod M
      t = t * zeta[lev] mod M

  proc nttConvolute_innerProc(f, g: Polynomial[int]; M, PRoot: int): seq[int] =
    var
      f = f
      g = g
    let
      alpha = fastLog2(((f.len + g.len - 1) - 1) shl 1)
      n = if alpha > 0: alpha else: 1
      # n = float(f.len + g.len - 1).log2.ceil.int
      flen = 2^n
      invlen = modinv(flen, M)
    var
      zeta, zeta_inv = newSeq[int](n)
    zeta[n-1] = modpow(PRoot, (M-1) div (1 shl n), M)
    zeta_inv[n-1] = modinv(zeta[n-1], M)
    for i in countdown(n-2, 0):
      zeta[i] = zeta[i+1] * zeta[i+1] mod M
      zeta_inv[i] = zeta_inv[i+1] * zeta_inv[i+1] mod M
    f.expand(flen)
    g.expand(flen)
    let F = initPolynomial(zip(f.ntt(zeta, M, n-1).coeffs, g.ntt(zeta, M,
        n-1).coeffs).mapIt(it[0]*it[1] mod M))
    result = F.ntt(zeta_inv, M, n-1).coeffs.mapIt(it * invlen mod M)

  proc nttConvolute(f, g: Polynomial[int]; modulo = -1;
      USE: int = 3): Polynomial[int] =
    var tmp = newSeq[(int, seq[int])](USE)
    for i in 0..<USE:
      let (M, PRoot) = NTT_PRIMES[i]
      tmp[i] = (M, nttConvolute_innerProc(f, g, M, PRoot))
    let (_, res) = tmp.garner(modulo)
    return initPolynomial(res)
