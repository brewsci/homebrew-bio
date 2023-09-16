class StarAligner < Formula
  # cite Dobin_2012: "https://doi.org/10.1093/bioinformatics/bts635"
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/refs/tags/2.7.10a_alpha_220818.tar.gz"
  version "2.7.10"
  sha256 "0df439b1623ff9b4f51887cbcbf524127eaf7ac3cc8d06ce6564d5ff957e8dab"
  license "MIT"
  head "https://github.com/alexdobin/STAR.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, big_sur:      "3f2c5f07695b96f91d70165232c6b3011e7b1d7cdd9684e67214a11bfea9f9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aff1dc125eb4d50961b110519420cf840c603cf29f2aa58a21aee1427d1f3799"
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
