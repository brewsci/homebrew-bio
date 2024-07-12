class Trnascan < Formula
  # cite Lowe_1997: "https://doi.org/10.1093/nar/25.5.0955"
  desc "Search for tRNA genes in genomic sequence"
  homepage "http://lowelab.ucsc.edu/tRNAscan-SE/"
  url "http://trna.ucsc.edu/software/trnascan-se-2.0.12.tar.gz"
  sha256 "96fa4af507cd918c1c623763d9260bd6ed055d091662b44314426f6bbf447251"
  version_scheme 1
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 x86_64_linux: "8b1bdd752cc3f7a0ce29e968f367c8282314e194ae1574ae53df1453123c6eaa"
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
    assert_predicate testpath/"test.bed", :exist?
    assert_equal File.read("test.bed"), File.read(prefix/"Demo/Example1-tRNAs.bed")
  end
end
