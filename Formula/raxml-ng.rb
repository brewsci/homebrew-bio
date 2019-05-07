class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
    :tag      => "0.8.1",
    :revision => "30c61006cba268a570aba7f862c813142bc41785"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "50027eb27a1a44edd0ef93d393f3aed3957f544ace2a34b14d6dfd82b3f9683d" => :sierra
    sha256 "91ae9d22784c2fe702518d3b9df0444e8667b6f2825b46fe5dedc2332ccf5cb5" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  unless OS.mac?
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "open-mpi" => :recommended
  end

  resource "example" do
    url "https://sco.h-its.org/exelixis/resource/download/hands-on/dna.phy"
    sha256 "c2adc42823313831b97af76b3b1503b84573f10d9d0d563be5815cde0effe0c2"
  end

  def install
    # Build release binaries
    inreplace "CMakeLists.txt", "set (CMAKE_BUILD_TYPE DEBUG)", ""
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      if build.with? "open-mpi"
        system "cmake", "..", *std_cmake_args, "-DUSE_MPI=ON"
        system "make"
      end
    end
    bin.install Dir["bin/raxml-ng*"]
  end

  test do
    testpath.install resource("example")
    system "#{bin}/raxml-ng", "--msa", "dna.phy", "--start", "--model", "GTR"
  end
end
