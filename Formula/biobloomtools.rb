class Biobloomtools < Formula
  # cite Chu_2014: "https://doi.org/10.1093/bioinformatics/btu558"
  desc "BBT: Bloom filter for bioinformatics"
  homepage "https://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  url "https://github.com/bcgsc/biobloom/releases/download/2.3.3/biobloomtools-2.3.3.tar.gz"
  sha256 "cd3ca08677aae4cf99da30fdec87a23b12a8320c6d0e21df9d0c3b26b62b6153"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "0ee92de1bc3bc3e22572154e84db05b1120953a1758ec90ae50685dc601c3551" => :catalina
    sha256 "6c1cb00f8060a9c59ab37bf3d58e8c8bbfb522a5c26ad714c2c07623bc672522" => :x86_64_linux
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
      revision: "0546faf0552142f06ff4b201b671a5769dd007ad",
      tag:      "v2.1.1"
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
