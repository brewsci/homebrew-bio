class Trnascan < Formula
  # cite Lowe_1997: "https://doi.org/10.1093/nar/25.5.0955"
  desc "Search for tRNA genes in genomic sequence"
  homepage "http://lowelab.ucsc.edu/tRNAscan-SE/"
  url "http://trna.ucsc.edu/software/trnascan-se-2.0.3.tar.gz"
  sha256 "b305c1bf226d16833349b22ad1f3160a52ad30f577a336128da3cc76d5772a4e"
  version_scheme 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "65df374277adbbf57e9e444d88ac65c2163ffd0599a5495cb00fffc0a47467a5" => :sierra
    sha256 "447c395805d3603d256d33d36c950816a3b0d354e8f362a406767e0409ad3d8e" => :x86_64_linux
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
