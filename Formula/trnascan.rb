class Trnascan < Formula
  # cite Lowe_1997: "https://doi.org/10.1093/nar/25.5.0955"
  desc "Search for tRNA genes in genomic sequence"
  homepage "https://github.com/UCSC-LoweLab/tRNAscan-SE/"
  url "https://github.com/UCSC-LoweLab/tRNAscan-SE/archive/refs/tags/v2.0.12.tar.gz"
  sha256 "4b255c2c5e0255381194166f857ab2ea21c55aa7de409e201333ba615aa3dc61"
  revision 1
  version_scheme 2

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sonoma: "48a1fb2c2e5b1a6800b54595d151cadcbfe05d7884be32564044335b00a407aa"
    sha256 ventura:      "1a64402cd1405c0eb87f142a260db98c997cf1009fc0cb2e3d448600053e6d84"
    sha256 x86_64_linux: "a34a902899f2beec19f991255616ef02ab191ddba909a321d2d79089bcce6a77"
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
