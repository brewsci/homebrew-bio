class BaliPhy < Formula
  # cite Suchard_2006: "http://dx.doi.org/10.1093/bioinformatics/btl175"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "http://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy/archive/3.1.4.tar.gz"
  sha256 "83124383533d12ea335e81e63a202ca97d850e8962b1a77e6166ae0fd0ebffa0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "6405ad25a4aa5e204330758160ab47d9721b12d69cb7f7833c8ee7e486828618" => :sierra_or_later
    sha256 "4f2c9a9c908873d2e23155a3e3289bacd8cd8353d85c6394eba0e7b738c31199" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build

  def install
    flags = %w[-C build install]
    # Reduce memory usage for Circle CI
    flags += %w[-j 4] if ENV["CIRCLECI"]
    system "meson", "build", "--prefix=#{prefix}"
    system "ninja", *flags
  end

  test do
    system "#{bin}/bali-phy", "--version"
  end
end
