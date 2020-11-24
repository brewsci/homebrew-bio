class Bmdca < Formula
  # cite Figliuzzi_2018: "https://doi.org/10.1093/molbev/msy007"
  # cite Russ_2020: "https://doi.org/10.1126/science.aba3304"
  desc "Boltzmann-machine Direct Coupling Analysis"
  homepage "https://github.com/ranganathanlab/bmDCA/"
  url "https://github.com/ranganathanlab/bmDCA/archive/v0.8.12.tar.gz"
  sha256 "542991c51ba1e9d74b500e09e80d43f716fe4214a24d71f580a24df667762049"
  license "GPL-3.0-only"

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
