class StarAligner < Formula
  # cite Dobin_2012: "https://doi.org/10.1093/bioinformatics/bts635"
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/refs/tags/2.7.10a_alpha_220818.tar.gz"
  version "2.7.10a+220818"
  sha256 "0df439b1623ff9b4f51887cbcbf524127eaf7ac3cc8d06ce6564d5ff957e8dab"
  license "MIT"
  head "https://github.com/alexdobin/STAR.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "d4a0361a3d5cc993b0fe1944ace244108be668cb32640e04ac1606c1bbec97fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "570c4c40b3b9068af98763e6f1bc1c9da3ea77a0787caf005cb29a8b14b0a34c"
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  # https://github.com/alexdobin/STAR/issues/1408
  patch :DATA

  def install
    cd "source" do
      if OS.mac?
        inreplace "Makefile", "-static-libgcc", ""
        system "make", "STARforMacStatic", "STARlongForMacStatic"
      else
        system "make", "STAR", "STARlong"
      end
      bin.install "STAR", "STARlong"
    end
    doc.install "doc/STARmanual.pdf"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/STAR --help")
    assert_match "Usage:", shell_output("#{bin}/STARlong --help")
  end
end
__END__
diff --git a/source/opal/opal.cpp b/source/opal/opal.cpp
index d1b0298..25429bc 100644
--- a/source/opal/opal.cpp
+++ b/source/opal/opal.cpp
@@ -5,10 +5,8 @@
 #include <limits>
 #include <vector>
 
-extern "C" {
 #define SIMDE_ENABLE_NATIVE_ALIASES
 #include <simde_avx2.h> // AVX2 and lower
-}
 
 #include "opal.h"
 
diff --git a/source/Makefile b/source/Makefile
index 15b7697..9eac611 100644
--- a/source/Makefile
+++ b/source/Makefile
@@ -18,7 +18,7 @@ LDFLAGS_Mac :=-pthread -lz htslib/libhts.a
 LDFLAGS_Mac_static :=-pthread -lz -static-libgcc htslib/libhts.a
 LDFLAGS_gdb := $(LDFLAGS_shared)
 
-DATE_FMT = --iso-8601=seconds
+DATE_FMT = -Iseconds
 ifdef SOURCE_DATE_EPOCH
     BUILD_DATE ?= $(shell date -u -d "@$(SOURCE_DATE_EPOCH)" "$(DATE_FMT)" 2>/dev/null || date -u -r "$(SOURCE_DATE_EPOCH)" "$(DATE_FMT)" 2>/dev/null || date -u "$(DATE_FMT)")
 else
