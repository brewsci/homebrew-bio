class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Highly parallel build/index of coloured/compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
<<<<<<< HEAD
  url "https://github.com/pmelsted/bifrost/archive/v1.0.3.tar.gz"
  sha256 "22f3637e524ba707b33d9351f544731d46fa30795e41c223ef0592f90b3be422"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "7b1dd408c758d9b1d32eb90084b59c9bc63973c16ec1768c9f20782ffdf3c264" => :catalina
    sha256 "a688f96b6a5d61e900001e2332267c8e563e6b82652348649032b2dd23d3ede2" => :x86_64_linux
=======
  url "https://github.com/pmelsted/bifrost/archive/v1.0.4.tar.gz"
  sha256 "94ac84861c36bc3fb9ea7b4a630ce391c79236289e5fab7aa627dc07b286f013"
  license "BSD-2-Clause"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "32feacf248a6aeaacb0356ff67683c0ea4925bd8bba1fbf3d191044757654e80" => :catalina
    sha256 "a036fa50004f01367a8e7cc95a90e9ca4303f01dc1d80f1ab8fd7f2e5632a0f4" => :x86_64_linux
>>>>>>> upstream/develop
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
