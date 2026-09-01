class Biobloomtools < Formula
  # cite Chu_2014: "https://doi.org/10.1093/bioinformatics/btu558"
  desc "BBT: Bloom filter for bioinformatics"
  homepage "https://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  url "https://github.com/bcgsc/biobloom/releases/download/2.3.5/biobloomtools-2.3.5.tar.gz"
  sha256 "03fbc0d0fc867f76d64f756d556598e5fe5f015363df8f97fbed4cfd541c6749"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "0ee92de1bc3bc3e22572154e84db05b1120953a1758ec90ae50685dc601c3551"
    sha256 cellar: :any, x86_64_linux: "6c1cb00f8060a9c59ab37bf3d58e8c8bbfb522a5c26ad714c2c07623bc672522"
  end

  head do
    url "https://github.com/bcgsc/biobloom.git", branch: "master"
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
    # Newer compilers promote added -Wall/-Wextra warnings to errors under the
    # upstream -Werror; -Wno-error (appended after it) keeps the build going.
    # Newer Boost headers need C++17 (std::is_final etc.); the later -std wins.
    ENV.append "CXXFLAGS", "-Wno-error -std=c++17"
    # The system sdsl-lite ships a non-PIC libsdsl.a, which cannot be linked
    # into a position-independent executable; link non-PIE on Linux.
    ENV.append "LDFLAGS", "-no-pie" if OS.linux?
    if OS.mac?
      sdsl = buildpath/"sdsl"
      resource("sdsl").stage do
        ENV.cxx11
        # sdsl's CMakeLists predates CMake 3.5; allow modern CMake to configure it.
        ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
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
