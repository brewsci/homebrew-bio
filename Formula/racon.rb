class Racon < Formula
  # cite Vaser_2017: "https://doi.org/10.1101/gr.214270.116"
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/isovic/racon"
  url "https://github.com/isovic/racon/releases/download/1.3.2/racon-v1.3.2.tar.gz"
  sha256 "7c99380a0f1091f5ee138b559e318d7e9463d3145eac026bf236751c2c4b92c7"
  revision 1
  head "https://github.com/isovic/racon.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fb34a1cd494826c7ce24a70e3f39859a1cc38eefee6b7d3d70f8d611b8a499dd" => :sierra
    sha256 "017bfaa79c852ee19a3b728a8589498588723421d42f03c63011e8c9a90026e9" => :x86_64_linux
  end

  depends_on "cmake" => :build
  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  fails_with :clang # needs openmp

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/racon --help")
  end
end
