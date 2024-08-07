class Freebayes < Formula
  # cite Garrison_2012: "https://arxiv.org/abs/1207.3907v2"
  desc "Bayesian variant discovery and genotyping"
  homepage "https://github.com/ekg/freebayes"
  url "https://github.com/ekg/freebayes.git",
      tag:      "v1.3.6",
      revision: "084dce52e54af5adbd1e2b0a67f3733dd8bfddc0"
  license "MIT"
  head "https://github.com/ekg/freebayes.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "f30e08110945d50f49909d61fec86ec45f8efadf52c0a460b0cfe658df8fe3d0"
    sha256               x86_64_linux: "a4454368c4a8bb579a75b01f1c6ed2d192727824048d31fe175c0c734080368a"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "parallel"
  depends_on "python@3.12"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  patch :DATA
  def install
    # Fix compilation error with c++17
    inreplace ["contrib/SeqLib/SeqLib/GenomicRegionCollection.cpp",
               "contrib/vcflib/contrib/intervaltree/catch.hpp",
               "contrib/vcflib/src/pVst.cpp"], "std::random_shuffle", "std::shuffle"

    system "meson", *std_meson_args, "build/", "--prefix=#{prefix}"
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end

    bin.install "scripts/freebayes-parallel"

    rm "scripts/bgziptabix"
    rm "scripts/vcffirstheader"
    rm "scripts/update_version.sh"
    pkgshare.install Dir["scripts/*"]
  end

  def caveats
    <<~EOS
      The freebayes scripts can be found in
      #{HOMEBREW_PREFIX}/share/freebayes/
    EOS
  end

  test do
    assert_match "polymorphism", shell_output("#{bin}/freebayes --help 2>&1")
    assert_match "chunks", shell_output("#{bin}/freebayes-parallel 2>&1")
  end
end
__END__
diff --git a/contrib/vcflib/src/Variant.h b/contrib/vcflib/src/Variant.h
index 0b44039..a7e145b 100644
--- a/contrib/vcflib/src/Variant.h
+++ b/contrib/vcflib/src/Variant.h
@@ -647,12 +647,13 @@ private:
      * the maps we're going to be using will be case-insensitive
      * so that "fileFormat" and "fileformat" hash to the same item.
      */
-    struct stringcasecmp : binary_function<string, string, bool> {
-        struct charcasecmp : public std::binary_function<unsigned char, unsigned char, bool> {
+    struct stringcasecmp {
+        struct charcasecmp {
             bool operator() (const unsigned char& c1, const unsigned char& c2) const {
-                return tolower (c1) < tolower (c2);
+                return std::tolower(c1) < std::tolower(c2);
             }
         };
+
         bool operator() (const std::string & s1, const std::string & s2) const {
             return std::lexicographical_compare(s1.begin(), s1.end(), s2.begin(), s2.end(), charcasecmp());
         }
