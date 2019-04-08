class Racon < Formula
  # cite Vaser_2017: "https://doi.org/10.1101/gr.214270.116"
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/isovic/racon"
  url "https://github.com/isovic/racon/releases/download/1.3.2/racon-v1.3.2.tar.gz"
  sha256 "7c99380a0f1091f5ee138b559e318d7e9463d3145eac026bf236751c2c4b92c7"
  head "https://github.com/isovic/racon.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "1fd45c7a87050ea72ac64bc99c9794eb34770cbe2e1f2b4f7e02912019cbf7f5" => :sierra
    sha256 "17e84c6f3d31b08a7744cb972351f5f088f4fc9be9ba3c1690874ee763a9dc93" => :x86_64_linux
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
