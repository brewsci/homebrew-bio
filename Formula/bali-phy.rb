class BaliPhy < Formula
  # cite Suchard_2006: "http://dx.doi.org/10.1093/bioinformatics/btl175"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "http://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy/archive/3.3.tar.gz"
  sha256 "84132dd0ec8a62eb6697374c62847e4b84082cbf09977f0e157e8407db010ccc"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "6405ad25a4aa5e204330758160ab47d9721b12d69cb7f7833c8ee7e486828618" => :sierra_or_later
    sha256 "4f2c9a9c908873d2e23155a3e3289bacd8cd8353d85c6394eba0e7b738c31199" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"

  def install
    flags = %w[-C build install]
    # Reduce memory usage for Circle CI
    flags += %w[-j 4] if ENV["CIRCLECI"]
    system "meson", "build", "--prefix=#{prefix}"
    system "ninja", *flags
  end

  test do
    system "#{bin}/bali-phy", "--version"
    system "#{bin}/bali-phy", "#{doc}/examples/sequences/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze", "5d-1"
  end
end
