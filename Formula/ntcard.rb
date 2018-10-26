class Ntcard < Formula
  # cite Mohamadi_2017: "https://doi.org/10.1093/bioinformatics/btw832"
  desc "Estimating k-mer coverage histogram of genomics data"
  homepage "https://github.com/bcgsc/ntCard"
  url "https://github.com/bcgsc/ntCard/archive/v1.1.0.tar.gz"
  sha256 "88ffcffc67e619e714b65753baa077a9a16536fcb5c789c2d77bbd87dd4c2a15"
  head "https://github.com/bcgsc/ntCard"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "37ab6a8290ceb52466ca05bebad2bcbd17d2e3d06d543fb17605d2f67f7fae70" => :sierra
    sha256 "e486f477107faf406e644cefee349f9649b5ba8ed2f624b9e1952a5129da1631" => :x86_64_linux
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
