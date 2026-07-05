template <typename T>
class formal_power_series {
  std::vector<T> v;

  using fps = formal_power_series;

 public:
  using value_type = T;
  using reference = T&;
  using const_reference = const T&;
  using iterator = typename std::vector<T>::iterator;
  using const_iterator = typename std::vector<T>::const_iterator;

  size_t size() const { return v.size(); }

  std::vector<T>& data() { return v; }
  const std::vector<T>& data() const { return v; }

  formal_power_series() {}

  explicit formal_power_series(int n) : v(n) {}
  formal_power_series(int n, T val) : v(n, val) {}

  formal_power_series(const std::vector<T>& v) : v(v) {}
  formal_power_series(std::vector<T>&& v) : v(v) {}

  template <class InputIterator>
  formal_power_series(InputIterator first, InputIterator last)
      : v(first, last) {}

  formal_power_series(std::initializer_list<T> init) : v(init) {}

  inline void resize(int n) { v.resize(n); }

  inline T& operator[](int i) { return v[i]; }

  inline iterator begin() { return v.begin(); }
  inline const_iterator begin() const { return v.begin(); }

  inline iterator end() { return v.end(); }
  inline const_iterator end() const { return v.end(); }

  fps take(int n) const {
    fps res(v.begin(), v.begin() + std::min(n, (int)v.size()));
    res.resize(n);
    return res;
  }

  fps diff() const {
    std::vector<T> res(v.size() - 1);
    for (int i = 0; i < res.size(); i++) res[i] = v[i + 1] * (i + 1);
    return fps(res);
  }

  fps integral() const {
    std::vector<T> res(v.size() + 1);
    for (int i = 0; i < v.size(); i++) res[i + 1] = v[i] / (i + 1);
    return fps(res);
  }

  fps inv(int deg = -1) const {
    assert(v[0] != 0);

    if (deg == -1) deg = size();
    std::vector<T> res(deg);

    res[0] = v[0].inv();

    T inv4 = T(4).inv(), invd = inv4;

    for (int d = 1; d < deg; d <<= 1) {
      std::vector<T> f(2 * d), g(2 * d);

      std::copy(v.begin(), v.begin() + std::min(2 * d, (int)v.size()),
                f.begin());
      std::copy(res.begin(), res.begin() + d, g.begin());

      atcoder::internal::butterfly(f);
      atcoder::internal::butterfly(g);

      for (int i = 0; i < 2 * d; i++) f[i] *= g[i];

      atcoder::internal::butterfly_inv(f);

      for (int i = 0; i < d; i++) f[i] = 0;

      atcoder::internal::butterfly(f);

      for (int i = 0; i < 2 * d; i++) f[i] *= g[i];

      atcoder::internal::butterfly_inv(f);

      for (int i = d; i < std::min(2 * d, deg); i++) res[i] = -f[i] * invd;

      invd *= inv4;
    }

    return res;
  }

  fps log(int deg = -1) const {
    assert(v[0] == 1);

    if (deg == -1) deg = size();

    return (this->diff() * this->inv(deg)).take(deg - 1).integral();
  }

  fps exp(int deg = -1) const {
    assert(v[0] == 0);

    if (deg == -1) deg = size();

    fps g = {1};

    for (int d = 1; d < deg; d <<= 1) {
      fps tmp = -g.log(2 * d);
      tmp += 1;
      tmp.trunc_add(*this);

      g *= tmp;

      g.resize(2 * d);
    }

    g.resize(deg);

    return g;
  }

  fps pow(ll n, int deg = -1) const {
    if (deg == -1) deg = size();

    if (n == 0) return fps({1}).take(deg);
    if (n == 1) return this->take(deg);

    for (int i = 0; i < v.size(); i++) {
      if (ll(i) * n >= deg) {
        break;
      }
      if (v[i] != 0) {
        fps res(begin() + i, end());
        res /= v[i];
        res = (res.log(deg) * n).exp(deg);
        res *= v[i].pow(n);
        res.v.insert(res.v.begin(), i * n, 0);
        res.resize(deg);
        return res;
      }
    }

    return fps(deg);
  }

