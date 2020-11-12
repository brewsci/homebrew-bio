class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Construction, indexing and querying of colored/compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
  url "https://github.com/pmelsted/bifrost/archive/v1.0.5.tar.gz"
  sha256 "47360fe757b4aeec438deb38449dcaad607fc7421e7d6bf819112c8ed58c0d5d"
  license "BSD-2-Clause"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "70a8e2edd2e43078e21be35a9356bec272f48dffe5a1d79f3f951f2dddf2668f" => :catalina
    sha256 "106658498fe0187dc5e44d78906b9ba6c2ec67a8394106aa298de92d1bd4673c" => :x86_64_linux
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
    assert_match version.to_s, shell_output("#{bin}/Bifrost --version 2>&1")
  end
end
