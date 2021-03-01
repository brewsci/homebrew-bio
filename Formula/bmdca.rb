class Bmdca < Formula
  # cite Figliuzzi_2018: "https://doi.org/10.1093/molbev/msy007"
  # cite Russ_2020: "https://doi.org/10.1126/science.aba3304"
  desc "Boltzmann-machine Direct Coupling Analysis"
  homepage "https://github.com/ranganathanlab/bmDCA/"
  url "https://github.com/ranganathanlab/bmDCA/archive/v0.8.12.tar.gz"
  sha256 "542991c51ba1e9d74b500e09e80d43f716fe4214a24d71f580a24df667762049"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, catalina:     "e54c657f4faca1b85724c4ffbad00d1eed25c72b8bb407ceb5d474644771b453"
    sha256 cellar: :any, x86_64_linux: "6f1dbb4b20111704690b1654a7e607108e9ddcbd979eafe80a9a2dd10e368bb2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "armadillo"

  on_macos do
    depends_on "libomp"
  end

  def install
    on_macos do
      ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib} -lomp"
      ENV.append "CPPFLAGS", "-I#{HOMEBREW_PREFIX}/include -Xpreprocessor -fopenmp -lomp"
    end

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage", shell_output("#{bin}/bmdca -h")
  end
end
