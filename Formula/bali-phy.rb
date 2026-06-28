class BaliPhy < Formula
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  # cite Redelings_2021: "https://doi.org/10.1093/bioinformatics/btab129"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "https://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy.git",
    tag:      "4.2",
    revision: "c1f6e56e17ab399b73e74188c1a475e90909cdfd"
  license "GPL-2.0-or-later"
  head "https://github.com/bredelings/BAli-Phy.git", branch: "master"

  #  livecheck do
  #    url :stable
  #    strategy :github_latest
  #  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "ade38c42564fa5aafcb02a0f45ba58be5152fed0053e3d93a03d6e733cfffe35"
    sha256 cellar: :any, arm64_sequoia: "20e7a82d254fe8d58e490f7b2f56e54f254ba149613a131cf40b40191ae1fa11"
    sha256 cellar: :any, arm64_sonoma:  "154ecfddd30db92ebe10b52ad06dd22ddc4d9a50467fff81f1c525bd5e7eba80"
    sha256 cellar: :any, x86_64_linux:  "222265e830fd8473210c3a7bbc60654e015625ff9738d91cd3d1b60591927345"
  end

  depends_on "cereal" => :build
  depends_on "eigen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "range-v3" => :build

  depends_on "boost"
  depends_on "cairo"
  depends_on "fmt"
  depends_on "gcc" unless OS.mac? # for C++20

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20 support"
  end

  # Use fmt/format.h instead of fmt/core.h. Since fmt 11, fmt/core.h no longer
  # declares fmt::format unless FMT_DEPRECATED_HEAVY_CORE is defined, which
  # breaks the build against the current fmt (12.x). Reported upstream-compatible
  # fix: include the full format header where fmt::format is used.
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500
    ENV["CXX"] = formula_opt_bin("llvm")/"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1500
    ENV["BOOST_ROOT"] = formula_opt_prefix("boost")

    flags = %w[install -C build]
    system "meson", "setup", "build", "--prefix=#{prefix}", "--buildtype=release", "-Db_ndebug=true"
    system "meson", *flags
  end

  test do
    system "#{bin}/bali-phy", "--version"
    system "#{bin}/bali-phy", "#{doc}/examples/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze", "5d-1"
  end
end

__END__
diff --git a/src/computation/haskell/literal.cc b/src/computation/haskell/literal.cc
index bf5940b..4658c00 100644
--- a/src/computation/haskell/literal.cc
+++ b/src/computation/haskell/literal.cc
@@ -2,7 +2,7 @@
 #include "util/string/join.H"
 #include "util/string/convert.H"
 #include <regex>
-#include "fmt/core.h"
+#include "fmt/format.h"

 using std::string;
 using std::optional;
diff --git a/src/util/include/util/ptree.H b/src/util/include/util/ptree.H
index 7fc6c09..cd71c45 100644
--- a/src/util/include/util/ptree.H
+++ b/src/util/include/util/ptree.H
@@ -159,4 +159,9 @@ inline ptree array_index(const ptree& p, int i)
 
 std::ostream& operator<<(std::ostream& o, const ptree::value_t& v);
 
+// ptree derives from std::vector, whose C++20 operator<=> recurses on ptree
+// itself under libc++. Provide an explicit operator< (defined with named
+// recursion, never infix ptree<ptree) to break that recursion.
+bool operator<(const ptree& a, const ptree& b);
+
 #endif
diff --git a/src/util/ptree.cc b/src/util/ptree.cc
index a73ed37..1a84e8d 100644
--- a/src/util/ptree.cc
+++ b/src/util/ptree.cc
@@ -11,6 +11,24 @@ using std::optional;
 
 std::ostream& operator<<(std::ostream& o,const monostate&) {o<<"()";return o;}
 
+static bool ptree_lt(const ptree& a, const ptree& b)
+{
+    if (a.value < b.value) return true;
+    if (b.value < a.value) return false;
+    if (a.size() < b.size()) return true;
+    if (b.size() < a.size()) return false;
+    for(auto it1 = a.begin(), it2 = b.begin(); it1 != a.end(); ++it1, ++it2)
+    {
+        if (it1->first < it2->first) return true;
+        if (it2->first < it1->first) return false;
+        if (ptree_lt(it1->second, it2->second)) return true;
+        if (ptree_lt(it2->second, it1->second)) return false;
+    }
+    return false;
+}
+
+bool operator<(const ptree& a, const ptree& b) { return ptree_lt(a, b); }
+
 bool ptree::value_is_empty() const
 {
     return value.index() == 0;
