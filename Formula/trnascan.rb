class Trnascan < Formula
  # cite Lowe_1997: "https://doi.org/10.1093/nar/25.5.0955"
  desc "Search for tRNA genes in genomic sequence"
  homepage "http://lowelab.ucsc.edu/tRNAscan-SE/"
  url "http://trna.ucsc.edu/software/trnascan-se-2.0.4.tar.gz"
  sha256 "d1a68f14ffa48692b1a110c47f9eeb52193eaf4a890d9f81757c321d0b6cea8d"
  version_scheme 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "4b9b41b0218c8eca4a3ee120b308e690d26e2b452cafad34ace553287a656b0c" => :catalina
    sha256 "cd9c6db9ce48711d817ffd2bca2dd6993d60973fb0c80f66f20103060701ca2b" => :x86_64_linux
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
