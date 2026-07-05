class color_interval {
  std::map<ll, ll> map;

 public:
  color_interval() { map[std::numeric_limits<ll>::min()] = 0; }

  ll get(ll x) const { return prev(map.upper_bound(x))->second; }

  void set(ll l, ll r, ll c) {
    if (l >= r) return;

    map[r] = get(r);

    for (auto it = map.lower_bound(l); it->first != r; it = map.erase(it));

    auto it = map.emplace(l, c).first, it2 = next(it);

    if (it->second == it2->second) {
      map.erase(it2);
    }
    if (it->second == prev(it)->second) {
      map.erase(it);
    }
  }

  void set(ll x, ll c) { set(x, x + 1, c); }

  /// `x`以上の点のうち`c`以外の色で塗られた最小のもの
  ll lower_bound_neq(ll x, ll c) const {
    auto it = map.upper_bound(x), it2 = prev(it);

    if (it2->second == c) {
      return it->first;
    } else {
      return x;
    }
  }

  bool same(ll x, ll y) const {
    return map.upper_bound(x) == map.upper_bound(y);
  }

  /// 区間`[l, r)`を包含するような単一の区間が存在するか否か
  bool covered(ll l, ll r) const {
    auto it = map.upper_bound(l);

    return it == map.end() or r <= it->first;
  }

  std::pair<ll, ll> covering_range(ll x) const {
    auto it = map.upper_bound(x);

    ll r = it == map.end() ? std::numeric_limits<ll>::max() : it->first;
    ll l = prev(it)->first;

    return {l, r};
  }

  void dump(std::ostream& os = std::cerr) const {
    std::print(os, " --(0)-- ");

    for (auto it = next(map.begin()); it != map.end(); it++) {
      std::print(os, "{} -({})- ", it->first, it->second);
    }

    std::println(os);
  }
};
