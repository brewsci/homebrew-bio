class EpaNg < Formula
  # cite Barbera_2018: "https://doi.org/10.1093/sysbio/syy054"
  desc "Massively parallel phylogenetic placement of genetic sequences"
  homepage "https://github.com/Pbdas/epa-ng"
  url "https://github.com/Pbdas/epa-ng/archive/v0.3.7.tar.gz"
  sha256 "780f031aa5edb256eb5604d76d0c6cee067de205ae32534d7c61f3a30b5e4c67"
  license "AGPL-3.0"
  head "https://github.com/Pbdas/epa-ng.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "042e63929c6496d9c5fe6ff99d98664254d5958fd79eb2d810b573aab6bf8359" => :catalina
    sha256 "047d85f86681ca76b93f45d25f78b5b8b6cf607b9b0bc3dab70748ab03f5e771" => :x86_64_linux
  end

  depends_on "cmake" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end
    bin.install "bin/epa-ng"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/epa-ng --version")
  end
end
