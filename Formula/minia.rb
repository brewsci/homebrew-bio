class Minia < Formula
  # cite Chikhi_2013: "https://doi.org/10.1186/1748-7188-8-22"
  desc "Short-read assembler based on a de Bruijn graph"
  homepage "http://minia.genouest.org/"
  url "https://github.com/GATB/minia/releases/download/v3.2.0/minia-v3.2.0-Source.tar.gz"
  sha256 "1e0fca9687002d776490234abe95e9516ff43fa43a16ab41d18807c129c02881"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "de11f70552777947ceb1325956ddfb99816b9053dead8834d43dee1a3ab36619" => :sierra
    sha256 "aab986fbbd91ae6d0bb392eb5fc93b2ba4117e18c6a19cccd3c4be1bcd056adf" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DSKIP_DOC=1"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
    # Installing non-libraries to "lib" is discouraged.
    rm lib/"libhdf5.settings"
    # remove test folder as 250MB is too big for bottles
    rm_r prefix/"test"
  end

  test do
    assert_match "options", shell_output("#{bin}/minia")
  end
end
