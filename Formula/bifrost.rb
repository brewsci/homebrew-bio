class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Highly parallel construction, indexing and querying of colored and compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
  url "https://github.com/pmelsted/bifrost/archive/v1.0.5.tar.gz"
  sha256 "47360fe757b4aeec438deb38449dcaad607fc7421e7d6bf819112c8ed58c0d5d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "47360fe757b4aeec438deb38449dcaad607fc7421e7d6bf819112c8ed58c0d5d" => :catalina
    sha256 "47360fe757b4aeec438deb38449dcaad607fc7421e7d6bf819112c8ed58c0d5d" => :x86_64_linux
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
    assert_match "Usage", shell_output("#{bin}/Bifrost --help 2>&1")
  end
end
