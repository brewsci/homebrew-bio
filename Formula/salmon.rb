class Salmon < Formula
  # cite "https://doi.org/10.1038/nmeth.4197"
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/v0.8.2.tar.gz"
  sha256 "299168e873e71e9b07d63a84ae0b0c41b0876d1ad1d434b326a5be2dce7c4b91"
  revision 1
  head "https://github.com/COMBINE-lab/salmon.git"

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "unzip" => :build
  depends_on "boost"
  depends_on "tbb"
  depends_on "xz"
  depends_on "zlib" unless OS.mac?

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/salmon --help 2>&1")
  end
end
