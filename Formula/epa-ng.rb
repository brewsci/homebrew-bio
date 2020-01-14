class EpaNg < Formula
  # cite Barbera_2018: "https://doi.org/10.1093/sysbio/syy054"
  desc "Massively parallel phylogenetic placement of genetic sequences"
  homepage "https://github.com/Pbdas/epa-ng"
  url "https://github.com/Pbdas/epa-ng/archive/v0.3.6.tar.gz"
  sha256 "964675e75f192dd680678edb087b2552a1d2f1e3c6b78cb0a1e5c9f5bd80a146"
  head "https://github.com/Pbdas/epa-ng.git"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "66e08b52597ad0c8d192c1f715cfdcee81044dc4f13cb19f651eab2a5f07d6c7" => :mojave
    sha256 "7da900967d585bc432182fc07ea1057f9cc54fc6e836574837b062d223a216b2" => :x86_64_linux
  end

  depends_on "cmake" => :build
  unless OS.mac?
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

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
