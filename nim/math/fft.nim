# %lib-executor: replace math/complex.nim
include ./complex
# %lib-executor: end
# %lib-executor: replace math/polynomial.nim
include ./polynomial
# %lib-executor: end
when not declared(INCLUDE_GUARD_MATH_FFT_NIM):
  const INCLUDE_GUARD_MATH_FFT_NIM = 1
  import sequtils, math

  proc fft[T](f: Polynomial[T]; zeta: Complex): Polynomial[Complex] =
    assert f.len.isPowerOfTwo
    if f.len == 1:
      when T is float:
        return initPolynomial(@[f[0].complex])
      elif T is Complex:
        return initPolynomial(@[f[0]])
      elif T is int:
        return initPolynomial(@[f[0].float.complex])
    let dlen = f.len div 2
    result = initPolynomial[Complex](f.len)
    var f0, f1 = initPolynomial[T](dlen)
    for i in 0..<dlen:
      f0[i] = f[2*i]
      f1[i] = f[2*i+1]
    let
      ff0 = fft(f0, zeta*zeta)
      ff1 = fft(f1, zeta*zeta)
    var t = 1.complex
    for i in 0 ..< f.len:
      result[i] = ff0[i mod dlen] + ff1[i mod dlen] * t
      t *= zeta

  proc fftConvolute[T](f, g: Polynomial[T]): Polynomial[float] =
    var
      f = f
      g = g
    let
      flen = (f.len + g.len - 1).nextPowerOfTwo
      zeta = complex(cos(2*PI/float(flen)), sin(2*PI/float(flen)))
    f.expand(flen)
    g.expand(flen)
    let F = initPolynomial(zip(f.fft(zeta).coeffs, g.fft(zeta).coeffs).map((
        it: (Complex, Complex)) => it[0]*it[1]))
    result.coeffs = F.fft(inv(zeta)).coeffs.mapIt(it.re/float(flen))
