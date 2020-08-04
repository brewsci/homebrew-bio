class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Highly parallel build/index of coloured/compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
  url "https://github.com/pmelsted/bifrost/archive/v1.0.4.tar.gz"
  sha256 "94ac84861c36bc3fb9ea7b4a630ce391c79236289e5fab7aa627dc07b286f013"
  license "BSD-2-Clause"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "32feacf248a6aeaacb0356ff67683c0ea4925bd8bba1fbf3d191044757654e80" => :catalina
    sha256 "a036fa50004f01367a8e7cc95a90e9ca4303f01dc1d80f1ab8fd7f2e5632a0f4" => :x86_64_linux
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
