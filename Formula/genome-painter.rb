class GenomePainter < Formula
  desc "Paint genomes with taxa-specific k-mer probabilities"
  homepage "https://github.com/scwatts/genome_painter"
  url "https://github.com/scwatts/genome_painter/archive/v0.0.8.tar.gz"
  sha256 "434d81b4ed301f14aa3e9a55fdeeefab295264aa82410482abda23655e7a18bd"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "2863469c5132cfcc1a47fdaff7539bb3454534e222b98c75dc919db08b07f002" => :catalina
    sha256 "0c2f781971f00a75841e3a3d1813665374d89eb8d4adad5bf87cde385fd5bf95" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    inreplace "configure.ac", "[gomp]", "[omp]" if OS.mac?
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/genomepainter_paint_genome --version 2>&1")
  end
end
