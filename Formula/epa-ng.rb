class EpaNg < Formula
  # cite Barbera_2018: "https://doi.org/10.1093/sysbio/syy054"
  desc "Massively parallel phylogenetic placement of genetic sequences"
  homepage "https://github.com/Pbdas/epa-ng"
  url "https://github.com/Pbdas/epa-ng/archive/v0.3.6.tar.gz"
  sha256 "964675e75f192dd680678edb087b2552a1d2f1e3c6b78cb0a1e5c9f5bd80a146"
  head "https://github.com/Pbdas/epa-ng.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "7307cf15a282c14dcb64c9b0bcb8f31d4512e866f74196f766826e4afefcc7d1" => :sierra
    sha256 "a7704605db8d0be2014651b8f96503ec4e1de9e2e155e3f40741fafc8a1fe1e5" => :x86_64_linux
  end

  depends_on "cmake" => :build
  unless OS.mac?
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "zlib"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end
    bin.install "bin/epa-ng"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/epa-ng --help")
  end
end
