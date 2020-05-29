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


# :x: nim/math/ntt.nim

<a href="../../../index.html">Back to top page</a>

* category: <a href="../../../index.html#bd14bd52ccff4808e6325845b40c8b47">nim/math</a>
* <a href="{{ site.github.repository_url }}/blob/master/nim/math/ntt.nim">View this file on GitHub</a>
    - Last commit date: 2020-05-29 21:27:56+09:00




## Depends on

* :question: <a href="mathMod.nim.html">nim/math/mathMod.nim</a>
* :question: <a href="modint.nim.html">nim/math/modint.nim</a>
* :x: <a href="polynomial.nim.html">nim/math/polynomial.nim</a>


## Verified with

* :x: <a href="../../../verify/test/nim/ntt_convolution_mod_one_test.nim.html">test/nim/ntt_convolution_mod_one_test.nim</a>


## Code

<a id="unbundled"></a>
{% raw %}
```cpp
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

  proc nttConvolute(f, g: Polynomial[int]; USE: int = 3;
      modulo = -1): Polynomial[int] =
    var tmp = newSeq[(int, seq[int])](USE)
    for i in 0..<USE:
      let (M, PRoot) = NTT_PRIMES[i]
      tmp[i] = (M, nttConvolute_innerProc(f, g, M, PRoot))
    let (_, res) = tmp.garner(modulo)
    return initPolynomial(res)

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

