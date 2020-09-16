class Fastani < Formula
  # cite Jain_2017: "https://doi.org/10.1101/225342"
  desc "Fast Whole-Genome Similarity (ANI) Estimation"
  homepage "https://github.com/ParBLiSS/FastANI"
  url "https://github.com/ParBLiSS/FastANI/archive/v1.31.tar.gz"
  sha256 "3a1f2da7fa940a0650a39c5b8176f475fe74eea6beb0bc8ea1394d94defa5b3d"
  license "Apache-2.0"
  head "https://github.com/ParBLiSS/FastANI.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "682a759bbd381799d6230fad33d75eed4e11a56023579233b955c6ed1ddc6a42" => :catalina
    sha256 "37054c44ef24bd932b14d5933cc962c2cd92bea796f4be0bab0ca92dc7d0a452" => :x86_64_linux
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
    system "make", "install"
    pkgshare.install "data", "scripts"
  end

  test do
    assert_match "fragment length", shell_output("#{bin}/fastANI --help 2>&1")
    system "#{bin}/fastANI",
           "-q", pkgshare/"data/Shigella_flexneri_2a_01.fna",
           "-r", pkgshare/"data/Escherichia_coli_str_K12_MG1655.fna",
           "-o", testpath/"out",
           "--matrix"
    assert_predicate testpath/"out", :exist?
    assert_predicate testpath/"out.matrix", :exist?
  end
end
