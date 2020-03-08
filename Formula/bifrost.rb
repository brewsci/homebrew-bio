class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Highly parallel build/index of coloured/compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
  url "https://github.com/pmelsted/bifrost/archive/v1.0.1.tar.gz"
  sha256 "a94b230663d44db3ce34630be23790a77218918051fee1725770671e70c68657"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
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
