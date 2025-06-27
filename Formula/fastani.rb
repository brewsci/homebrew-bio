class Fastani < Formula
  # cite Jain_2017: "https://doi.org/10.1101/225342"
  desc "Fast Whole-Genome Similarity (ANI) Estimation"
  homepage "https://github.com/ParBLiSS/FastANI"
  url "https://github.com/ParBLiSS/FastANI/archive/v1.32.tar.gz"
  sha256 "f66b3bb5b272aa3db4deae782e47020fa9aae63eecbbd6fd93df876237d3b2e5"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ParBLiSS/FastANI.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "8a87f5ac2d028d5ce7ca725d0bf997cc4b19088e0a484f4e7a8be244966cbfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ca81474d0cfc36a53ba106540fce4d5f6bd033008089ade6579bdc03d2cb3285"
  end

  depends_on "autoconf" => :build
  depends_on "boost"
  depends_on "gsl"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  # https://github.com/ParBLiSS/FastANI/issues/18 (don't need gsl+boost, either)

  def install
    # https://github.com/ParBLiSS/FastANI/issues/17 (macos clang opts for gcc)
    inreplace "Makefile.in", "-mmacosx-version-min=10.7 -stdlib=libc++", "-v"
    system "./bootstrap.sh"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-gsl=#{Formula["gsl"].opt_prefix}",
      "--with-boost=#{Formula["boost"].opt_prefix}"
    system "gzip", "-9f", *Dir["data/*.fna"]
    system "make", "install"
    pkgshare.install "data", "scripts"
  end

  test do
    assert_match "fragment length", shell_output("#{bin}/fastANI --help 2>&1")
    system "#{bin}/fastANI",
           "-q", pkgshare/"data/Shigella_flexneri_2a_01.fna.gz",
           "-r", pkgshare/"data/Escherichia_coli_str_K12_MG1655.fna.gz",
           "-o", testpath/"out",
           "--matrix"
    assert_predicate testpath/"out", :exist?
    assert_predicate testpath/"out.matrix", :exist?
  end
end
