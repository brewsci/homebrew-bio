class EpaNg < Formula
  # cite Barbera_2018: "https://doi.org/10.1093/sysbio/syy054"
  desc "Massively parallel phylogenetic placement of genetic sequences"
  homepage "https://github.com/Pbdas/epa-ng"
  url "https://github.com/Pbdas/epa-ng/archive/v0.3.8.tar.gz"
  sha256 "d1db23919f49cfad202b18623e5eb30c3d6cedcc1705b944221daea8131cbb74"
  license "AGPL-3.0"
  head "https://github.com/Pbdas/epa-ng.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "24bf0668e2555f23cb00eeab26fc3c63f5ff1911bbd6cf57a8fe68cc46e11ef0" => :catalina
    sha256 "71b2578583040741c1e4de704489d5b10a097985037edf8508bd7b203cb72382" => :x86_64_linux
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
