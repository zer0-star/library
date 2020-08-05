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
<script type="text/javascript" src="assets/js/copy-button.js"></script>
<link rel="stylesheet" href="assets/css/copy-button.css" />


# {{ site.title }}

[![Actions Status]({{ site.github.repository_url }}/workflows/verify/badge.svg)]({{ site.github.repository_url }}/actions)
<a href="{{ site.github.repository_url }}"><img src="https://img.shields.io/github/last-commit/{{ site.github.owner_name }}/{{ site.github.repository_name }}" /></a>

{% if site.github.project_tagline %}{{ site.github.project_tagline }}{% else %}This documentation is automatically generated by <a href="https://github.com/online-judge-tools/verification-helper">online-judge-tools/verification-helper</a>.{% endif %}

## Library Files

<div id="1b8732700e69194ebf9f993f934ce42d"></div>

### nim/datast

* :heavy_check_mark: <a href="library/nim/datast/deque.nim.html">nim/datast/deque.nim</a>
* :heavy_check_mark: <a href="library/nim/datast/unionfind.nim.html">nim/datast/unionfind.nim</a>


<div id="49819a369e0575799fa91c6b01a4bf57"></div>

### nim/flow

* :heavy_check_mark: <a href="library/nim/flow/dinic.nim.html">nim/flow/dinic.nim</a>


<div id="d7814be0005a769cae255fd4fcded0e9"></div>

### nim/graph

* :heavy_check_mark: <a href="library/nim/graph/scc.nim.html">nim/graph/scc.nim</a>


<div id="bd14bd52ccff4808e6325845b40c8b47"></div>

### nim/math

* :warning: <a href="library/nim/math/fft.nim.html">nim/math/fft.nim</a>
* :heavy_check_mark: <a href="library/nim/math/mathMod.nim.html">nim/math/mathMod.nim</a>
* :heavy_check_mark: <a href="library/nim/math/modint.nim.html">nim/math/modint.nim</a>
* :heavy_check_mark: <a href="library/nim/math/ntt.nim.html">nim/math/ntt.nim</a>
* :warning: <a href="library/nim/math/permutation.nim.html">nim/math/permutation.nim</a>
* :heavy_check_mark: <a href="library/nim/math/polynomial.nim.html">nim/math/polynomial.nim</a>


<div id="1698669b3e8f840124934f80c60539e2"></div>

### nim/segt

* :heavy_check_mark: <a href="library/nim/segt/lazy.nim.html">nim/segt/lazy.nim</a>
* :heavy_check_mark: <a href="library/nim/segt/segt.nim.html">nim/segt/segt.nim</a>


<div id="004982f169dc86a24617d5ee8c1574a7"></div>

### nim/utils

* :heavy_check_mark: <a href="library/nim/utils/base.nim.html">nim/utils/base.nim</a>


## Verify Files

* :heavy_check_mark: <a href="verify/test/nim/dinic_GRL_6_A_test.nim.html">test/nim/dinic_GRL_6_A_test.nim</a>
* :heavy_check_mark: <a href="verify/test/nim/lazy_test.nim.html">test/nim/lazy_test.nim</a>
* :heavy_check_mark: <a href="verify/test/nim/ntt_convolution_mod_1000000007_test.nim.html">test/nim/ntt_convolution_mod_1000000007_test.nim</a>
* :heavy_check_mark: <a href="verify/test/nim/ntt_convolution_mod_one_test.nim.html">test/nim/ntt_convolution_mod_one_test.nim</a>
* :heavy_check_mark: <a href="verify/test/nim/ntt_convolution_mod_two_test.nim.html">test/nim/ntt_convolution_mod_two_test.nim</a>
* :heavy_check_mark: <a href="verify/test/nim/scc_GRL_3_C_test.nim.html">test/nim/scc_GRL_3_C_test.nim</a>
* :heavy_check_mark: <a href="verify/test/nim/segt_point_add_range_sum_test.nim.html">test/nim/segt_point_add_range_sum_test.nim</a>
* :heavy_check_mark: <a href="verify/test/nim/segt_point_set_range_composite_test.nim.html">test/nim/segt_point_set_range_composite_test.nim</a>
* :heavy_check_mark: <a href="verify/test/nim/unionfind_test.nim.html">test/nim/unionfind_test.nim</a>