  fps shift(T c) const {
    std::vector<T> res(size()), ifacts(size());

    factorials<T>::extend(size());

    T x = 1;

    for (int i = 0; i < size(); i++) {
      ifacts[i] = x * factorials<T>::inv(i);
      x *= c;
    }

    for (int i = 0; i < size(); i++) {
      res[size() - 1 - i] = v[i] * factorials<T>::get(i);
    }

    res = atcoder::convolution(res, ifacts);

    res.resize(size());

    std::ranges::reverse(res);

    for (int i = 0; i < size(); i++) {
      res[i] *= factorials<T>::inv(i);
    }

    return res;
  }

  fps& trunc_add(const fps& rhs) {
    for (int i = 0; i < v.size() && i < rhs.size(); i++) v[i] += rhs.v[i];
    return *this;
  }

  fps operator-() const {
    fps res(v.size());
    for (int i = 0; i < v.size(); i++) res[i] = -v[i];
    return res;
  }

  fps& operator+=(const fps& rhs) {
    if (v.size() < rhs.v.size()) v.resize(rhs.v.size());
    for (int i = 0; i < rhs.v.size(); i++) v[i] += rhs.v[i];
    return *this;
  }

  fps& operator-=(const fps& rhs) {
    if (v.size() < rhs.v.size()) v.resize(rhs.v.size());
    for (int i = 0; i < rhs.v.size(); i++) v[i] -= rhs.v[i];
    return *this;
  }

  fps& operator*=(const fps& rhs) {
    return *this = atcoder::convolution(v, rhs.v);
  }

  fps& operator/=(const fps& rhs) { return *this *= rhs.inv(); }

  fps& operator+=(const T& rhs) {
    if (v.size() == 0) v.resize(1);
    v[0] += rhs;
    return *this;
  }

  fps& operator-=(const T& rhs) {
    if (v.size() == 0) v.resize(1);
    v[0] -= rhs;
    return *this;
  }

  fps& operator*=(const T& rhs) {
    for (int i = 0; i < v.size(); i++) v[i] *= rhs;
    return *this;
  }

  fps& operator/=(const T& rhs) {
    T rhs_inv = rhs.inv();
    for (int i = 0; i < v.size(); i++) v[i] *= rhs_inv;
    return *this;
  }

  friend fps operator+(const fps& lhs, const fps& rhs) {
    return fps(lhs) += rhs;
  }

  friend fps operator-(const fps& lhs, const fps& rhs) {
    return fps(lhs) -= rhs;
  }

  friend fps operator*(const fps& lhs, const fps& rhs) {
    return fps(lhs) *= rhs;
  }

  friend fps operator/(const fps& lhs, const fps& rhs) {
    return fps(lhs) /= rhs;
  }

  friend fps operator+(const fps& lhs, const T& rhs) { return fps(lhs) += rhs; }

  friend fps operator-(const fps& lhs, const T& rhs) { return fps(lhs) -= rhs; }

  friend fps operator*(const fps& lhs, const T& rhs) { return fps(lhs) *= rhs; }

  friend fps operator/(const fps& lhs, const T& rhs) { return fps(lhs) /= rhs; }

  friend fps operator+(const T& lhs, const fps& rhs) { return fps(rhs) += lhs; }

  friend fps operator-(const T& lhs, const fps& rhs) {
    return -(fps(rhs) -= lhs);
  }

  friend fps operator*(const T& lhs, const fps& rhs) { return fps(rhs) *= lhs; }
};

template <typename T>
T bostan_mori(ll n, formal_power_series<T> P, formal_power_series<T> Q) {
  assert(P.size() < Q.size());

  P.resize(Q.size() - 1);

  while (n) {
    formal_power_series<mint> qm = Q;
    for (int i = 1; i < Q.size(); i += 2) qm[i] = -qm[i];

    formal_power_series<mint> U = P * qm;
    formal_power_series<mint> V = Q * qm;

    for (int i = n & 1; i < U.size(); i += 2) P[i / 2] = U[i];
    for (int i = 0; i < V.size(); i += 2) Q[i / 2] = V[i];

    n /= 2;
  }

  return P[0] / Q[0];
}
