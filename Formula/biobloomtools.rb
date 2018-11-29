class Biobloomtools < Formula
  # cite Chu_2014: "https://doi.org/10.1093/bioinformatics/btu558"
  desc "BioBloom Tools (BBT): Bloom filter for bioinformatics"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  url "https://github.com/bcgsc/biobloom/releases/download/2.2.0/biobloomtools-2.2.0.tar.gz"
  sha256 "5d09f8690f0b6402f967ac09c5b0f769961f3fe3791000f8f73af6af7324f02c"

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

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build

  if OS.mac?
    depends_on "gcc" # for openmp
    depends_on "cmake" => :build
    # build sdsl-lite using gcc
    resource "sdsl" do
      url "https://github.com/simongog/sdsl-lite.git",
      :revision => "0546faf0552142f06ff4b201b671a5769dd007ad",
      :tag      => "v2.1.1"
    end
  else
    depends_on "sdsl-lite" => :build
    depends_on "zlib"
  end

  fails_with :clang # needs openmp

  def install
    system "./autogen.sh" if build.head?
    if OS.mac?
      sdsl = buildpath/"sdsl"
      resource("sdsl").stage do
        ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]
        ENV.cxx11
        system "./install.sh", sdsl
      end
      system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--with-sdsl=#{sdsl}"
    else
      system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}"
    end
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/biobloommaker --help 2>&1")
    assert_match "Usage", shell_output("#{bin}/biobloomcategorizer --help 2>&1")
    assert_match "Usage", shell_output("#{bin}/biobloommimaker --help 2>&1")
    assert_match "Usage", shell_output("#{bin}/biobloommicategorizer --help 2>&1")
  end
end
