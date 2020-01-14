class Ntcard < Formula
  # cite Mohamadi_2017: "https://doi.org/10.1093/bioinformatics/btw832"
  desc "Estimating k-mer coverage histogram of genomics data"
  homepage "https://github.com/bcgsc/ntCard"
  url "https://github.com/bcgsc/ntCard/archive/v1.1.1.tar.gz"
  sha256 "f1b34c4d55055819908248324e6010008c43d74ab56b72ceb5a56bde4dfcdbde"
  revision 1
  head "https://github.com/bcgsc/ntCard"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "beef0f25e0a6c64e399685d77db1b16336551d744f53c184a2ec55194d9fe0b5" => :mojave
    sha256 "f1e5d1831be321cb71864fca94fd4de18b3cc9bd088fae974d5b816db48dddb3" => :x86_64_linux
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
