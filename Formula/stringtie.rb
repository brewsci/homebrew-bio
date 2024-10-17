class Stringtie < Formula
  # cite Pertea_2015: "https://doi.org/10.1038/nbt.3122"
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://ccb.jhu.edu/software/stringtie/"
  url "https://github.com/gpertea/stringtie/releases/download/v2.2.3/stringtie-2.2.3.tar.gz"
  sha256 "f372640b70a8fde763712d2f0565aff71f5facdc2300c8af829fea94a05ff208"
  license "MIT"
  head "https://github.com/gpertea/stringtie.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b30f2f061f36ea355f8a579d0ac171304ddf89225c5f198c7c1ed293e2a3ddad"
    sha256 cellar: :any,                 arm64_sonoma:  "fb42c05cf1812d2320a283b01e530dd285b888bad17dee8aead039ccf08ce5da"
    sha256 cellar: :any,                 ventura:       "39bf1edf0bb309c1fd5e71be765ba7a140fe7c3c3e7f7d34a27956e43f8064da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c16d903fe021faf8b8ab0ef1a3c9bfa0145986c0093a7fad9482d2de1ad5e69"
  end

  depends_on "htslib"
  depends_on "libdeflate" # for libdeflate
  depends_on "xz" # for liblzma

  uses_from_macos "zlib"

  def install
    # Use Homebrew's htslib
    rm_r "htslib"
    inreplace "Makefile" do |s|
      s.gsub! "HTSLIB  := ./htslib", "HTSLIB  := #{Formula["htslib"].opt_prefix}"
      s.gsub! "LIBDEFLATE := ${HTSLIB}/xlibs/lib/libdeflate.a",
              "LIBDEFLATE := -L#{Formula["libdeflate"].opt_lib}/libdeflate.a"
      s.gsub! "LIBLZMA := ${HTSLIB}/xlibs/lib/liblzma.a", "LIBLZMA := -L#{Formula["xz"].opt_lib}/liblzma.a"
      s.gsub! "LIBS    := ${HTSLIB}/libhts.a", "LIBS    := -L#{Formula["htslib"].opt_lib}/libhts.a"
      s.gsub! "${HTSLIB}/xlibs/lib/libbz2.a", "-lbz2"
      s.gsub! "-I${HTSLIB}", "-I${HTSLIB}/include"
      s.gsub! "${HTSLIB}/libhts.a:\n	cd ${HTSLIB} && ./build_lib.sh", ""
      s.gsub! "${HTSLIB}/libhts.a", "${HTSLIB}/lib/libhts.a"
      s.gsub! "$^} ${LIBS}", "$^} ${LIBS} -lhts -I${HTSLIB}/include"
    end

    system "make", "release"
    bin.install "stringtie"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/gpertea/stringtie/raw/test_data/tests.tar.gz"
      sha256 "815a31b2664166faa59cdd25f0dc2da3d3dcb13e69ee644abb972a93d374ac10"
    end
    resource("homebrew-testdata").stage testpath
    assert_match version.to_s, shell_output("#{bin}/stringtie --version")
    assert_match "transcript\t784986\t788300", shell_output("#{bin}/stringtie short_reads.bam")
  end
end
