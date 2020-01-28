class Ntcard < Formula
  # cite Mohamadi_2017: "https://doi.org/10.1093/bioinformatics/btw832"
  desc "Estimating k-mer coverage histogram of genomics data"
  homepage "https://github.com/bcgsc/ntCard"
  url "https://github.com/bcgsc/ntCard/releases/download/1.2.1/ntcard-1.2.1.tar.gz"
  sha256 "2d635dec6e293780a5ae2b7bb422ff5cc825a03270b507f5061cbf0f09ee7076"

  head "https://github.com/bcgsc/ntCard"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "3687ad1e69cfc8849b4d9d6c2aaaf96f426125509658ace1ec4febe7c3dadcf3" => :catalina
    sha256 "a4c224a29010985c7956a6ef37e6b08f3370975512031f16ed5f1370b55866a3" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gcc" if OS.mac? # for openmp

  fails_with :clang # needs openmp

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ntcard --help 2>&1")
  end
end
