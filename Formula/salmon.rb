class Salmon < Formula
  # cite Patro_2017: "https://doi.org/10.1038/nmeth.4197"
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/v1.2.1.tar.gz"
  sha256 "10a58a22cb5b3924df3bf78be9cb4b83dce4f6a61e4c6a6e37f3a56ab8ac166f"
  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "8b7028be50231b483dfbfde6e72725845bf8fe5c641029307b900f51e75fc69f" => :catalina
    sha256 "4ff4420a22b8f540fe10be43b4e0c5ac53cf36103dbe967f19c05e6128075283" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "tbb"
  depends_on "xz"

  uses_from_macos "unzip" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/salmon --help 2>&1")
  end
end
