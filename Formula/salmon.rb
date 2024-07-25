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
    sha256 cellar: :any,                 arm64_sonoma: "aecd4f72006bab62051730695db0702338a1d93f6d88201851b7939fcf1061ef"
    sha256 cellar: :any,                 ventura:      "70efc2ac6db2dd206f82c193ce55f1422fc404431199e13209ba0d176c598893"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c8da03dad28446849757146ecf18e175abbc8ae7dfb340f004bacd983a8a1190"
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
