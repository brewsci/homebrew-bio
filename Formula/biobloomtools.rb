class Biobloomtools < Formula
  # cite Chu_2014: "https://doi.org/10.1093/bioinformatics/btu558"
  desc "BioBloom Tools (BBT): Bloom filter for bioinformatics"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  url "https://github.com/bcgsc/biobloom/releases/download/2.3.1/biobloomtools-2.3.1.tar.gz"
  sha256 "0a0b8854a1e5c8206b977d8365fdd9b23027b3c500e2bbac140eb6d3d047dc77"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "dacebfac0fda80e132ecd710160a39a9843426d5b7d1aa0830a45e65d9746b90" => :sierra
    sha256 "cf88536e6236fcc36b1760c1462573e725a58df0dcc7a0065d5e7c33da178712" => :x86_64_linux
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
