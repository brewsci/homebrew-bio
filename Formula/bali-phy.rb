class BaliPhy < Formula
  # cite Suchard_2006: "http://dx.doi.org/10.1093/bioinformatics/btl175"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "http://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy/archive/3.3.tar.gz"
  sha256 "84132dd0ec8a62eb6697374c62847e4b84082cbf09977f0e157e8407db010ccc"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "1d245b28d3dcb87d1a0d26a194c0a57c638356dd064065d6620cfc203ba00656" => :sierra
    sha256 "53e848975660e3a763a7129a249206d5a06e8523476991b673c4b0d8b00ad6f1" => :x86_64_linux
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
