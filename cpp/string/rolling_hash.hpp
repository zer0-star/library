class rolling_hash {
  using u128 = __uint128_t;

  std::vector<ull> data;

  static std::vector<ull> base_pow;

  static const ull BASE;
  static constexpr ull MOD = (1UL << 61) - 1;

  static inline ull mod(ull x) {
    ull t = (x >> 61) + (x & MOD);
    if (t >= MOD) t -= MOD;
    return t;
  }

  static inline ull mod_fma(ull a, ull b, ull c) {
    u128 x = u128(a) * b + c;
    ull t = ull(x >> 61) + (ull(x) & MOD);
    if (t >= MOD) t -= MOD;
    return t;
  }

  static inline ull mod_mul(ull a, ull b) { return mod_fma(a, b, 0); }

 public:
  rolling_hash() {}

  rolling_hash(const std::string& s)
      : rolling_hash(s.begin(), s.end(), s.size()) {}
  template <class T>
  rolling_hash(const std::vector<T>& s)
      : rolling_hash(s.begin(), s.end(), s.size()) {}

  template <std::input_iterator I>
  rolling_hash(I begin, I end, size_t len = 0) : data({0}) {
    data.reserve(len + 1);

    while (begin != end) {
      data.emplace_back(mod_fma(data.back(), BASE, *begin));
      begin++;
    }

    base_pow.reserve(data.size());

    while (base_pow.size() < data.size()) {
      base_pow.emplace_back(mod_mul(base_pow.back(), BASE));
    }
  }

  ull get(int l, int r) const {
    return mod_fma(data[l], MOD - base_pow[r - l], data[r]);
  }
};

const ull rolling_hash::BASE =
    std::uniform_int_distribution(2ULL, 1ULL << 60)(rng);
std::vector<ull> rolling_hash::base_pow = {1};