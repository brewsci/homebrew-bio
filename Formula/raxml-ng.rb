class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
    :tag      => "0.7.0",
    :revision => "6fe3fa9c5817bfc9f352f5fe7fa14a54f9ac2b6a"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9e453f2f3958b904ee68a07b41966d773b78a5018ad9471b536365b5e3a838b3" => :sierra
    sha256 "a8209facb1b98e08db8d2a54bb78f7b81007d63c1419813b711eee6119d07871" => :x86_64_linux
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
