class Sga < Formula
  # cite Simpson_2011: "https://doi.org/10.1101/gr.126953.111"
  desc "De novo genome assembler based on the concept of string graphs"
  homepage "https://github.com/jts/sga"
  url "https://github.com/jts/sga/archive/refs/tags/v0.10.15.tar.gz"
  sha256 "1b18996e6ec47985bc4889a8cbc3cd4dd3a8c7d385ae9f450bd474e36342558b"
  revision 1
  head "https://github.com/jts/sga.git"

  livecheck do
    url :stable
    # The repo publishes no GitHub releases, only vX.Y.Z tags.
    strategy :git
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 sierra:       "c557433d9f39a90ecdcc0eaccae50f590d1913d79faa23ed5625329ac61c348c"
    sha256 x86_64_linux: "7caa32dd5ce43febeffa62f307d35988eaee298b133c3e6f8948a703fa3194e1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "google-sparsehash" => :build
  depends_on "bamtools"

  uses_from_macos "zlib"

  # Fix error: call to 'abs' is ambiguous
  # https://github.com/jts/sga/pull/148
  patch do
    url "https://github.com/jts/sga/commit/ff74c3ee8120eff911e004d09c2fd14142c0fe75.patch?full_index=1"
    sha256 "257de28dec7c8fdfa8029bff0b14fc336f39a40984f8e7fc85903099d64887f0"
  end

  def install
    cd "src" do
      # Modern google-sparsehash requires C++11; sga hardcodes -std=c++98, under
      # which sparse_hash_map's iterator fails to compile on gcc 16 ("base
      # operand of '->' is not a pointer"). Build as C++11 instead.
      inreplace "configure.ac", "-std=c++98", "-std=c++11"
      system "./autogen.sh"
      # sga probes google/sparse_hash_{set,map} and api/BamReader.h with
      # AC_CHECK_HEADERS, which uses the C compiler; all are C++-only headers
      # (they include <algorithm>), so the probes fail even though the paths are
      # correct. In particular the failing sparse_hash_map probe leaves
      # HAVE_GOOGLE_SPARSE_HASH_MAP undefined, tripping HashMap.h's `#error The
      # google sparse hash is required`. Prime the cache vars so the (correct)
      # C++ build, which does find them, proceeds.
      system "./configure",
        "--disable-dependency-tracking",
        "--prefix=#{prefix}",
        "--with-bamtools=#{Formula["bamtools"].prefix}",
        "--with-sparsehash=#{Formula["google-sparsehash"].prefix}",
        "ac_cv_header_google_sparse_hash_set=yes",
        "ac_cv_header_google_sparse_hash_map=yes",
        "ac_cv_header_api_BamReader_h=yes"
      system "make", "install"
      bin.install Dir["bin/*"] - Dir["bin/Makefile*"]
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/sga --help")
  end
end
