class Plink2 < Formula
  # cite Chang_2015: "https://doi.org/10.1186/s13742-015-0047-8"
  desc "Analyze genotype and phenotype data"
  homepage "https://www.cog-genomics.org/plink2"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.00a5.12.tar.gz"
  version "2.00a5.12"
  sha256 "bf55f172c709265c9c7bf1518bb4f0036d28fecdd7b17f8db7f9d106586bb3f5"
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "ea7c863dafde5bc757b6db986e81b01f730eafa0e698204ad625c9d0e9bf7f62"
    sha256 cellar: :any,                 ventura:      "96b1711ed2eedb7d3b2daa023f5956f6772b321ff5b36cdb93cc3503f528e67b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9512c33fd71a714cc054dfe9ece9692cb417176683ba62802e3c3bea65b1f355"
  end

  depends_on "openblas"
  depends_on "zstd"
  uses_from_macos "zlib"

  def install
    cd "1.9" do
      if OS.linux?
        inreplace "Makefile" do |s|
          s.gsub! "-L/usr/lib64/atlas -llapack -lblas -lcblas -latlas",
                  "-L#{Formula["openblas"].opt_lib} -lopenblas"
          s.gsub! "ZLIB ?=		-L. ../zlib-1.3/libz.so.1.3", "ZLIB ?= -lz"
          s.gsub! "-Wall -O2 -g -I../2.0/simde",
                  "-Wall -O2 -g -I../2.0/simde -I#{Formula["openblas"].opt_include}"
        end
      end
      system "./plink_first_compile"
      bin.install "plink"
    end
    cd "2.0" do
      inreplace "build.sh", " -llapack -lcblas -lblas", "-L#{Formula["openblas"].opt_lib} -lopenblas" if OS.linux?
      system "./build.sh"
      bin.install "bin/plink2" => "plink2"
      bin.install "bin/pgen_compress" => "pgen_compress"
    end
  end

  test do
    system "#{bin}/plink2", "--dummy", "513", "1423", "0.02", "--out", "dummy_cc1"
    assert_predicate testpath/"dummy_cc1.pvar", :exist?
  end
end
