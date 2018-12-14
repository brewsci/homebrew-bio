class BaliPhy < Formula
  # cite Suchard_2006: "http://dx.doi.org/10.1093/bioinformatics/btl175"
  # cite Redelings_2014: "https://dx.doi.org/10.1093/molbev/msu174"
  desc "Bayesian co-estimation of phylogenies and multiple alignments"
  homepage "http://www.bali-phy.org/"
  url "https://github.com/bredelings/BAli-Phy/archive/3.4.tar.gz"
  sha256 "06a404039e988af4c2070aa6436c8a64f0a8d9eec403ffe99635574cefcc4d8d"
  head "https://github.com/bredelings/BAli-Phy.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "2f44d8d2b639d38edaf1e971546d4eb9d01b6be0dae11434a0c19f23849c33b9" => :sierra
    sha256 "1d509a5489f915bbedde437b70694960778250e54c0f7e8538db8fb0663170b8" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"

  def install
    flags = %w[-C build install]
    # Reduce memory usage for Circle CI
    flags << "-j4" if ENV["HOMEBREW_CIRCLECI"]
    system "meson", "build", "--prefix=#{prefix}"
    system "ninja", *flags
  end

  test do
    system "#{bin}/bali-phy", "--version"
    system "#{bin}/bali-phy", "#{doc}/examples/sequences/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze", "5d-1"
  end
end
