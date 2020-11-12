class Skesa < Formula
  # cite Souvorov_2018: "https://doi.org/10.1186/s13059-018-1540-z"
  desc "Strategic Kmer Extension for Scrupulous Assemblies"
  homepage "https://github.com/ncbi/SKESA"
  url "https://github.com/ncbi/SKESA/archive/2.4.0.tar.gz"
  sha256 "c07b56dfa394c013e519d5a246b7dee03db41d8ac912ab9ca02cf4d20bf13b15"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "6da28be7b7ca7600d5d900094fd1d5d41bf3b376a8b24121912e2256f8115319" => :catalina
    sha256 "bc2b4247e6b192d5c0ddf318d24f62a12ed7a4fd4597b403abfc5183090c4dd1" => :x86_64_linux
  end

  depends_on "boost"

  uses_from_macos "zlib"

  # Remove in next release (2.4.1)
  patch do
    url "https://github.com/ncbi/SKESA/commit/6e8a445b81555f26fd50abf10e78ced5ab91a11b.patch?full_index=1"
    sha256 "4dad784d0f1f6e2a8531e40256376d8d4b0fe4cd08bc1e31672f0ff2875e954a"
  end

  # Remove in next release (2.4.1)
  patch do
    url "https://github.com/ncbi/SKESA/commit/a38f80bee5d932f6ffa005c6a67dae3885a6c10b.patch?full_index=1"
    sha256 "c6e36295813f8dbdf50bf1aa9eadd8ef374efe43c16f6b76a02d9110eda5d158"
  end

  # Fixes error: constructor cannot be redeclared in Integer.hpp
  patch :DATA if OS.mac?

  def install
    system "make", "-f", "Makefile.nongs",
      "BOOST_PATH=#{Formula["boost"].opt_prefix}"
    bin.install "skesa", "gfa_connector", "kmercounter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skesa --version 2>&1")
  end
end
__END__
diff --git a/Integer.hpp b/Integer.hpp
index ffe6af1..bdc2af8 100644
--- a/Integer.hpp
+++ b/Integer.hpp
@@ -117,13 +117,6 @@ public:
             *this = *this + (std::find(bin2NT.begin(), bin2NT.end(), *i) - bin2NT.begin());
         }
     }
-    IntegerTemplate(std::vector<char>::const_iterator begin, std::vector<char>::const_iterator end) : IntegerTemplate(end-begin, 0)  {
-        for(auto i = begin; i != end; ++i) {
-            *this = (*this) << 2;
-            *this = *this + (std::find(bin2NT.begin(), bin2NT.end(), *i) - bin2NT.begin());
-        }
-    }
-    
 
     /**Construct from a different size IntegerTemplate
        Will clip (or add) extra nucs on the LEFT of the string
