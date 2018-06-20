class Biobloomtools < Formula
  # cite Chu_2014: "https://doi.org/10.1093/bioinformatics/btu558"
  desc "BioBloom Tools (BBT): Bloom filter for bioinformatics"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  url "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/releases/2.1.1/biobloomtools-2.1.1.tar.gz"
  sha256 "1628e62b2e671f271a8d0a5aba78d32888d4c7c4f1b6341140a7f1364c557457"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "1a5e0d13789ac7f2d43f23708b263de8ea822d9d18212e6bd7cbe5b42d20ccfe" => :sierra_or_later
    sha256 "3e5c5dd1c574421d82b0a895b9b4eabceba04b8c5e38e5793e50925afe2cf486" => :x86_64_linux
  end

  head do
    url "https://github.com/bcgsc/biobloom.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  fails_with :clang # needs openmp

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure",
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
