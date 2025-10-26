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
    sha256 cellar: :any,                 arm64_sequoia: "661e3f96ccd8f9383b2bdd05bcd30120718310e65b726de949a1210acda33297"
    sha256 cellar: :any,                 arm64_sonoma:  "6c96d97546ef63d4f884bad342cb663d2d41258de53e19d16c423821aa8ec5ae"
    sha256 cellar: :any,                 ventura:       "2cf9df857f2f43108a4936a4913abf8c06b55bfc96632f478f08f268c4a6dbc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5494f3d9e0e2792332a33a8bc246832bf3078afeea0ce3bf0505e26bddc8e0fe"
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
