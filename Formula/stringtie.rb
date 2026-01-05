class Stringtie < Formula
  # cite Pertea_2015: "https://doi.org/10.1038/nbt.3122"
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://ccb.jhu.edu/software/stringtie/"
  url "https://github.com/gpertea/stringtie/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "8fc429eb7437cb62cd95440a3e28529719cc72133592ce8e02f5cf249ce3142e"
  license "MIT"
  head "https://github.com/gpertea/stringtie.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_tahoe:   "35824801c9ba307b41e721fc1c8c89d3349937580579c947f5017496a51e5f7d"
    sha256 cellar: :any,                 arm64_sequoia: "f00184a5fea953f41305a0de880766f4b1476d869b4c8d7d223920b8b881ba68"
    sha256 cellar: :any,                 arm64_sonoma:  "a11b204ba46798048daf88607cf63e77e9df3a6aa0c36038d1ecacb433f119a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5a1f0cf613c35bb9c9840ab1ba66b1423e2f7e0d9b02ecc877175fa748037bd"
  end

  depends_on "htslib"
  depends_on "libdeflate"
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
