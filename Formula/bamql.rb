class Bamql < Formula
  desc "Query language for filtering SAM/BAM reads"
  homepage "https://labs.oicr.on.ca/boutros-lab/software/BAMQL"
  url "https://github.com/BoutrosLaboratory/bamql/archive/v1.4.tar.gz"
  sha256 "92d1c88811d4d90df7864d2c3493d3378534c74a581378aeb352dd37365c5d09"
  head "https://github.com/BoutrosLaboratory/bamql.git"

  depends_on "autoconf"   => :build
  depends_on "automake"   => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build

  depends_on "htslib"
  depends_on "llvm@4"
  depends_on OS.mac? ? "ossp-uuid" : "util-linux" # for libuuid
  depends_on "pcre"
  depends_on "xz"
  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    system "autoreconf", "-i"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-llvm=#{Formula["llvm@4"].prefix}/bin/llvm-config"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bamql -h 2>&1")
  end
end
