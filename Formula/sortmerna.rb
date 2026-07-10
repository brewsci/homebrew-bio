class Sortmerna < Formula
  # cite Kopylova_2012: "https://doi.org/10.1093/bioinformatics/bts611"
  desc "Filter metatranscriptomic ribosomal RNA"
  homepage "https://bioinfo.lifl.fr/RNA/sortmerna/"
  url "https://github.com/biocore/sortmerna/archive/refs/tags/v6.0.2.tar.gz"
  sha256 "f2a9d2b1a1041436d06278dd147cfa048d027e45edf79c994a80c64fc375e20b"
  license "GPL-3.0"
  head "https://github.com/biocore/sortmerna.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "aa26fd0b1316228b17fcb700bab6a2121af7806435c1657c9cbbf8724ce1f47d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b412dde11f5cb06f8c4a1aa3d78719d0647ffe5a2e9ff81df960903346269bd1"
  end

  depends_on "cmake" => :build
  depends_on "concurrentqueue"
  depends_on "parasail"
  depends_on "rocksdb"

  uses_from_macos "zlib"

  # Header-only minimal perfect hash function (BBHash/BooPHF), fetched by the
  # upstream build into 3rdparty/bbhash.
  resource "bbhash" do
    url "https://github.com/rizkg/BBHash.git",
        revision: "be4220c8f8580299b212a0c6c6c867528a0f07ac"
  end

  # Header-only rapidgzip library (seekable parallel gzip decompression),
  # fetched by the upstream build into 3rdparty/indexed_bzip2.
  resource "indexed_bzip2" do
    url "https://github.com/mxmlnkn/indexed_bzip2.git",
        revision: "ff5242bf439d996b81ead7fc0d1d9bc2dd0d7a6f"
  end

  def install
    # Stage the header-only dependencies where CMake expects them. The upstream
    # setup.py orchestrator clones these into 3rdparty/ before configuring.
    (buildpath/"3rdparty/bbhash").install resource("bbhash")
    (buildpath/"3rdparty/indexed_bzip2").install resource("indexed_bzip2")

    args = %W[
      -DWITH_TESTS=OFF
      -DROCKSDB_USE_STATIC_LIBS=ON
      -DROCKSDB_DIST=#{formula_opt_prefix("rocksdb")}
      -DPARASAIL_DIST=#{formula_opt_prefix("parasail")}
      -DCONCURRENTQUEUE_HOME=#{formula_opt_include("concurrentqueue")}/concurrentqueue/moodycamel
      -DINDEXED_BZIP2_HOME=#{buildpath}/3rdparty/indexed_bzip2/src
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"sortmerna", "--version"
  end
end
