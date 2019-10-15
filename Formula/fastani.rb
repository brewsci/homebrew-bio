class Fastani < Formula
  # cite Jain_2017: "https://doi.org/10.1101/225342"
  desc "Fast Whole-Genome Similarity (ANI) Estimation"
  homepage "https://github.com/ParBLiSS/FastANI"
  url "https://github.com/ParBLiSS/FastANI/archive/v1.2.tar.gz"
  sha256 "d5c1e2d89919ce5974007b006a8dad293aa86e590f8b85fc413afae3f3c40715"
  head "https://github.com/ParBLiSS/FastANI.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "ff8d6d9662eae0bc5eb25bcb47ecb43cb56e1526d7a9235c0d40ddbe0e096f92" => :sierra
    sha256 "71f8d0311cae9c1f6ee05cdf1dae0e6edb88920a9d261275201ce59096753da8" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "gcc" => :build if OS.mac? # needs openmp
  depends_on "gsl"

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    # https://github.com/ParBLiSS/FastANI/issues/17 (macos clang opts for gcc)
    inreplace "Makefile.in", "-stdlib=libc++", "-v"
    system "./bootstrap.sh"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-gsl=#{Formula["gsl"].opt_prefix}"
    system "make", "install"
    pkgshare.install "data", "scripts"
  end

  test do
    # https://github.com/ParBLiSS/FastANI/issues/15
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
