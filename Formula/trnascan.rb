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
    sha256 arm64_sonoma: "966819cc3a9866d00c8ca7750e060e2cd952b6c508af6acce6c8b7b5f0418cda"
    sha256 ventura:      "b2d86eefcaebbcaea88506919b21b3b2e64d729b1aea093caaf519ea3159103f"
    sha256 x86_64_linux: "e320c516c48d9a27d75b72817a79af80a789f8ae4cc630cfd6a731c2543923da"
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
