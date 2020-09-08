class Salmon < Formula
  # cite Patro_2017: "https://doi.org/10.1038/nmeth.4197"
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
<<<<<<< HEAD
  url "https://github.com/COMBINE-lab/salmon/archive/v1.2.1.tar.gz"
  sha256 "10a58a22cb5b3924df3bf78be9cb4b83dce4f6a61e4c6a6e37f3a56ab8ac166f"
=======
  url "https://github.com/COMBINE-lab/salmon/archive/v1.3.0.tar.gz"
  sha256 "c105be481630d57e7022bf870eb040857834303abff05fe0e971dda5ed6f0236"
  license "GPL-3.0"
>>>>>>> upstream/develop
  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
<<<<<<< HEAD
    sha256 "8b7028be50231b483dfbfde6e72725845bf8fe5c641029307b900f51e75fc69f" => :catalina
    sha256 "4ff4420a22b8f540fe10be43b4e0c5ac53cf36103dbe967f19c05e6128075283" => :x86_64_linux
=======
    sha256 "2a39a9c9053bc725a5b5d47cb35a945555f956b7846dc2d60e98ed07b686f00d" => :catalina
    sha256 "7851373114d5aa1cd698b73a71223371e2df913280c9c8fa58b32ef9853a5bdd" => :x86_64_linux
>>>>>>> upstream/develop
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
