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
    sha256 "a685c7ff1bacf5b3b02c70f6e8eb0e75e64c5892b41d4a6c30770ebc934c7f8e" => :catalina
    sha256 "c6af69458de6e27eddb2f29f5b625babe016d3c919c140d05de7d8d27fe37fa7" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gcc" if OS.mac? # needs openmp

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
