class Salmon < Formula
  # cite "https://doi.org/10.1038/nmeth.4197"
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/v0.9.1.tar.gz"
  sha256 "3a32c28d217f8f0af411c77c04144b1fa4e6fd3c2f676661cc875123e4f53520"
  head "https://github.com/COMBINE-lab/salmon.git"

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "tbb"
  depends_on "xz"
  unless OS.mac?
    depends_on "unzip" => :build
    depends_on "zlib"
  end

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/salmon --help 2>&1")
  end
end
