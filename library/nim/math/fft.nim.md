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


# :warning: nim/math/fft.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#bd14bd52ccff4808e6325845b40c8b47">nim/math</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/math/fft.nim">View this file on GitHub</a>
    - Last commit date: 2020-05-29 21:27:56+09:00




## Code

<a id="unbundled"></a>
{% raw %}
```cpp
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

```
{% endraw %}

<a id="bundled"></a>
{% raw %}
```cpp
Traceback (most recent call last):
  File "/opt/hostedtoolcache/Python/3.8.3/x64/lib/python3.8/site-packages/online_judge_verify_helper-4.10.2-py3.8.egg/onlinejudge_verify/docs.py", line 349, in write_contents
    bundled_code = language.bundle(self.file_class.file_path, basedir=pathlib.Path.cwd())
  File "/opt/hostedtoolcache/Python/3.8.3/x64/lib/python3.8/site-packages/online_judge_verify_helper-4.10.2-py3.8.egg/onlinejudge_verify/languages/nim.py", line 86, in bundle
    raise NotImplementedError
NotImplementedError

```
{% endraw %}

<a href="../../../index.html">Back to top page</a>

