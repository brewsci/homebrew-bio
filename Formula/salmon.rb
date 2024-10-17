class Salmon < Formula
  # cite Patro_2017: "https://doi.org/10.1038/nmeth.4197"
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "a053fba63598efc4ade3684aa2c8e8e2294186927d4fcdf1041c36edc2aa0871"
  license "GPL-3.0-or-later"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7848bf107e84581e266a23668b9a8abb67d620101f8a37e352ccbe9e8cf5c6a7"
    sha256 cellar: :any,                 arm64_sonoma:  "0571a9cae7fe97a04669dd76c78e7222cf6214caa91b426f4e1c2e8cddbb4040"
    sha256 cellar: :any,                 ventura:       "2de62df335d4bdcb9bb3fd3946960bf248c491e810f83f51ed52f35a821cb451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bfb7680361ebe1832dedb87a31dd5f23fc262400c01922f5d986e6e9aa3a006"
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
