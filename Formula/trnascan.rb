class Trnascan < Formula
  # cite Lowe_1997: "https://doi.org/10.1093/nar/25.5.0955"
  desc "Search for tRNA genes in genomic sequence"
  homepage "http://lowelab.ucsc.edu/tRNAscan-SE/"
  url "http://trna.ucsc.edu/software/trnascan-se-2.0.3.tar.gz"
  sha256 "b305c1bf226d16833349b22ad1f3160a52ad30f577a336128da3cc76d5772a4e"
  version_scheme 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "c748dc081ef572569e4ab23375847bac0f71489fc0f53e96b507574cd9b6e321" => :sierra
    sha256 "499d55124fced2bf77023a0aa0525a3a7913fa2011078dd3d26d474469cb220f" => :x86_64_linux
  end

  depends_on "infernal"

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
    assert_predicate testpath/"test.bed", :exist?
    assert_equal File.read("test.bed"), File.read(prefix/"Demo/Example1-tRNAs.bed")
  end
end
