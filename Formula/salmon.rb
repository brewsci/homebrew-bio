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
    sha256 cellar: :any, catalina:     "2a39a9c9053bc725a5b5d47cb35a945555f956b7846dc2d60e98ed07b686f00d"
    sha256 cellar: :any, x86_64_linux: "7851373114d5aa1cd698b73a71223371e2df913280c9c8fa58b32ef9853a5bdd"
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
