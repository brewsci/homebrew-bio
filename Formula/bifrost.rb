class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Highly parallel build/index of coloured/compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
  url "https://github.com/pmelsted/bifrost/archive/v1.0.tar.gz"
  sha256 "6c97da071946e980605e29f3b333ad14eeea7c6a79558d70309f7813aaf7eb56"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "7d38aca8cd115acc3c11250c0a14da474df8d1e94804ae54179d91c36b350783" => :catalina
    sha256 "826e134126f4cb1e4d227ab4e6f1d1a91759d1eb404abd01f201da15de9677f7" => :x86_64_linux
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    # no way to determine version https://github.com/pmelsted/bifrost/issues/14
    assert_match "bloom", shell_output("#{bin}/Bifrost 2>&1")
  end
end
