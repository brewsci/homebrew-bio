class Biobloomtools < Formula
  # cite Chu_2014: "https://doi.org/10.1093/bioinformatics/btu558"
  desc "BioBloom Tools (BBT): Bloom filter for bioinformatics"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  url "https://github.com/bcgsc/biobloom/releases/download/2.0.13/biobloomtools-2.0.13.tar.gz"
  sha256 "7b4aeef70feb3fc31db2f4695159523272eadd8787b33c2902e2970a7d569ba3"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "1a5e0d13789ac7f2d43f23708b263de8ea822d9d18212e6bd7cbe5b42d20ccfe" => :sierra
    sha256 "3e5c5dd1c574421d82b0a895b9b4eabceba04b8c5e38e5793e50925afe2cf486" => :x86_64_linux
  end

  head do
    url "https://github.com/bcgsc/biobloom.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  fails_with :clang # needs openmp

  depends_on "boost" => :build
  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/biobloommaker --help 2>&1")
    assert_match "Usage", shell_output("#{bin}/biobloomcategorizer --help 2>&1")
  end
end
