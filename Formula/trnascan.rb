class Trnascan < Formula
  # cite Lowe_1997: "https://doi.org/10.1093/nar/25.5.0955"
  desc "Search for tRNA genes in genomic sequence"
  homepage "https://github.com/UCSC-LoweLab/tRNAscan-SE/"
  url "https://github.com/UCSC-LoweLab/tRNAscan-SE/archive/refs/tags/v2.0.13.tar.gz"
  sha256 "895a02a59257bdabbb62753b59ee46c9760e6ce4ca864f2b161b2602992d5168"
  version_scheme 2

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_tahoe:   "648e557179ae9bd7afcef22622c099bb4a7e71f28f4427ebe562dab762833c12"
    sha256 arm64_sequoia: "7c44de1e66f91ac9d20db303328b1c75788ae4d603fa731efc0e0406cfd4d7fa"
    sha256 arm64_sonoma:  "7cd1ebafdfeffaf6c37be6ffc390936bc77544f4277c1f210c100960b073984f"
    sha256 x86_64_linux:  "12daff4d69b1a5588802d73983fc9ff44eaf6ed7bfec486251e1435cec742d5a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "brewsci/bio/infernal"

  def install
    # Fix the error: bin/sstofa: No such file or directory
    ENV.deparallelize

    inreplace "tRNAscan-SE.src", "@bindir@/tRNAscan-SE.conf", "#{prefix}/etc/tRNAscan-SE.conf"
    inreplace "tRNAscan-SE.conf.src", "infernal_dir: {bin_dir}", "infernal_dir: #{HOMEBREW_PREFIX}/bin"

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"

    (prefix/"etc").install bin/"tRNAscan-SE.conf"
    prefix.install "Demo"
  end

  test do
    system "#{bin}/tRNAscan-SE", "-b", "test.bed", "#{prefix}/Demo/Example1.fa"
    assert_path_exists testpath/"test.bed"
    assert_equal File.read("test.bed"), File.read(prefix/"Demo/Example1-tRNAs.bed")
  end
end
