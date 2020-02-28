class Salmon < Formula
  # cite Patro_2017: "https://doi.org/10.1038/nmeth.4197"
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/v1.1.0.tar.gz"
  sha256 "550bbdc18970b015f467d418385a5779cd0d6f642cb710766c66761c12c9bc50"
  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "48292242cc8968b741494a8b0c2115e963f8d556f69e91a93b0b06f7e01c6c19" => :sierra
    sha256 "402f7b66bcbf4347dbfedd8e39507024ad223b31b915a42f28cec37e2254a372" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "cereal"
  depends_on "curl"
  depends_on "jemalloc"
  depends_on "libgff"
  depends_on "staden-io-lib"
  depends_on "tbb"
  depends_on "xz"

  uses_from_macos "unzip"
  uses_from_macos "zlib"

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    system "cmake", ".", "-DUSE_SHARED_LIBS=1", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salmon --version 2>&1")
  end
end
