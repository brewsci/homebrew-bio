class Salmon < Formula
  # cite Patro_2017: "https://doi.org/10.1038/nmeth.4197"
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "babd9ccc189cfea07566d8a11d047f25fad5b446b4b69257bc6ad8869f8b7707"
  license "GPL-3.0"
  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ceb8c8b591adc2c3cd877212020fea603851df7607a01a1cf77d5a5d233d8546"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "tbb"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "unzip" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    args = *std_cmake_args
    # https://github.com/COMBINE-lab/salmon/issues/664
    args << "-DNO_IPO=TRUE" if OS.linux?
    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/salmon --help 2>&1")
  end
end
