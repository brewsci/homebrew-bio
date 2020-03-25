class Biobloomtools < Formula
  # cite Chu_2014: "https://doi.org/10.1093/bioinformatics/btu558"
  desc "BioBloom Tools (BBT): Bloom filter for bioinformatics"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  url "https://github.com/bcgsc/biobloom/releases/download/2.3.2/biobloomtools-2.3.2.tar.gz"
  sha256 "a1e6b5a58750280c29f82f7d2f795efaeab8bebe1266f2e8f6e285649fd7f38a"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "4181eb16f11624fc6f5750a9d8dda2f948866ddfdf6551ebe486a6f221e9cde0" => :sierra
    sha256 "a495e45dd593d6c015da6840579409b91dc1d95c3fba721623af07e04ac0024e" => :x86_64_linux
  end

  head do
    url "https://github.com/bcgsc/biobloom.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build

  if OS.mac?
    depends_on "gcc" # needs openmp
    depends_on "cmake" => :build
    # build sdsl-lite using gcc
    resource "sdsl" do
      url "https://github.com/simongog/sdsl-lite.git",
      :revision => "0546faf0552142f06ff4b201b671a5769dd007ad",
      :tag      => "v2.1.1"
    end
  else
    depends_on "sdsl-lite" => :build
  end

  uses_from_macos "zlib"

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
