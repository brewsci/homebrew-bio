class Fastani < Formula
  # cite Jain_2017: "https://doi.org/10.1101/225342"
  desc "Fast Whole-Genome Similarity (ANI) Estimation"
  homepage "https://github.com/ParBLiSS/FastANI"
  url "https://github.com/ParBLiSS/FastANI/archive/v1.1.tar.gz"
  sha256 "88766cf09b944d4622a569aa33178b8008a699cae044ab837a16f2bd70112c86"
  head "https://github.com/ParBLiSS/FastANI.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "ff8d6d9662eae0bc5eb25bcb47ecb43cb56e1526d7a9235c0d40ddbe0e096f92" => :sierra
    sha256 "71f8d0311cae9c1f6ee05cdf1dae0e6edb88920a9d261275201ce59096753da8" => :x86_64_linux
  end

  fails_with :clang # needs openmp

  depends_on "autoconf" => :build
  depends_on "gcc" => :build if OS.mac? # needs openmp

  # https://github.com/ParBLiSS/FastANI/issues/18 (don't need gsl+boost, either)
  depends_on "gsl"
  depends_on "boost"
  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    # https://github.com/ParBLiSS/FastANI/issues/17 (macos clang opts for gcc)
    inreplace "Makefile.in", "-mmacosx-version-min=10.7 -stdlib=libc++", "-v"
    system "./bootstrap.sh"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-gsl=#{Formula["gsl"].opt_prefix}",
      "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"
    pkgshare.install "data", "scripts"
  end

  test do
    # https://github.com/ParBLiSS/FastANI/issues/15 (returns 1 not 0)
    assert_match "fragments", shell_output("#{bin}/fastANI --help 2>&1", 1)
    system "#{bin}/fastANI",
           "-q", pkgshare/"data/Shigella_flexneri_2a_01.fna",
           "-r", pkgshare/"data/Escherichia_coli_str_K12_MG1655.fna",
           "-o", testpath/"out",
           "--matrix"
    assert_predicate testpath/"out", :exist?
    assert_predicate testpath/"out.matrix", :exist?
  end
end
