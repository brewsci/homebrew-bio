class BaliPhy < Formula
  # cite Suchard_2006: "http://dx.doi.org/10.1093/bioinformatics/btl175"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "http://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy/archive/3.1.4.tar.gz"
  sha256 "83124383533d12ea335e81e63a202ca97d850e8962b1a77e6166ae0fd0ebffa0"

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
