
template <class Key, class Tp, class Compare = std::less<Key>>
class fibonacci_heap {
 public:
  using key_type = Key;
  using mapped_type = Tp;
  using key_compare = Compare;
  using value_type = std::pair<key_type, mapped_type>;
  using reference = value_type &;
  using const_reference = value_type const &;

  class node_handle;

 private:
  class node;

  using pointer = std::shared_ptr<node>;

  class node {
    friend fibonacci_heap;
    friend node_handle;

    value_type value;
    pointer parent{nullptr}, left{nullptr}, right{nullptr}, child{nullptr};
    bool damaged = false;
    int rank = 0;

   public:
    node(const key_type &key, const mapped_type &data) : value(key, data) {}

    const key_type &key() const { return value.first; }
    const mapped_type &data() const { return value.second; }
  };

  std::list<pointer> roots;

  pointer top_;

  key_compare cmp = key_compare();

  std::size_t size_;

  static void add_child(pointer parent, pointer child) {
    parent->rank++;

    child->parent = parent;

    if (!parent->child) {
      parent->child = child;
    } else if (!parent->child->left) {
      parent->child->left = parent->child->right = child;
      child->left = child->right = parent->child;
    } else {
      child->left = parent->child->left;
      child->right = parent->child;
      parent->child->left->right = child;
      parent->child->left = child;
    }
  }

  void detach_child(pointer parent, pointer child) {
    bool cont = true;
    while (cont && parent) {
      cont = parent->damaged;

      if (parent->child == child) {
        parent->child = child->right;
      }

      if (child->left) {
        if (child->left == child->right) {
          child->right->left = child->right->right = nullptr;
        } else {
          child->right->left = child->left;
          child->left->right = child->right;
        }
      }

      child->parent = child->left = child->right = nullptr;
      child->damaged = false;

      roots.push_back(child);

      if (parent->parent) {
        parent->damaged = true;
      }

      child = parent;
      parent = parent->parent;
    }
  }

 public:
  fibonacci_heap() : size_(0), top_(nullptr) {}

  const_reference top() const { return top_->value; }
  void pop() {
    pointer tmp = top_;

    for (auto it = roots.begin(); it != roots.end(); it++) {
      if (*it == tmp) {
        roots.erase(it);
        break;
      }
    }

    if (tmp->child) {
      pointer cur = tmp->child;

      do {
        pointer next = cur->right;
        cur->right = cur->left = cur->parent = nullptr;
        cur->damaged = false;
        roots.push_back(cur);
        cur = next;
      } while (cur && cur != tmp->child);
      tmp->child = nullptr;
    }

    size_--;

    if (size_ == 0) {
      roots.clear();
      top_ = nullptr;
      return;
    }

    std::size_t size2 = 0;
    for (auto r : roots) {
      size2 += 1UL << r->rank;
    }

    std::vector<pointer> rs(64 - __builtin_clzll(size2));

    for (auto r : roots) {
      int i = r->rank;
      while (rs[i]) {
        if (cmp(r->key(), rs[i]->key())) std::swap(r, rs[i]);
        add_child(r, rs[i]);
        rs[i] = nullptr;
        i++;
      }
      rs[i] = r;
    }

    roots.clear();

    for (auto r : rs) {
      if (r) roots.push_back(r);
    }

    top_ = *roots.begin();
    for (auto r : roots) {
      if (cmp(top_->key(), r->key())) top_ = r;
    }
  }

  const node_handle push(const key_type &key, const mapped_type &data) {
    pointer new_node = std::make_shared<node>(key, data);

    size_++;

    roots.push_back(new_node);

    if (!top_ || cmp(top_->key(), key)) top_ = new_node;

    return node_handle(new_node);
  }

  void prioritize(const node_handle &handle, const key_type &k) {
    pointer ptr(handle.inner);

    assert(cmp(ptr->key(), k));

    ptr->value.first = k;

    if (ptr->parent && cmp(ptr->parent->key(), k))
      detach_child(ptr->parent, ptr);
  }

  const std::size_t size() const { return size_; }
  const bool empty() const { return size_ == 0; }

  class node_handle {
    friend fibonacci_heap;

    using pointer = std::weak_ptr<node>;

    pointer inner;

   public:
    node_handle() = default;
    node_handle(pointer node) : inner(node) {}

    const key_type &key() const { return inner->key(); }
    const mapped_type &data() const { return inner->data(); }

    explicit operator bool() const { return !inner.expired(); }
  };
};